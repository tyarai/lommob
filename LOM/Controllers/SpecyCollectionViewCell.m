//
//  SpecyCollectionViewCell.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "SpecyCollectionViewCell.h"
#import "Photographs.h"
#import "Tools.h"

@implementation SpecyCollectionViewCell


- (void) displaySpecy:(Species*) species {
	
    self.lblSpecyName.text = species._title;
    self.lblSpecyName.numberOfLines = 0;
    [self.lblSpecyName sizeToFit];
    
    Photographs* specyProfilPhotograph = [species getSpecieProfilePhotograph];
    
    //NSString* imageName = [NSString stringWithFormat:@"%@.jpg", specyProfilPhotograph._photograph];
    NSString* imageName =  specyProfilPhotograph._photograph;
    
    //UIImage* image = [UIImage imageNamed:imageName];
    UIImage * image = [Tools loadImage:imageName];
    
    self.imgSpecy.image = image;
    
    //[Tools roundedThisImageView:self.imgSpecy];
    
}
@end
