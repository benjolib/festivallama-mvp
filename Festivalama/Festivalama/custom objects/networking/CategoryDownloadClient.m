//
//  CategoryDownloadClient.m
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 16/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "CategoryDownloadClient.h"
#import "GenreParser.h"

@interface CategoryDownloadClient ()
@property (nonatomic, strong) GenreParser *genreParser;
@end

@implementation CategoryDownloadClient

- (void)downloadAllCategoriesWithCompletionBlock:(void (^)(NSArray *sortedCategories, NSString *errorMessage, BOOL completed))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, kCategoriesList]]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        if (completed)
        {
            weakSelf.genreParser = [GenreParser new];
            NSArray *genresArray = [weakSelf.genreParser parseJSONData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(genresArray, errorMessage, YES);
            });
        }
        else
        {
            
        }
    }];
    
    [self startSessionTask:task];
}

- (void)dealloc
{
    self.genreParser = nil;
}

@end
