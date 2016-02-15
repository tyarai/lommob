//
//  IntroPageRootViewController.h
//  LOM
//
//  Created by Ranto Andrianavonison on 14/02/2016.

//

#import <UIKit/UIKit.h>
#import "IntroPageContentViewController.h"

@interface IntroPageRootViewController : UIViewController <UIPageViewControllerDataSource>
- (IBAction)startAgainTapped:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property(strong,nonatomic) NSString * introFullText;
@property (strong,nonatomic) NSArray * pageText;



@end
