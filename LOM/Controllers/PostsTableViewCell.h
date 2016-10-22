//
//  PostsTableViewCell.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 5/23/16.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Publication.h"

@interface PostsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;

@property (weak, nonatomic) IBOutlet UILabel *lblSpecies;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *syncInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceName;


- (void) displaySighting:(Publication*) publication ;

@end
