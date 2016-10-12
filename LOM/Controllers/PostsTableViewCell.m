//
//  PostsTableViewCell.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 5/23/16.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "PostsTableViewCell.h"
#import "Tools.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@implementation PostsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) displaySighting:(Publication*) publication {
    
    if (![Tools isNullOrEmptyString:publication.title]) {
        self.lblTitle.text = publication.title;
    }
    
    
    if (![Tools isNullOrEmptyString:publication.species]) {
        self.lblSpecies.text = publication.species;
    }
    
    
    if (![Tools isNullOrEmptyString:publication.created]) {
        self.lblDate.text = publication.created;
    }
    
    if (![Tools isNullOrEmptyString:publication.body]) {
        self.lblBody.text = publication.body;
    }
    
    if (![Tools isNullOrEmptyString:publication.author_name]) {
        self.lblUser.text = publication.author_name;
    }
    
    
    if (publication.field_photo != nil && ![Tools isNullOrEmptyString:publication.field_photo.src]) {
        
        //[self.imgPhoto setImageWithURL:[NSURL URLWithString: publication.field_photo.src] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        if(publication.isLocal){
        
            NSArray * images =  [publication.field_photo.src componentsSeparatedByString:@"@"];
            NSString * firstImage = [images objectAtIndex:0];
            
            NSURL * url = [NSURL fileURLWithPath: firstImage];
            
            
            [self.imgPhoto setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (error) {
                    [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
                }
                
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
        }else{
            
            [self.imgPhoto setImageWithURL:[NSURL URLWithString: publication.field_photo.src] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
                }
                
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

        }
        
    }else{
        [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
    }
    
    
}

@end
