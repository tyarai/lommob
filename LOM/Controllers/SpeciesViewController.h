//
//  SpeciesViewController.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species.h"
#import "BaseViewController.h"
#import "PopupLoginViewController.h"
#import "WYPopoverController.h"

@interface SpeciesViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate,PopupLoginViewControllerDelegate>{
    BOOL isSearchShown;
    
    Species* _selectedSpecy;
    WYPopoverController* popoverController;
    PopupLoginViewController* loginViewController;
    BOOL ongoingLogin;
    
}

@property (nonatomic, strong) NSArray* _speciesArray;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;


@end
