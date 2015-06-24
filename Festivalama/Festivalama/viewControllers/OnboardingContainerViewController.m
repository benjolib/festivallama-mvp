//
//  OnboardingContainerViewController.m
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 24/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "OnboardingContainerViewController.h"
#import "FestivalTransitionManager.h"
#import "WelcomeBaseViewController.h"
#import "GeneralSettings.h"
#import "FilterModel.h"
#import "MusicGenreSelectionViewController.h"
#import "QuestionsViewController.h"
#import "ContinueButton.h"
#import "OnboardingPageControlView.h"

@interface OnboardingContainerViewController () <MusicGenreSelectionViewControllerDelegate>
@property (nonatomic, strong) NSArray *viewControllerIdentitiesArray;
@property (nonatomic, strong) NSMutableArray *viewControllersArray;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) CGFloat currentHorizontalScrollOffset;
@property (nonatomic) CGFloat lastContentOffset;
@property (nonatomic, strong) FestivalTransitionManager *festivalTransitionManager;
@end

@implementation OnboardingContainerViewController

- (IBAction)moveToNextViewController:(id)sender
{
    if ([[self.viewControllersArray firstObject] isKindOfClass:[MusicGenreSelectionViewController class]])
    {
        MusicGenreSelectionViewController *genreSelectionViewController = (MusicGenreSelectionViewController*)[self.viewControllersArray firstObject];
        if (genreSelectionViewController.selectedGenresArray.count > 0) {
            [self showNextViewController];
        }
    }
}

- (void)musicGenreSelectionNumberOfSelectedItemsChanged:(NSInteger)numberOfSelectedItems
{
    [self.continueButton setEnabled:numberOfSelectedItems > 0];
}

- (void)setFilterByLocationEnabled:(BOOL)enabled
{
    self.onboardingModel.filterByGermany = enabled;
}

- (void)showNextViewController
{
    if (self.currentIndex <= self.viewControllerIdentitiesArray.count)
    {
        WelcomeBaseViewController *welcomeViewController = [self loadQuestionsViewControllerAtIndex:++self.currentIndex];
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame) * self.currentIndex, 0.0) animated:YES];
        [welcomeViewController reloadSelection];
    }
    else
    {
        [GeneralSettings setOnboardingViewed];
        [[FilterModel sharedModel] copySettingsFromOnboardingModel:self.onboardingModel];
        
        // move to festivals view
        if (!self.festivalTransitionManager) {
            self.festivalTransitionManager = [[FestivalTransitionManager alloc] init];
        }
        [self.festivalTransitionManager presentFestivalViewControllerOnViewController:self];
    }
}

- (WelcomeBaseViewController*)loadQuestionsViewControllerAtIndex:(NSInteger)index
{
    if (index >= self.viewControllerIdentitiesArray.count) {
        return nil;
    }
    
    // if viewController is already created & added, than we don't have to do all the things below
    if (index > self.viewControllersArray.count) {
        if ([self.viewControllersArray objectAtIndex:index]) {
            return [self.viewControllersArray objectAtIndex:index];
        }
    }
    
    NSString *identifier = self.viewControllerIdentitiesArray[index];
    QuestionsViewController *questionsViewController = (QuestionsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:identifier];
    [questionsViewController setOptionsToDisplay:[[self.onboardingModel onboardingOptionsArrayForIndex:index-1] copy]];
    [questionsViewController setViewTitle:[self.onboardingModel onboardingViewTitleForIndex:index-1]
                          backgroundImage:[self.onboardingModel onboardingBackgroundImageViewNameForIndex:index]];
    questionsViewController.indexOfView = index;
    questionsViewController.rootViewController = self;
    
    if (![self.viewControllersArray containsObject:questionsViewController]) {
        [self.viewControllersArray addObject:questionsViewController];
    }

    [self addViewControllerToScrollview:questionsViewController atIndex:index];

    return questionsViewController;
}

- (void)loadNextQuestionsViewController
{
    [self loadQuestionsViewControllerAtIndex:self.currentIndex+1];
}

#pragma mark - scrollView methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentIndex = page;
    
    if (page > 0) {
        [self.pageControl setCurrentDotIndex:page];
    }
    [self setContinueButtonVisible:page == 0];
    [self setPageControlVisible:page > 0 withCurrentIndex:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.lastContentOffset < scrollView.contentOffset.x) {
        [self loadNextQuestionsViewController];
    } else {
        WelcomeBaseViewController *viewController = self.viewControllersArray[self.currentIndex];
        [viewController reloadSelection];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.lastContentOffset = scrollView.contentOffset.x;
}

- (void)setPageControlVisible:(BOOL)visible withCurrentIndex:(NSInteger)index
{

}

- (void)setContinueButtonVisible:(BOOL)visible
{
    if (visible) {
        if (self.continueButtonHeightConstraint.constant == 50.0) {
            return;
        }
        self.continueButtonHeightConstraint.constant = 50.0;
    } else {
        if (self.continueButtonHeightConstraint.constant == 0.0) {
            return;
        }
        self.continueButtonHeightConstraint.constant = 0.0;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViewControllers];
    self.continueButton.enabled = NO;
    
    [self.pageControl setNumberOfDots:self.viewControllerIdentitiesArray.count];
}

- (void)setupViewControllers
{
    self.onboardingModel = [[OnboardingModel alloc] init];
    self.viewControllerIdentitiesArray = @[@"MusicGenreSelectionViewController", @"QuestionsViewController", @"QuestionsViewController", @"QuestionsViewController", @"QuestionsViewController"];
    
    MusicGenreSelectionViewController *musicGenreSelectionViewController = (MusicGenreSelectionViewController*)[self initialiseViewControllerWithIdentifier:[self.viewControllerIdentitiesArray firstObject]];
    musicGenreSelectionViewController.allGenresArray = [self.genresArray copy];
    musicGenreSelectionViewController.delegate = self;
    [musicGenreSelectionViewController setViewTitle:@"Welche Musik hörst du auf einem Festival?" backgroundImage:[self.onboardingModel onboardingBackgroundImageViewNameForIndex:0]];
    musicGenreSelectionViewController.rootViewController = self;
    musicGenreSelectionViewController.indexOfView = 0;
    
    self.currentIndex = 0;
    
    [self addViewControllerToScrollview:musicGenreSelectionViewController atIndex:0];
    
    if (!self.viewControllersArray) {
        self.viewControllersArray = [NSMutableArray array];
    }
    
    [self.viewControllersArray addObject:musicGenreSelectionViewController];
    [self loadQuestionsViewControllerAtIndex:1];
    [self loadQuestionsViewControllerAtIndex:2];
}

- (void)adjustScrollViewContentSize
{
    UIViewController *firstViewController = [self.viewControllersArray firstObject];
    CGFloat viewHeight = CGRectGetHeight(firstViewController.view.frame);
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * self.viewControllersArray.count, CGRectGetHeight(self.view.frame));
}

- (void)addViewControllerToScrollview:(UIViewController*)viewController atIndex:(NSInteger)index
{
    [self addChildViewController:viewController];
    
    CGRect viewFrame = viewController.view.frame;
    viewFrame.origin.x = CGRectGetWidth(self.view.frame) * index;
    viewFrame.size.width = CGRectGetWidth(self.scrollView.frame);
    viewController.view.frame = viewFrame;
    
    [self.scrollView addSubview:viewController.view];
    
    [viewController didMoveToParentViewController:self];
    [self adjustScrollViewContentSize];
}

- (UIViewController*)initialiseViewControllerWithIdentifier:(NSString*)identifier
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Onboarding" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
