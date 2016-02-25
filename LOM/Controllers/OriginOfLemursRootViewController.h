//
//  OriginOfLemursRootViewController.h
//  LOM
//
//  Created by Ranto Andrianavonison on 25/02/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OriginOfLemursRootViewController : UIViewController <UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property(strong,nonatomic) NSString * originOfLemursFullText;
@property (strong,nonatomic) NSArray * pageText;


@end
