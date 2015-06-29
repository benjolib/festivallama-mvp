//
//  GenreListTest.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CategoryDownloadClient.h"

@interface GenreListTest : XCTestCase
@property (nonatomic, strong) CategoryDownloadClient *genreDownloadClient;
@end

@implementation GenreListTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample {
//    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");
//}

- (void)testGenreListing
{
    XCTestExpectation *downloadingExpectation = [self expectationWithDescription:@"downloading genres"];

    self.genreDownloadClient = [CategoryDownloadClient new];
    [self.genreDownloadClient downloadAllCategoriesWithCompletionBlock:^(NSArray *sortedCategories, NSString *errorMessage, BOOL completed) {
        XCTAssert(completed);

        if (completed) {
            [downloadingExpectation fulfill];
        } else {

        }
    }];

    [self waitForExpectationsWithTimeout:6.0 handler:^(NSError *error) {
        if (error) {

        }
    }];
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
