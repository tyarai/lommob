//
//  ExtinctLemursNewViewController.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 12/10/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import "ExtinctLemursNewViewController.h"

@interface ExtinctLemursNewViewController ()

@end

@implementation ExtinctLemursNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"extinct_title",@"");
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];

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

@end
