//
//  WatchingSiteDetailsViewController.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 01/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "WatchingSiteDetailsViewController.h"

@interface WatchingSiteDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtText;

@end

@implementation WatchingSiteDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.lblTitle.text = self.lemursWatchingSites._title;
    self.txtText.text = self.lemursWatchingSites._body;
    
    
    //self.navigationItem.titleView = nil;
    //self.navigationItem.title = self.lemursWatchingSites._title;
    //[self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];

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

- (IBAction)btnBack_Touch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
