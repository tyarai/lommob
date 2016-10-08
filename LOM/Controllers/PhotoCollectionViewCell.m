//
//  PhotoCollectionViewCell.m
//  LOM
//
//  Created by Ranto Andrianavonison on 08/10/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

-(void) addImage:(UIImage*) image{
    if(image != nil){
        self.cellPhotoImageView.image = image;
    }
}

@end
