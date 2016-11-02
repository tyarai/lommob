//
//  SignUpViewController.h
//  LOM
//
//  Created by Ranto Andrianavonison on 02/11/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "BaseViewController.h"

@protocol SignUpViewControllerDelegate <NSObject>
- (void) cancelSignUp;
- (void) signUpWithUserName:(NSString*) userName password:(NSString*) password ;
@end


@interface SignUpViewController : BaseViewController <UITextViewDelegate>{
    CGFloat constraint;
}

@property (nonatomic, retain) id<SignUpViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtuserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword1;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet UILabel *viewTitle;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end
