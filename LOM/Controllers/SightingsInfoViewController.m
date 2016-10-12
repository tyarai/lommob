//
//  SightingsInfoViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 09/10/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "SightingsInfoViewController.h"
#import "Constants.h"

@interface SightingsInfoViewController ()

@end

@implementation SightingsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.doneBUtton.tintColor = ORANGE_COLOR;
    self.cancelButton.tintColor = ORANGE_COLOR;
    self.view.backgroundColor = [UIColor whiteColor];
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

- (IBAction)cancelTapped:(id)sender {
    [self.delegate cancel];
}

- (IBAction)doneTapped:(id)sender {
    NSString  * comments = self.comments.text;
    NSInteger obs      = [self.numberObserved.text intValue];
    NSString  * place    = self.placename.text;
    [self.delegate saveSightingInfo:obs placeName:place comments:comments];
    
}
#pragma UITextFieldDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


@end
