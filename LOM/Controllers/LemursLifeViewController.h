//
//  LemursLifeViewController.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTCSimpleActivityView.h"
#import "PopupLoginViewController.h"
#import "WYPopoverController.h"

@interface LemursLifeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PopupLoginViewControllerDelegate, WYPopoverControllerDelegate>{
    
    NSArray* _lemurLifeList;
    
    WYPopoverController* popoverController;

    MTCSimpleActivityView* activityScreen;
}

@end
