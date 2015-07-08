//
//  FestivalDownloadClient.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalDownloadClient.h"
#import "FestivalModel.h"
#import "FestivalParser.h"
#import "FilterModel.h"
#import "LocationManager.h"
#import "FilterPostcode.h"

@interface FestivalDownloadClient ()
@property (nonatomic, strong) FestivalParser *festivalParser;
@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) CLLocation *userLocation;
@end

@implementation FestivalDownloadClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self discoverUserLocation];
    }
    return self;
}

- (void)downloadFestivalsFromIndex:(NSInteger)startIndex limit:(NSInteger)numberOfItems filterModel:(FilterModel*)filterModel searchText:(NSString*)searchText andCompletionBlock:(void (^)(NSArray *festivalsArray, NSString *errorMessage, BOOL completed))completionBlock
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@?start=%ld&limit=%ld", kBaseURL, kFestivalsList, (long)startIndex, (long)numberOfItems];

    urlString = [self appendSearchText:searchText andFilterModel:filterModel fromURLString:urlString];
    [self downloadFestivalsWithURL:[NSURL URLWithString:urlString] andCompletionBlock:completionBlock];
}

- (void)downloadPopularFestivalsFromIndex:(NSInteger)startIndex limit:(NSInteger)numberOfItems searchText:(NSString*)searchText filterModel:(FilterModel*)filterModel andCompletionBlock:(void (^)(NSArray *festivalsArray, NSString *errorMessage, BOOL completed))completionBlock
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@?start=%ld&limit=%ld", kBaseURL, kPopularFestivalsList, (long)startIndex, (long)numberOfItems];

    urlString = [self appendSearchText:searchText andFilterModel:filterModel fromURLString:urlString];
    [self downloadFestivalsWithURL:[NSURL URLWithString:urlString] andCompletionBlock:completionBlock];
}

#pragma mark - private methods
- (NSMutableString*)appendSearchText:(NSString*)searchText andFilterModel:(FilterModel*)filterModel fromURLString:(NSMutableString*)urlString
{
    // add location data
    if (self.userLocation) {
        [urlString appendString:[NSString stringWithFormat:@"&lat=%f&lng=%f", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude]];
    }

    if (filterModel && searchText.length == 0) {
        if (filterModel.selectedCountriesArray.count > 0) {
            [urlString appendString:[NSString stringWithFormat:@"&country=%@", [filterModel countriesStringForAPICall]]];
        }
        if (filterModel.selectedPostCode && [filterModel isSelectedCountryGermany]) {
            [urlString appendString:[NSString stringWithFormat:@"&postcode=%@", [filterModel postcodeStringForAPICall]]];
        }
        if (filterModel.selectedGenresArray.count > 0) {
            [urlString appendString:[NSString stringWithFormat:@"&category=%@", [filterModel genresStringForAPICall]]];
        }
        if (filterModel.selectedBandsArray.count > 0) {
            [urlString appendString:[NSString stringWithFormat:@"&band=%@", [filterModel bandsStringForAPICall]]];
        }
    }

    if (searchText.length > 0) {
        [urlString appendString:[NSString stringWithFormat:@"&name=%@", [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }

    // add sorting
    [urlString appendString:@"&orderProperty=date_start"];

    return urlString;
}

#pragma mark - location manager methods
- (void)discoverUserLocation
{
    if (!self.locationManager) {
        self.locationManager = [[LocationManager alloc] init];
    }

    __weak typeof(self) weakSelf = self;
    [self.locationManager startLocationDiscoveryWithCompletionBlock:^(CLLocation *userLocation, NSString *errorMessage) {
        weakSelf.userLocation = userLocation;
        [weakSelf.locationManager stopLocationDiscovery];
    }];
}

#pragma mark - private methods
- (void)downloadFestivalsWithURL:(NSURL*)url andCompletionBlock:(void (^)(NSArray *festivalsArray, NSString *errorMessage, BOOL completed))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];

    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        if (completed)
        {
            if (!weakSelf.festivalParser) {
                weakSelf.festivalParser = [FestivalParser new];
            }
            NSArray *festivals = [weakSelf.festivalParser parseJSONData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(festivals, nil, YES);
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(nil, errorMessage, YES);
                }
            });
        }
    }];

    [self startSessionTask:task];
}

- (void)dealloc
{
    [self.locationManager stopLocationDiscovery];
    self.locationManager = nil;
}

@end
