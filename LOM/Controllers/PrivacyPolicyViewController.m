//
//  PrivacyPolicyViewController.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 20/10/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()

@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * _title = NSLocalizedString(@"privacy_policy_title", @"");
    
    self.navigationBar.topItem.title = _title;
    
    [self.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];
    

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate readPrivacyPolicy];
}
@end
