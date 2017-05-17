//
//  WatchingSitesSelectorTableViewCell.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 16/05/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LemursWatchingSites.h"

@interface WatchingSitesSelectorTableViewCell : UITableViewCell{
    BOOL checked;
}
@property (weak, nonatomic) IBOutlet UILabel *sitesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImage;


-(void)displaySite:(LemursWatchingSites*)site;
-(void) check;

@end
