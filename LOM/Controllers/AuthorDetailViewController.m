//
//  AuthorDetailViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 16/03/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "AuthorDetailViewController.h"

@interface AuthorDetailViewController ()

@end

@implementation AuthorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.selectedAuthor != nil){
        self.navigationItem.title = self.selectedAuthor._name;
        UIImage *image = [UIImage imageNamed:self.selectedAuthor._photo];
        [self.photo setImage:image];
        self.detail.text  = self.selectedAuthor._details;
    }
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
