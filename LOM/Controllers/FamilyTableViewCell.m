//
//  FamilyTableViewCell.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 01/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "FamilyTableViewCell.h"
#import "Illustrations.h"
#import "Tools.h"

@implementation FamilyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) displayFamily:(Families*) families {
    
    self.lblFamilyName.text = families._family;
    
    NSArray* familyIllustrations = [families getIllustrations];
    
    if (familyIllustrations != nil && familyIllustrations.count > 0) {
        Illustrations* firstIllustration = (Illustrations*) [familyIllustrations objectAtIndex:0];
        
        NSString* imageName = [NSString stringWithFormat:@"%@.jpg", firstIllustration._illustration];
        
        UIImage* image = [UIImage imageNamed:imageName];
        
        self.imgIllustration.image = image;
        
    }else{
        self.imgIllustration.image = [UIImage imageNamed:@"ico_default_specy"];
    }
    
    //[Tools roundedThisImageView:self.imgIllustration];
    
    
    self.lblFamilyDescription.text = families._family_description;
}

@end
