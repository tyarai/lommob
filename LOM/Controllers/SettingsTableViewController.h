//
//  SettingsTableViewController.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 17/05/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController{
    UIActivityIndicatorView *spinner ;
    UIView * overlayView;
                                        
}
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *btnLogOUt;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIView *lifeListContentView;
@property (weak, nonatomic) IBOutlet UIView *lifeListDescriptionView;




@end
