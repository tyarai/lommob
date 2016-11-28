

#import <UIKit/UIKit.h>

#import "PopupLoginViewController.h"
#import "WYPopoverController.h"
#import "BaseViewController.h"
#import "MWPhotoBrowser.h"
#import "Species.h"
#import "PostsTableViewCell.h"
#import "CameraViewController.h"
#import "Publication.h"



@interface PostsViewController : BaseViewController <UITableViewDataSource, UITextFieldDelegate,UITableViewDelegate, PopupLoginViewControllerDelegate, WYPopoverControllerDelegate,MWPhotoBrowserDelegate,CameraViewControllerDelegate,SightingDataTableViewControllerDelegate>{
    
    NSArray* _sightingsList;
    BOOL isSearchShown;
    BOOL isAdding;
   
    MWPhotoBrowser *browser;
    WYPopoverController* popoverController;
    PopupLoginViewController * loginPopup;
    
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
- (IBAction)addButtonTapped:(id)sender;


@property (strong) Species * selectedSpecies;
@property (strong) Publication * selectedPublication;

-(void) loadOnlineSightings;
-(void) reloadData;
- (void) loadLocalSightings;
//-(void) synWithServer;

@end
