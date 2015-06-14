//
//  CoreDataHandler.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "CoreDataHandler.h"
#import "FestivalModel.h"
#import "CDFestival.h"
#import "CDBand.h"
#import "CDGenre.h"

@interface CoreDataHandler ()
@property (readwrite, strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *masterManagedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSDateFormatter *sectionDateFormatter;
@end

@implementation CoreDataHandler

+ (instancetype)sharedHandler
{
    static CoreDataHandler *sharedHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHandler = [[self alloc] init];
    });
    return sharedHandler;
}

/// Return YES, if it is already exists in Core Data, otherwise save it
- (BOOL)addFestivalToFavorites:(FestivalModel*)festivalModel
{
    CDFestival *festival = [self festivalForFestivalModel:festivalModel];
    if (festival) {
        [self removeFestivalObject:festival];
        return YES;
    }

    festival = [NSEntityDescription insertNewObjectForEntityForName:@"CDFestival" inManagedObjectContext:self.mainManagedObjectContext];
    festival.name = festivalModel.name;
    festival.festivalID = festivalModel.festivalID;
    festival.festivalKey = festivalModel.festivalKey;
    festival.address = festivalModel.address;
    festival.postcode = festivalModel.postcode;
    festival.city = festivalModel.city;
    festival.country = festivalModel.country;
    festival.locationName = festivalModel.locationName;
    festival.phoneNumber = festivalModel.phoneNumber;
    festival.website = festivalModel.website;
    festival.sourceURL = festivalModel.sourceURL;
    festival.festivalDescription = festivalModel.festivalDescription;
    festival.admission = festivalModel.admission;
    festival.category = festivalModel.category;
    festival.rank = festivalModel.rank;
    festival.startDate = festivalModel.startDate;
    festival.endDate = festivalModel.endDate;

    if (!self.sectionDateFormatter) {
        self.sectionDateFormatter = [[NSDateFormatter alloc] init];
        self.sectionDateFormatter.dateFormat = @"MMM - YYYY";
    }

    festival.sectionTitle = [self.sectionDateFormatter stringFromDate:festivalModel.startDate];

    [self saveMainContext];

    return NO;
}

- (void)removeFestivalFromFavorites:(FestivalModel*)festivalModel
{
    CDFestival *festival = [self festivalForFestivalModel:festivalModel];
    if (festival) {
        [self removeFestivalObject:festival];
    }
}

- (BOOL)isFestivalSaved:(FestivalModel*)festivalModel
{
    CDFestival *festival = [self festivalForFestivalModel:festivalModel];
    if (festival) {
        return YES;
    }
    return NO;
}

- (CDFestival*)festivalForFestivalModel:(FestivalModel*)model
{
    return [self fetchFestivalWithID:model.festivalID];
}

- (void)removeFestivalObject:(CDFestival*)festival
{
    [self.mainManagedObjectContext deleteObject:festival];
    [self saveMainContext];
}

- (NSInteger)numberOfSavedFestivals
{
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:@"CDFestival" predicate:nil sortDescriptor:nil];
    NSError *error = nil;
    NSUInteger fetchedCount = [self.masterManagedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error fetching recordings: %@", error.localizedDescription);
    }
    return fetchedCount;
}

#pragma mark - fetching methods
- (NSArray*)allSavedFestivals
{
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:@"CDFestival" predicate:nil sortDescriptor:@[nameSortDescriptor]];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.masterManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error fetching recordings: %@", error.localizedDescription);
    }
    return fetchedObjects;
}

- (CDFestival*)fetchFestivalWithID:(NSString*)festivalID
{
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:@"CDFestival" predicate:[NSPredicate predicateWithFormat:@"festivalID == %@", festivalID] sortDescriptor:nil];

    NSError *error = nil;
    NSArray *festivals = [self.mainManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (festivals.count > 0) {
        return festivals.firstObject;
    }
    return nil;
}

- (NSFetchRequest*)fetchRequestForEntity:(NSString*)entityName predicate:(NSPredicate*)predicate sortDescriptor:(NSArray*)sortDescriptors
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.masterManagedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    // Specify how the fetched objects should be sorted
    if (sortDescriptors) {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }

    return fetchRequest;
}

- (void)clearDatabase
{
    [_masterManagedObjectContext lock];
    NSArray *stores = self.persistentStoreCoordinator.persistentStores;
    for (NSPersistentStore *store in stores) {
        NSError *error = nil;
        [_persistentStoreCoordinator removePersistentStore:store error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:&error];
        if (error) {
            NSLog(@"Error occured while deleting core data folder, error: %@", error.localizedDescription);
        }
    }
    [_masterManagedObjectContext unlock];
    _managedObjectModel = nil;
    _mainManagedObjectContext = nil;
    _masterManagedObjectContext = nil;
    _persistentStoreCoordinator = nil;

    [self masterManagedObjectContext];
    [self mainManagedObjectContext];
    [self persistentStoreCoordinator];
}

#pragma mark - mainManagedObjectContext setup
- (NSManagedObjectContext *)mainManagedObjectContext
{
    if (_mainManagedObjectContext) {
        return _mainManagedObjectContext;
    }

    _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainManagedObjectContext.parentContext = self.masterManagedObjectContext;
    _mainManagedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    return _mainManagedObjectContext;
}

- (void)saveMainContext
{
    [self.mainManagedObjectContext performBlock:^{
        NSError *error = nil;
        [self.mainManagedObjectContext save:&error];
        if (error) {
            NSLog(@"Error while saving MAIN CONTEXT: %@", error.localizedDescription);
        }
        [self saveMasterContext];
    }];
}

- (void)saveMasterContext
{
    [self.masterManagedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        [self.masterManagedObjectContext save:&error];
        if (error) {
            NSLog(@"Error occured while saving MASTER CONTEXT: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - private methods
/**
 *  Lazy getter to create the managed context
 */
- (NSManagedObjectContext *)masterManagedObjectContext
{
    if (_masterManagedObjectContext) {
        return _masterManagedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _masterManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_masterManagedObjectContext setPersistentStoreCoordinator:coordinator];
        _masterManagedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    }
    return _masterManagedObjectContext;
}

/**
 *  Lazy getter to create the model
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

/**
 *  Lazy getter to create the persistent coordinator
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self coreDataDirectory] URLByAppendingPathComponent:@"Festivalama.sqlite"];

    // Define the Core Data version migration options
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             NSFileProtectionCompleteUnlessOpen, NSPersistentStoreFileProtectionKey, nil];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        abort();
    }

    return _persistentStoreCoordinator;
}

- (NSURL*)coreDataDirectory
{
    NSString *folderPath;
    BOOL isDir;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] == 1)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        folderPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Festivalama"];

        if (![fileManager fileExistsAtPath:folderPath isDirectory:&isDir])
        {
            NSError *error = nil;
            if (![fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:@{NSFileProtectionKey:NSFileProtectionComplete} error:&error]) {
                NSLog(@"Couldn't create the folder, error: %@", error.localizedDescription);
            }
        }
    }
    return [NSURL fileURLWithPath:folderPath isDirectory:YES];
}

@end
