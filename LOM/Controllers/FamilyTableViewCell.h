//
//  FamilyTableViewCell.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 01/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Families.h"

@interface FamilyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgIllustration;
@property (weak, nonatomic) IBOutlet UILabel *lblFamilyName;
@property (weak, nonatomic) IBOutlet UILabel *lblFamilyDescription;

- (void) displayFamily:(Families*) families;

@end
