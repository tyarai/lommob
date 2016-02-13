//
//  WatchingSiteTableViewCell.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 01/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LemursWatchingSites.h"

@interface WatchingSiteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblWatchingSite;
@property (weak, nonatomic) IBOutlet UILabel *lblWatchingSiteDescription;

- (void) displayWatchingSite:(LemursWatchingSites*) lemursWatchingSites;

@end
