//
//  SplashViewController.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 28/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//
#import "PopupLoginViewController.h"
#import "WYPopoverController.h"
#import "PopupLoginViewController.h"
#import "SignUpViewController.h"

#import "BaseViewController.h"

@interface SplashViewController : BaseViewController <PopupLoginViewControllerDelegate, WYPopoverControllerDelegate>{
    WYPopoverController* popoverController;
    PopupLoginViewController* loginViewController;
    
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end
