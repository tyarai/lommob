//
//  TermsOfUseViewController.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 24/10/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import "TermsOfUseViewController.h"

@interface TermsOfUseViewController ()

@end

@implementation TermsOfUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * _title = NSLocalizedString(@"terms_of_use_title", @"");
    
    self.navigationBar.topItem.title = _title;
    [self.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)acceptTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate acceptTerms];
}
- (IBAction)declineTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate declineTerms];
}

@end
