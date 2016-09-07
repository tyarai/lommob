//
//  BaseViewController.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 25/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "BaseViewController.h"
#import "Tools.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appData = [AppData getInstance];
    
    appDelegate = [Tools getAppDelegate];
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

-(void)removeActivityScreen
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (activityScreen != nil)
        {
            [activityScreen removeFromSuperview];
            activityScreen = nil;
        }
    });
}

-(void)initActivityScreen:(NSString*)messageActivity
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (activityScreen != nil)
        {
            [activityScreen removeFromSuperview];
            activityScreen = nil;
        }
        activityScreen =[[MTCSimpleActivityView alloc]initWithFrame:[Tools generateFrame:CGRectMake(0, 0, [Tools getScreenWidth], [Tools getScreenHeight])] withTextActivity:messageActivity];
        
        if (appDelegate == nil) {
            appDelegate = [Tools getAppDelegate];
        }
        
        [appDelegate.window addSubview:activityScreen];
    });
}

-(void) showActivityScreen
{
    [self initActivityScreen:NSLocalizedString(@"please_wait", @"")];
}

-(AppDelegate*) getAppDelegate{
    return appDelegate;
}

@end
