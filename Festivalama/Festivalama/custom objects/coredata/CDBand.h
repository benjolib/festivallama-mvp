//
//  CDBand.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 11/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDFestival;

@interface CDBand : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) CDFestival *festival;

@end
