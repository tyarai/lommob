

#import <UIKit/UIKit.h>

#import "PopupLoginViewController.h"
#import "WYPopoverController.h"
#import "BaseViewController.h"
#import "MWPhotoBrowser.h"
#import "Species.h"
#import "PostsTableViewCell.h"
#import "CameraViewController.h"
#import "Publication.h"
#import "SightingDataTableViewController.h"


@interface PostsViewController : BaseViewController <UITableViewDataSource, UITextFieldDelegate,UITableViewDelegate, PopupLoginViewControllerDelegate, WYPopoverControllerDelegate,MWPhotoBrowserDelegate,SightingDataTableViewControllerDelegate,UIScrollViewDelegate>{
    
    NSArray* _sightingsList;
    BOOL isSearchShown;
    BOOL isAdding;
    
   
    MWPhotoBrowser *browser;
    WYPopoverController* popoverController;
    PopupLoginViewController * loginPopup;
    //dispatch_queue_t serialQueue;
    
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



@property NSInteger currentPage;
 


//@property (strong) Species * selectedSpecies;
//@property (strong) Publication * selectedPublication;


-(void) loadOnlineSightings;
-(void) reloadData;
- (void) loadLocalSightings;


@end
