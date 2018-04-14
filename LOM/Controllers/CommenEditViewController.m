//
//  CommenEditViewController.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 06/11/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import "CommenEditViewController.h"

@interface CommenEditViewController ()

@end

@implementation CommenEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.currentComment == nil){
        self.vcTitle.text =  NSLocalizedString(@"add_comment_title",@"");
    }else {
         self.vcTitle.text =  NSLocalizedString(@"edit_comment_title",@"");
    }
    //self.navigationItem.titleView = nil;
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    if(self.currentComment){
        self.comment.text = self.currentComment._commentBody;
    }
    [self.comment becomeFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelTapped:(id)sender {
    
    [self.delegate cancel];
    
}

- (IBAction)saveTapped:(id)sender {
    [self.delegate saveComment:self.currentComment comment:self.comment.text];
}
@end
