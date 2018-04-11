//
//  SettingsTableViewController.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 17/05/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupLoginViewController.h"

@interface SettingsTableViewController : UITableViewController <PopupLoginViewControllerDelegate>{
    UIActivityIndicatorView *spinner ;
    UIView * overlayView;
                                        
}
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *btnLogOUt;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIView *lifeListContentView;
@property (weak, nonatomic) IBOutlet UIView *lifeListDescriptionView;
@property (weak, nonatomic) IBOutlet UILabel *logginMessageLabel;

@property (weak, nonatomic) IBOutlet UILabel *updateText;

@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic)  PopupLoginViewController* loginViewController;



- (IBAction)tappedUpdateButton:(id)sender;


@end
