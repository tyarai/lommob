//
//  ExtinctLemursViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 27/02/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "Menus.h"
#import "ExtinctLemursViewController.h"
#import "Tools.h"
@import SafariServices;

@interface ExtinctLemursViewController ()

@end

@implementation ExtinctLemursViewController

-(id) init{
    self =[super init];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"extinct_title",@"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self.activityIndicator startAnimating];
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicator stopAnimating];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.activityIndicator stopAnimating];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)extinctLemursButtontapped:(id)sender {
}
@end
