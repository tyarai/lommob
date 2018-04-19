//
//  SpeciesDetailInfoTableViewController.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 18/04/2018.
//  Copyright © 2018 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species.h"

@interface SpeciesDetailInfoTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *scientificName;
@property (weak, nonatomic) IBOutlet UILabel *details;
@property (strong, nonatomic) Species *specy;
@property (strong, nonatomic) NSString* stringDetails;
@property (strong, nonatomic) NSString* menuTitle;

@end
