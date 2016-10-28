//
//  IntroPageRootViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 14/02/2016.

#import "IntroPageRootViewController.h"
#import "Menus.h"
#import "Constants.h"

@interface IntroPageRootViewController ()

@end

@implementation IntroPageRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=  NSLocalizedString(@"intro_title", @"");
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];

    
    Menus * introMenu = [Menus getMenuContentByMenuName:@"introduction"];
    _introFullText = [introMenu _menu_content ];
    self.pageText = [_introFullText componentsSeparatedByString:PAGE_SEPARATOR];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageVC"];
    self.pageViewController.dataSource = self;
    
    IntroPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    [[startingViewController textView] setText:_introFullText];
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    //self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroPageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroPageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageText count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (IntroPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageText count] == 0) || (index >= [self.pageText count])) {
       return nil;
    }
    
    // Create a new view controller and pass suitable data.
    IntroPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageContentVC"];
    pageContentViewController.pageIndex = index;
    pageContentViewController.text = self.pageText[index];
    
    return pageContentViewController;
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

- (IBAction)startAgainTapped:(id)sender {
}
@end
