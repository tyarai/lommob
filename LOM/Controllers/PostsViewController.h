//
//  PostsViewController.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PopupLoginViewController.h"
#import "WYPopoverController.h"
#import "BaseViewController.h"
#import "MWPhotoBrowser.h"
#import "Species.h"
#import "PostsTableViewCell.h"


@interface PostsViewController : BaseViewController <UITableViewDataSource, UITextFieldDelegate,UITableViewDelegate, PopupLoginViewControllerDelegate, WYPopoverControllerDelegate,MWPhotoBrowserDelegate,PostTableViewCellDelegate>{
    
    NSArray* _sightingsList;
    BOOL isSearchShown;
   
    MWPhotoBrowser *browser;
    WYPopoverController* popoverController;
    
}
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
- (IBAction)searchButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

 @property BOOL pullToRefresh;
 @property BOOL initialLoad;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchHeight;
@property (weak, nonatomic) IBOutlet UILabel *viewTitle;
@property NSMutableArray * currentPhotos;   


@property (strong) Species * selectedSpecies;

-(void) loadOnlineSightings;

@end
