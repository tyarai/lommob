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

- (void) displayLemurLife:(Publication*) publication {
    
    if (![Tools isNullOrEmptyString:publication.title]) {
        self.lblTitle.text = publication.title;
    }

    
    if (![Tools isNullOrEmptyString:publication.field_associated_species]) {
        self.lblSpecies.text = publication.field_associated_species;
    }

    
    if (![Tools isNullOrEmptyString:publication.created]) {
        self.lblDate.text = publication.created;
    }
    
    if (![Tools isNullOrEmptyString:publication.body]) {
        self.lblBody.text = publication.body;
    }

    
    if (publication.field_photo != nil && ![Tools isNullOrEmptyString:publication.field_photo.src]) {
        
        [self.imgPhoto setImageWithURL:[NSURL URLWithString: publication.field_photo.src] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error) {
                [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
            }
            
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
    }else{
        [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
    }


}

@end
