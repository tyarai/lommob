//
//  WatchingSitesSelectorViewController.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 16/05/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import "BaseViewController.h"
#import "LemursWatchingSites.h"
#import "WatchingSiteMap.h"

@protocol WatchingSitesSelectorDelegate <NSObject>

-(void) cancelSiteSelector;
-(void) doneSiteSelector:(LemursWatchingSites*) selectedSite;

@end

@interface WatchingSitesSelectorViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate,WatchingSiteMapDelegate>{
    NSIndexPath * lastIndexPath;
    __weak IBOutlet UIToolbar *toolBar;
    BOOL isSearchShown;
}
@property (strong,nonatomic) id<WatchingSitesSelectorDelegate>delegate;
@property (strong,nonatomic) NSArray<LemursWatchingSites*> *sites;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCOnstraints;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;

@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;

@end
