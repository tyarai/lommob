//
//  ExtinctLemursViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 27/02/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "Menus.h"
#import "ExtinctLemursViewController.h"

@interface ExtinctLemursViewController ()

@end

@implementation ExtinctLemursViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Menus * extinctLemursUrl = [Menus getMenuContentByMenuName:@"extinctlemurs"];
    NSString * strUrl = [extinctLemursUrl _menu_content ];

    NSURL * url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    // Do any additional setup after loading the view.
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
