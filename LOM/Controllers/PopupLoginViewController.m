//
//  PopupLoginViewController.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "PopupLoginViewController.h"
#import "Tools.h"

@interface PopupLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtuserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation PopupLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
- (IBAction)btnCancel_Touch:(id)sender {
    
    [self.delegate cancel];
    
}
- (IBAction)btnOK_Touch:(id)sender {
    
    if (![Tools isNullOrEmptyString:self.txtuserName.text] && ![Tools isNullOrEmptyString:self.txtPassword.text]) {
        
        [self.delegate validWithUserName:self.txtuserName.text andPassword:self.txtPassword.text];
        
    }
    
}


#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField isEqual:self.txtuserName]) {
        [self.txtPassword becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        
        [self btnOK_Touch:nil];
    }
    
    return YES;
    
}
@end
