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

@protocol PostTableViewCellDelegate <NSObject>
-(void) performSegueWithSpecies:(Species*)species;
@end

@interface PostsTableViewCell : UITableViewCell{
    NSInteger speciesNID;
}

@property (strong,nonatomic) id<PostTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;

@property (weak, nonatomic) IBOutlet UILabel *lblSpecies;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *syncInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceName;
@property (weak, nonatomic) IBOutlet UIImageView *speciesPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblSumberObserved;
- (IBAction)btnSpeciesInfoTapped:(id)sender;

- (void) displaySighting:(Publication*) publication ;

@end
