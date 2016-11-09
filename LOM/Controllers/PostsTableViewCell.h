//
//  PostsTableViewCell.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 5/23/16.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Publication.h"
#import "Species.h"
#import "WYPopoverController.h"
#import "Sightings.h"
#import "Publication.h"
#import "PostEditTableViewController.h"
#import "PostsViewController.h"

/*@protocol PostTableViewCellDelegate <NSObject>
@optional
-(void) performSegueToSpecies:(Species*)species;
-(void) performSegueToSightings:(Sightings*)sightings;
@end
 */

@interface PostsTableViewCell : UITableViewCell<WYPopoverControllerDelegate,PostEditTableViewControllerDelegate>{
    NSInteger speciesNID;
    Publication * currentPublication;
    
}

@property (weak)id  parentTableView;

//@property (strong,nonatomic) id<PostTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UILabel *lblSpecies;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *syncInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceName;
@property (weak, nonatomic) IBOutlet UIImageView *speciesPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblSumberObserved;


- (void) displaySighting:(Publication*) publication ;

@end
