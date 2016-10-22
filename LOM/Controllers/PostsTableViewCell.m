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
#import "Species.h"
#import "Photographs.h"
#import "Constants.h"


@implementation PostsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnSpeciesInfoTapped:(id)sender {
    if(speciesNID != 0){
        Species * species = [Species firstInstanceWhere:[NSString stringWithFormat:@"  _species_id = '%ld' ", (long)speciesNID]];
        [self.delegate performSegueWithSpecies:species];
    }
    
}

- (void) displaySighting:(Publication*) publication {
    
    NSString * syncedText = @"";
    if (!publication.isSynced && publication.isLocal) {
        syncedText = NSLocalizedString(@"not_synced_sighting",@"");;
    }
    self.syncInfo.text = syncedText;
    
    if (![Tools isNullOrEmptyString:publication.species]) {
        self.lblSpecies.text = publication.species;
    }
    
    if (![Tools isNullOrEmptyString:publication.title]) {
        self.lblTitle.text = publication.title;
    }
    
    if (![Tools isNullOrEmptyString:publication.created]) {
        self.lblDate.text = publication.created;
    }
    
    if(![Tools isNullOrEmptyString:publication.place_name]){
        self.lblPlaceName.text = publication.place_name;
    }
    
    NSString * strCount = nil;
    if(publication.count > 0){
        strCount = [NSString stringWithFormat:@"%ld",(long)publication.count];
        
    }else{
        strCount = [NSString stringWithFormat:@"%@",@"-"];
        
    }
    self.lblSumberObserved.text = strCount;
    
    NSInteger speciesNid = publication.speciesNid;
    speciesNID = speciesNid;
    
    if(speciesNid != 0){
        Species * species = [Species firstInstanceWhere:[NSString stringWithFormat:@"  _species_id = '%ld' ", (long)speciesNid]];
        
        if(species){
            Photographs * photo = [species getSpecieProfilePhotograph];
            NSString* imageName = [NSString stringWithFormat:@"%@.jpg", photo._photograph];
            UIImage* image = [UIImage imageNamed:imageName];
            self.speciesPhoto.image = image;
            

        }
    }
    
    if (publication.field_photo != nil && ![Tools isNullOrEmptyString:publication.field_photo.src]) {
        
       
        if(publication.isLocal){
        
            NSString *getImagePath = [publication getSightingImageFullPathName];
            UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
            
            if(img){
                [self.imgPhoto setImage:img];
            }else{
                [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
            }
            
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
