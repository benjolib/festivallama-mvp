//
//  Country.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 15/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *flag;

+ (Country*)countryWithName:(NSString*)name flag:(NSString*)flag;

@end
