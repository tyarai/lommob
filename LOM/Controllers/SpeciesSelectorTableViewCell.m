//
//  SpeciesSelectorTableViewCell.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 30/11/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "SpeciesSelectorTableViewCell.h"


@implementation SpeciesSelectorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    checked = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)displaySpecies:(Species*)species{
    if(species){
        self.scientificName.text = species._title;
        self.malagasyName.text = species._malagasy;
        if(checked){
            UIImage * checkBoxImage = [UIImage imageNamed:@"ico_checkbox"];
            [self.checkbox setImage:checkBoxImage];
            
        }else{
            self.checkbox.image = nil;
        }
    }
}

-(void) check{
    if(checked){
        self.checkbox.image = nil;
    }else{
        UIImage * checkBoxImage = [UIImage imageNamed:@"ico_checkbox"];
        [self.checkbox setImage:checkBoxImage];
    }
    checked = !checked;
}

@end
