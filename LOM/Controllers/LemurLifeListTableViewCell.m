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
#import "Sightings.h"
#import "Species.h"


@implementation LemurLifeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) displayLemurLifeData:(NSDictionary*) row{
    
    if(row != nil){
        
        NSInteger totalObserved  = [[row valueForKey:@"totalObserved"] integerValue];
        NSInteger totalSightings = [[row valueForKey:@"totalSightings"] integerValue];
        NSString * species       = [row valueForKey:@"_speciesName"];
        NSInteger speciesNID     = [[row valueForKey:@"_speciesNid"] integerValue];
        
        
        //NSInteger sightingCount = [[Sightings getSightingsBySpeciesID:speciesNID] count];
        NSString * strCount = [NSString stringWithFormat:@"%ld %@",(long)totalSightings,NSLocalizedString(@"sightings_title", @"")];
        self.lblSightingCount.text = strCount;
        
        
        //NSInteger observationTotal = [Sightings observationSumBySpeciesNID:speciesNID];
        NSString * obsTotal = [NSString stringWithFormat:@"%li",(long)totalObserved];
        self.numberObserved.text = obsTotal;
        
        
        if (![Tools isNullOrEmptyString:species]) {
            self.lblSpecies.text = species;
        }
        
        
        /*if (![Tools isNullOrEmptyString:lemurLifeList.created]) {
            self.lblDate.text = lemurLifeList.created;
        }*/
        
        /*if (![Tools isNullOrEmptyString:lemurLifeList.where_see]) {
            self.lblWhereSee.text = lemurLifeList.where_see;
        }*/
        
        /*if (![Tools isNullOrEmptyString:lemurLifeList.see_first_time]) {
            self.lblDate.text = lemurLifeList.see_first_time;
        }*/
        
        if(speciesNID > 0){
            Species * species = [Species getSpeciesBySpeciesNID:speciesNID];
            Photographs * profilePhotoname = [species getSpecieProfilePhotograph];
            NSString * fileName = profilePhotoname._photograph;
            fileName = [fileName stringByAppendingString:@".jpg"];
            if(![Tools isNullOrEmptyString:fileName]){
                UIImage * img = [UIImage imageNamed:fileName];
                [self.imgPhoto setImage:img];
            }else{
                [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
            }
        }
    }
}

- (void) displayLemurLife:(LemurLifeList*) lemurLifeList {
    
    NSInteger speciesNID = lemurLifeList.species_nid;
    NSInteger sightingCount = [[Sightings getSightingsBySpeciesID:speciesNID] count];
    NSString * strCount = [NSString stringWithFormat:@"%ld %@",(long)sightingCount,NSLocalizedString(@"sightings_title", @"")];
    self.lblSightingCount.text = strCount;
    
    
    NSInteger observationTotal = [Sightings observationSumBySpeciesNID:speciesNID];
    NSString * obsTotal = [NSString stringWithFormat:@"%li",(long)observationTotal];
    self.numberObserved.text = obsTotal;

    
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
    
    if(lemurLifeList.species_nid != 0){
        Species * species = [Species getSpeciesBySpeciesNID:lemurLifeList.species_nid];
        Photographs * profilePhotoname = [species getSpecieProfilePhotograph];
        NSString * fileName = profilePhotoname._photograph;
        fileName = [fileName stringByAppendingString:@".jpg"];
        if(![Tools isNullOrEmptyString:fileName]){
            UIImage * img = [UIImage imageNamed:fileName];
            [self.imgPhoto setImage:img];
        }else{
            [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
        }
    }
    
    /*if (lemurLifeList.lemur_photo != nil && ![Tools isNullOrEmptyString:lemurLifeList.lemur_photo.src]) {
       
        if(lemurLifeList.isLocal == YES){
            NSString *getImagePath = [lemurLifeList getLemurLifeListImageFullPathName];
            UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
            
            if(img){
                [self.imgPhoto setImage:img];
            }else{
                [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
            }
        }else{
            
            [self.imgPhoto setImageWithURL:[NSURL URLWithString: lemurLifeList.lemur_photo.src]
                          placeholderImage:nil
                                   options:SDWebImageRefreshCached
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         if (error) {
                                             [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
                                         }
                                 }
               usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
            
        }
        
        
        
    }else{
        [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
    }*/


}

@end
