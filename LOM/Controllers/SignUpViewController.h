//
//  SignUpViewController.h
//  LOM
//
//  Created by Ranto Andrianavonison on 02/11/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "BaseViewController.h"
#import "PrivacyPolicyViewController.h"
#import "TermsOfUseViewController.h"

@protocol SignUpViewControllerDelegate <NSObject>
- (void) cancelSignUp;
- (void) signUpWithUserName:(NSString*) userName email:(NSString*)email password:(NSString*) password ;
@end


@interface SignUpViewController : BaseViewController <UITextViewDelegate,TermsOfUseViewControllerDelegate,PrivacyPolicyViewControllerDelegate>{
    CGFloat constraint;
    BOOL acceptTermsOfUse;
    BOOL readPrivacyPolicy;
}

@property (nonatomic, retain) id<SignUpViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtuserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword1;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword2;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet UILabel *viewTitle;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property BOOL keyboardShown;

@end
