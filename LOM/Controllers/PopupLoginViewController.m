//
//  PopupLoginViewController.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "PopupLoginViewController.h"
#import "SignUpViewController.h"
#import "Tools.h"

@interface PopupLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtuserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UISwitch *switchRemeberMe;

@end

@implementation PopupLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    constraint = self.bottomConstraint.constant;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self deregisterFromKeyboardNotifications];
    
}

-(void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat height = keyboardSize.height ;
    
    self.bottomConstraint.constant = constraint + height - self.loginTitle.frame.size.height;
    [self.controlView setNeedsUpdateConstraints];
    
    
    
    [UIView animateWithDuration:0.3
     animations:^{
         
            [self.view layoutIfNeeded];
            self.logo.alpha   = 0;
         
    } ];
    
    
    
    
}


- (void)keyboardWillBeHidden:(NSNotification *)notification {
    
    self.bottomConstraint.constant = constraint;
    [self.controlView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                         self.logo.alpha   = 1;
                     } ];

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)btnCancel_Touch:(id)sender {
    
    [self.delegate cancel];
    
}
- (IBAction)btnOK_Touch:(id)sender {
    
    if (![Tools isNullOrEmptyString:self.txtuserName.text] && ![Tools isNullOrEmptyString:self.txtPassword.text]) {
    
        [self.delegate validWithUserName:self.txtuserName.text password:self.txtPassword.text andRememberMe:[self.switchRemeberMe isOn]];
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
- (IBAction)createAccountTapped:(id)sender{
    
    NSString* indentifier=@"signUpVC";
    signUpViewController = (SignUpViewController*) [Tools getViewControllerFromStoryBoardWithIdentifier:indentifier];
    signUpViewController.delegate = self;
    
    [self presentViewController:signUpViewController animated:YES completion:nil];
}


#pragma SignUpDelegate

-(void)cancelSignUp{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) signUpWithUserName:(NSString*) userName email:(NSString*)email password:(NSString*) password{
    if(![Tools isNullOrEmptyString:userName] && ![Tools isNullOrEmptyString:password] && ![Tools isNullOrEmptyString:email]){
        
        [self showActivityScreen];
        [appData registerUserName:userName password:password mail:email forCompletion:^(id json, JSONModelError *err) {
            
            [self removeActivityScreen];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            if(err != nil){
                [Tools showError:err onViewController:signUpViewController];
            }else{
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:NSLocalizedString(@"signupTitle", @"")
                                             message:NSLocalizedString(@"signUpSuccessfull", @"")
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:NSLocalizedString(@"connectUsingNewAccount",@"")
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            //BaseViewController * delegate = (BaseViewController*)self.delegate;
                                            //[delegate dismissViewControllerAnimated:YES completion:nil];
                                            [self.delegate validWithUserName:userName
                                                                    password:password
                                                               andRememberMe:YES];

                                            }];
                UIAlertAction* noButton = [UIAlertAction
                                            actionWithTitle:NSLocalizedString(@"connectUsingOtherAccount",@"")
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                
                                            //[self dismissViewControllerAnimated:YES completion:nil];
                                            //BaseViewController * delegate = (BaseViewController*)self.delegate;
                                            //[delegate dismissViewControllerAnimated:YES completion:nil];
                                                
                                            }];

                
                [alert addAction:yesButton];
                [alert addAction:noButton];

                [self presentViewController:alert animated:YES completion:nil];
                
                
            }
        }];
    }
}

@end
