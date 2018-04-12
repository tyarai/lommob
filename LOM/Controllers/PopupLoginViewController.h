//
//  PopupLoginViewController.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"
#import "BaseViewController.h"

@protocol PopupLoginViewControllerDelegate <NSObject>
- (void) cancel;
- (void) validWithUserName:(NSString*) userName password:(NSString*) password andRememberMe:(BOOL) rememberMe;
@end


@interface PopupLoginViewController : BaseViewController <UITextFieldDelegate,SignUpViewControllerDelegate>{
    CGFloat constraint;
    //SignUpViewController * signUpViewController;
}

@property (nonatomic, retain) id<PopupLoginViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *loginTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) SignUpViewController * signUpViewController;

- (IBAction)createAccountTapped:(id)sender;

@end
