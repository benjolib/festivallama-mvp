//
//  QuestionsContainerViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "QuestionsContainerViewController.h"
#import "MusicGenreSelectionViewController.h"

@interface QuestionsContainerViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *viewControllerIdentitiesArray;
@property (nonatomic) NSInteger currentIndex;
@end

@implementation QuestionsContainerViewController


- (void)setupPageViewController
{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;

    // Add the page view controller to this root view controller.
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - pageViewController methods
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
//{
//
//}
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
//{
//
//}

//- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
//{
//
//}

//- (NSArray *)pageViewControllerAtIndexes:(NSIndexSet *)indexes
//{
//
//}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.viewControllerIdentitiesArray.count;
}

//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//
//}

#pragma mark - helper methods
- (UIViewController*)initialiseViewControllerWithIdentifier:(NSString*)identifier
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupPageViewController];

    self.viewControllerIdentitiesArray = @[@"MusicGenreSelectionViewController", @"QuestionsViewController"];

    MusicGenreSelectionViewController *musicGenreSelectionViewController = (MusicGenreSelectionViewController*)[self initialiseViewControllerWithIdentifier:[self.viewControllerIdentitiesArray firstObject]];
    musicGenreSelectionViewController.allGenresArray = [self.genresArray copy];
    self.currentIndex = 0;

    [self.pageViewController setViewControllers:@[musicGenreSelectionViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:^(BOOL finished) {
                                         // Completion code
                                     }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc
{
    self.viewControllerIdentitiesArray = nil;
}

@end
