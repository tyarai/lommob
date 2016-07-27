
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

@interface LemursLifeViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, PopupLoginViewControllerDelegate, WYPopoverControllerDelegate>{
    
    NSArray* _lemurLifeList;
    
    WYPopoverController* popoverController;
    
    
    
}


@property (weak, nonatomic) IBOutlet UILabel *viewTitle;

@end
