//
//  SpecyCollectionViewCell.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species.h"

@interface SpecyCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgSpecy;
@property (weak, nonatomic) IBOutlet UILabel *lblSpecyName;

- (void) displaySpecy:(Species*) species;

@end
