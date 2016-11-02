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
    
    if (![Tools isNullOrEmptyString:self.txtuserName.text] && ![Tools isNullOrEmptyString:self.txtPassword1.text]  && ![Tools isNullOrEmptyString:self.txtPassword2.text]) {
        
        if([self validateUserNameAndPassword:self.txtuserName.text pass1:self.txtPassword1.text pass2:self.txtPassword2.text]){
            [self.delegate signUpWithUserName:self.txtuserName.text password:self.txtPassword1.text ];
        
        }else{
            /*
             @TODO Show Message : Tsy mitovy ny pass1 sy pass2 eto
             */
        }
    }
    
}

-(BOOL) validateUserNameAndPassword:(NSString*)userName pass1:(NSString*)pass1 pass2:(NSString*)pass2{
   
    /*
     @TODO : Jerena raha mitovy ny pass1 sy pass2 eto
     */
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
    
    self.bottomConstraint.constant = constraint + height - self.viewTitle.frame.size.height;
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
