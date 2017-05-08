//
//  OriginOfLemursPageContentViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 25/02/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "OriginOfLemursPageContentViewController.h"

@interface OriginOfLemursPageContentViewController ()

@end

@implementation OriginOfLemursPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.textView.text =self.text;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
    });
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
