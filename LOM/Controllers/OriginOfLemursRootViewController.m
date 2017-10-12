//
//  OriginOfLemursRootViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 25/02/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "OriginOfLemursRootViewController.h"
#import "OriginOfLemursPageContentViewController.h"
#import "Menus.h"
#import "Constants.h"

@interface OriginOfLemursRootViewController ()

@end

@implementation OriginOfLemursRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   self.navigationItem.title=  NSLocalizedString(@"Origin of lemurs", @"Origin of lemurs");
   [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];
    
 Menus * originMenu = [Menus getMenuContentByMenuName:@"origin"];
   _originOfLemursFullText = [originMenu _menu_content ];
    self.pageText = [ _originOfLemursFullText componentsSeparatedByString:PAGE_SEPARATOR];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageVC"];
    self.pageViewController.dataSource = self;
    
    OriginOfLemursPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    [[startingViewController textView] setText:_originOfLemursFullText ];

    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController: _pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (OriginOfLemursPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageText count] == 0) || (index >= [self.pageText count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
   OriginOfLemursPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OriginOfLemursPageContentVC"];
    pageContentViewController.pageIndex = index;
    pageContentViewController.text = self.pageText[index];
    
    return pageContentViewController;
}


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index =( (OriginOfLemursPageContentViewController*)viewController).pageIndex;
    
    if(index ==0 || index == NSNotFound){
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = ((OriginOfLemursPageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageText count]) {
        return nil;
    }

    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageText count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
