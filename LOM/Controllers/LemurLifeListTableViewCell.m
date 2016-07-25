//
//  LemurLifeListTableViewCell.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "LemurLifeListTableViewCell.h"
#import "Tools.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@implementation LemurLifeListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) displayLemurLife:(LemurLifeList*) lemurLifeList {
    
    if (![Tools isNullOrEmptyString:lemurLifeList.title]) {
        self.lblTitle.text = lemurLifeList.title;
    }

    
    if (![Tools isNullOrEmptyString:lemurLifeList.species]) {
        self.lblSpecies.text = lemurLifeList.species;
    }

    
    if (![Tools isNullOrEmptyString:lemurLifeList.created]) {
        self.lblDate.text = lemurLifeList.created;
    }
    
    if (![Tools isNullOrEmptyString:lemurLifeList.where_see]) {
        self.lblWhereSee.text = lemurLifeList.where_see;
    }

    if (![Tools isNullOrEmptyString:lemurLifeList.see_first_time]) {
        self.lblDate.text = lemurLifeList.see_first_time;
    }
    
    if (lemurLifeList.lemur_photo != nil && ![Tools isNullOrEmptyString:lemurLifeList.lemur_photo.src]) {
        
        [self.imgPhoto setImageWithURL:[NSURL URLWithString: lemurLifeList.lemur_photo
                                        .src] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error) {
                [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
            }
            
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
    }else{
        [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
    }


}

@end
