
//
//  LemursLifeViewController.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupLoginViewController.h"
#import "WYPopoverController.h"
#import "BaseViewController.h"
#import "Species.h"

@interface LemursLifeViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,PopupLoginViewControllerDelegate, WYPopoverControllerDelegate>{
    
    NSMutableArray* _lemurLifeList;
    BOOL isSearchShown;
    
    WYPopoverController* popoverController;
    PopupLoginViewController * loginPopup;
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
- (IBAction)btnSearchTapped:(id)sender;

@property BOOL pullToRefresh;
@property (weak, nonatomic) IBOutlet UILabel *viewTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchHeight;
@property (strong,nonatomic) Species * currentSpecies;

- (IBAction)btnLogInTapped:(id)sender;

@end
