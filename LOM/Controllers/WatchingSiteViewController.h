//
//  WatchingSiteViewController.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LemursWatchingSites.h"

@interface WatchingSiteViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    BOOL isSearchShown;
    
    LemursWatchingSites* _selectedLemursWatchingSites;
}

@property (nonatomic, strong) NSArray* _lemursWatchingSitesArray;

@end
