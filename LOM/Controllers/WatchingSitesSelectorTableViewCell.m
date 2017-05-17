//
//  WatchingSitesSelectorTableViewCell.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 16/05/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import "WatchingSitesSelectorTableViewCell.h"

@implementation WatchingSitesSelectorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    checked = NO;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)displaySite:(LemursWatchingSites*)site{
    if(site){
        self.sitesLabel.text = site._title;
        if(checked){
            UIImage * checkBoxImage = [UIImage imageNamed:@"ico_checkbox"];
            [self.checkBoxImage setImage:checkBoxImage];
            
        }else{
            self.checkBoxImage.image = nil;
        }
    }
}

-(void) check{
    if(checked){
        self.checkBoxImage.image = nil;
    }else{
        UIImage * checkBoxImage = [UIImage imageNamed:@"ico_checkbox"];
        [self.checkBoxImage setImage:checkBoxImage];
    }
    checked = !checked;
}


@end
