//
//  RootPageController.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 29/09/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import "RootPageController.h"
#import "InstructionsViewController.h"

@interface RootPageController ()

@end

@implementation RootPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageTitles = @[@"Species screen",
                    @"Menu screen",
                    @"Add sighting",
                    @"Sighting info1",
                    @"Sighting info2"
                    ];
    _pageImages = @[@"home_screen.jpg",
                    @"menu_screen.jpg",
                    @"add_sightins.jpg",
                    @"sighting_info_1.jpg",
                    @"sighting_info_2.jpg"
                    
                    ];
    // Do any additional setup after loading the view.
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    InstructionsViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController
     setViewControllers:viewControllers
     direction:UIPageViewControllerNavigationDirectionForward
     animated:NO
     completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((InstructionsViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((InstructionsViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (InstructionsViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    InstructionsViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
