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
#import "SVProgressHUD.h"

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
    self.signUpViewController = (SignUpViewController*) [Tools getViewControllerFromStoryBoardWithIdentifier:indentifier];
    self.signUpViewController.delegate = self;
    
    [self presentViewController:self.signUpViewController animated:YES completion:nil];
}


#pragma SignUpDelegate

-(void)cancelSignUp{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) signUpWithUserName:(NSString*) userName email:(NSString*)email password:(NSString*) password{
    if(![Tools isNullOrEmptyString:userName] && ![Tools isNullOrEmptyString:password] && ![Tools isNullOrEmptyString:email]){
        
        [SVProgressHUD setBackgroundColor:[UIColor lightGrayColor]];
        [SVProgressHUD show];
        
        [appData registerUserName:userName password:password mail:email forCompletion:^(id json, JSONModelError *err) {
            
            [SVProgressHUD dismiss];
            //[self dismissViewControllerAnimated:YES completion:nil];
            
            if(err != nil){
                NSDictionary * jsonError = (NSDictionary*)json;
                NSDictionary * errorMess = (NSDictionary*) [jsonError valueForKey:@"form_errors"];
                __block NSMutableString * mess = [[NSMutableString alloc]init];
                [errorMess enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    obj = [Tools htmlToString:(NSString*)obj];
                    mess = (NSMutableString*)[mess stringByAppendingString:(NSString*)obj];
                }];
                if([mess length]>0){
                    //[Tools showSimpleAlertWithTitle:NSLocalizedString(@"signupTitle",@"") andMessage:mess parentView:self];
                    UIAlertController * alert = [Tools handleErrorWithErrorMessage:mess title:NSLocalizedString(@"signupTitle",@"")];
                    [self.signUpViewController presentViewController:alert animated:YES completion:nil];
                }else{
                    [Tools showError:err onViewController:self];
                }
              
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:NSLocalizedString(@"signupTitle", @"")
                                             message:NSLocalizedString(@"signUpSuccessfull", @"")
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:NSLocalizedString(@"connectUsingNewAccount",@"")
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            [self.delegate validWithUserName:userName
                                                                    password:password
                                                               andRememberMe:YES];

                                            }];
                UIAlertAction* noButton = [UIAlertAction
                                            actionWithTitle:NSLocalizedString(@"connectUsingOtherAccount",@"")
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                
                                            }];

                alert.view.tintColor = [UIColor blackColor];
                [alert addAction:yesButton];
                [alert addAction:noButton];

                [self presentViewController:alert animated:YES completion:nil];
                
                
            }
        }];
    }
}

@end
