//
//  QuestionsContainerViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "QuestionsContainerViewController.h"
#import "MusicGenreSelectionViewController.h"
#import "QuestionsViewController.h"
#import "OnboardingModel.h"

#import "StoryboardManager.h"
#import "FestivalNavigationController.h"
#import "FestivalTransitionManager.h"
#import "GeneralSettings.h"

@interface QuestionsContainerViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *viewControllerIdentitiesArray;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) OnboardingModel *onboardingModel;
@property (nonatomic, strong) FestivalTransitionManager *festivalTransitionManager;
@end

@implementation QuestionsContainerViewController

- (void)setFilterByLocationEnabled:(BOOL)enabled
{
    self.onboardingModel.filterByGermany = enabled;
}

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

- (void)showNextViewController
{
    UIViewController *nextViewController = [self nextViewController];

    if (nextViewController) {
        [self.pageViewController setViewControllers:@[nextViewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
    } else {
        [GeneralSettings setOnboardingViewed];
        
        // move to festivals view
        if (!self.festivalTransitionManager) {
            self.festivalTransitionManager = [[FestivalTransitionManager alloc] init];
        }
        [self.festivalTransitionManager presentFestivalViewControllerOnViewController:self];
    }
}

- (UIViewController*)nextViewController
{
    // Get index of current view controller
    WelcomeBaseViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    NSUInteger index = currentViewController.indexOfView;

    NSLog(@"Current index: %ld", (long)self.currentIndex);

    UIViewController *nextViewController = [self viewControllerAtIndex:index+1];
    self.pageControl.currentPage = index + 1;

    if (index+1 >= 2) {
        self.pageControl.hidden = NO;
    }

    return nextViewController;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Only process a valid index request.
    if (index >= self.viewControllerIdentitiesArray.count) {
        return nil;
    }
    // Create a new view controller.
    WelcomeBaseViewController *contentViewController = (WelcomeBaseViewController *)[self.storyboard instantiateViewControllerWithIdentifier:self.viewControllerIdentitiesArray[index]];
    // Set any data needed by the VC here
    contentViewController.rootViewController = self;

    if ([contentViewController isKindOfClass:[MusicGenreSelectionViewController class]]) {
        MusicGenreSelectionViewController *genreViewController = (MusicGenreSelectionViewController*)contentViewController;
        if (index == 0) {
            [genreViewController setViewTitle:@"Welche Musik hörst du auf einem Festival? (1/2)" backgroundImage:[self.onboardingModel onboardingBackgroundImageViewNameForIndex:0]];
            genreViewController.allGenresArray = [self.genresArray copy]; // TODO: don't pass on all the genres
        } else {
            [genreViewController setViewTitle:@"Welche Musik hörst du auf einem Festival? (2/2)" backgroundImage:[self.onboardingModel onboardingBackgroundImageViewNameForIndex:1]];
            genreViewController.allGenresArray = [self.genresArray copy]; // TODO: don't pass on all the genres
        }
        genreViewController.indexOfView = index;
        contentViewController = genreViewController;
    } else {
        QuestionsViewController *questionsViewController = (QuestionsViewController*)contentViewController;
        [questionsViewController setOptionsToDisplay:[[self.onboardingModel onboardingOptionsArrayForIndex:index-2] copy]];
        [questionsViewController setViewTitle:[self.onboardingModel onboardingViewTitleForIndex:index-2]
                              backgroundImage:[self.onboardingModel onboardingBackgroundImageViewNameForIndex:index]];
        questionsViewController.pageNumber = index - 2;
        questionsViewController.indexOfView = index;
        contentViewController = questionsViewController;
    }

    return contentViewController;
}

#pragma mark - pageViewController methods
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(WelcomeBaseViewController*)viewController
{
    NSUInteger currentViewIndex = viewController.indexOfView;
    if (currentViewIndex > 1) {
        return nil;
    }

//    if (currentViewIndex == self.viewControllerIdentitiesArray.count - 1) {
//        return nil;
//    }
//
    return [self viewControllerAtIndex:currentViewIndex + 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(WelcomeBaseViewController *)viewController
{
    NSUInteger currentViewIndex = viewController.indexOfView;

    if (currentViewIndex == 0) {
        return nil;
    }

    return [self viewControllerAtIndex:currentViewIndex - 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    self.pageControl.currentPage = self.currentIndex;
    self.pageControl.hidden = self.currentIndex < 2;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    if (pendingViewControllers.count > 0) {
        if ([pendingViewControllers[0] isKindOfClass:[WelcomeBaseViewController class]]) {
            WelcomeBaseViewController *baseViewController = (WelcomeBaseViewController*)pendingViewControllers[0];
            self.currentIndex = baseViewController.indexOfView;
        }
    }
}

#pragma mark - helper methods
- (UIViewController*)initialiseViewControllerWithIdentifier:(NSString*)identifier
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Onboarding" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupPageViewController];

    self.onboardingModel = [[OnboardingModel alloc] init];
    self.viewControllerIdentitiesArray = @[@"MusicGenreSelectionViewController", @"MusicGenreSelectionViewController", @"QuestionsViewController", @"QuestionsViewController", @"QuestionsViewController", @"QuestionsViewController"];

    MusicGenreSelectionViewController *musicGenreSelectionViewController = (MusicGenreSelectionViewController*)[self initialiseViewControllerWithIdentifier:[self.viewControllerIdentitiesArray firstObject]];
    musicGenreSelectionViewController.allGenresArray = [self.genresArray copy];
    [musicGenreSelectionViewController setViewTitle:@"Welche Musik hörst du auf einem Festival? (1/2)" backgroundImage:[self.onboardingModel onboardingBackgroundImageViewNameForIndex:0]];
    musicGenreSelectionViewController.rootViewController = self;
    musicGenreSelectionViewController.indexOfView = 0;
    self.currentIndex = 0;

    [self.pageViewController setViewControllers:@[musicGenreSelectionViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];

    [self addPageControl];
}

- (void)addPageControl
{
    // add pageControl at the bottom of the view
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.bounds) - 20.0, self.view.bounds.size.width, 20.0)];
    self.pageControl.numberOfPages = self.viewControllerIdentitiesArray.count + 1;
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.pageControl.hidden = YES;

    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor colorWithWhite:1.0 alpha:0.1]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [self.view addSubview:self.pageControl];
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
