//
//  AuthorDetailViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 16/03/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "AuthorDetailViewController.h"
#import "UIImage+Resize.h"
#import "Constants.h"

@interface AuthorDetailViewController ()

@end

@implementation AuthorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:WHITE_COLOR }];
    self.navigationItem.leftBarButtonItem.tintColor = ORANGE_COLOR;
    self.navigationItem.leftBarButtonItem.title = @"";
    self.navigationController.navigationBar.tintColor = ORANGE_COLOR;
    if(self.selectedAuthor != nil){
        self.navigationItem.title = self.selectedAuthor._name;
        UIImage *image = [UIImage imageNamed:self.selectedAuthor._photo];
        [self.photo setImage:image];
        self.detail.text  = self.selectedAuthor._details;
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.detail scrollRangeToVisible:NSMakeRange(0, 0)];
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
