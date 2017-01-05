//
//  SpeciesSelectorTableViewCell.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 30/11/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species.h"




@interface SpeciesSelectorTableViewCell : UITableViewCell{
    BOOL checked;
}

@property (weak, nonatomic) IBOutlet UILabel *scientificName;
@property (weak, nonatomic) IBOutlet UILabel *malagasyName;
@property (weak, nonatomic) IBOutlet UIImageView *checkbox;

-(void)displaySpecies:(Species*)species;
-(void) check;
@end
