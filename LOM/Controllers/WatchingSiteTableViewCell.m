//
//  WatchingSiteTableViewCell.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 01/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "WatchingSiteTableViewCell.h"

@implementation WatchingSiteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) displayWatchingSite:(LemursWatchingSites*) lemursWatchingSites {
    
    self.lblWatchingSite.text = lemursWatchingSites._title;
    
    self.lblWatchingSiteDescription.text = lemursWatchingSites._body;
	
}

@end
