//
//  SignUpViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 02/11/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "SignUpViewController.h"
#import "Tools.h"

@interface SignUpViewController ()


@end

@implementation SignUpViewController

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

-(IBAction)btnCancel_Touch:(id)sender {
    
    [self.delegate cancelSignUp];
    
}
- (IBAction)btnOK_Touch:(id)sender {
    NSString * error=nil;
    if([self validateUserNameEmailPassword:self.txtuserName email:self.txtEmail pass1:self.txtPassword1 pass2:self.txtPassword2 error:&error]){
            //----- Nety daholo ny username, password, ary email ---/
            [self.delegate signUpWithUserName:self.txtuserName.text email:self.txtEmail.text password:self.txtPassword1.text ];
        
    }
    
    if(error != nil){
        [Tools showSimpleAlertWithTitle:NSLocalizedString(@"signupTitle",@"") andMessage:error];
    }
    
    
}
-(BOOL) validateEmail:(NSString*) email{
   
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];

}


-(BOOL) validatePassword:(NSString*) pass{
    
    NSString *emailRegex = @"^[a-zA-Z_0-9\\-_#!$&@]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL value = [emailTest evaluateWithObject:pass];;
    return value;
    
}


-(BOOL) validateUserNameEmailPassword:(UITextField*)userName email:(UITextField*) email pass1:(UITextField*)pass1 pass2:(UITextField*)pass2 error:(NSString**)error{
    
    /*
     @TODO : Jerena raha mitovy ny pass1 sy pass2 eto sady tsy NULL ny username
     */
    if([Tools isNullOrEmptyString:userName.text]){
        [userName becomeFirstResponder];
        *error = NSLocalizedString(@"invalidUserName", @"");
        return NO;
    }
    
    if(![self validateEmail:email.text]){
        [email becomeFirstResponder];
        *error = NSLocalizedString(@"invalidEmail", @"");
        return NO;
    }
    
    if([Tools isNullOrEmptyString:pass1.text]  || [Tools isNullOrEmptyString:pass2.text] || ![self validatePassword:pass1.text] || ![self validatePassword:pass2.text]){
        *error = NSLocalizedString(@"invalidPasswords", @"");
        return NO;
    }
    
    if(![pass1.text isEqualToString:pass2.text]){
        *error = NSLocalizedString(@"passwordsDoNotMatch", @"");
        return NO;

    }
    
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma UITextFieldDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
    
    CGFloat titleHeight = self.viewTitle.frame.size.height;
    CGFloat newConstraint = constraint + height - (titleHeight*2);//titleHeight;
    self.bottomConstraint.constant = newConstraint;
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


@end
