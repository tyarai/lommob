//
//  LemurLifeListTableViewCell.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LemurLifeList.h"

@interface LemurLifeListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSpecies;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblWhereSee;

- (void) displayLemurLife:(LemurLifeList*) lemurLifeList;

@end
