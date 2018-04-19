//
//  SpeciesNameTableViewController.h
//  LOM
//
//  Created by nyr5k on 19/04/2018.
//  Copyright © 2018 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species.h"

@interface SpeciesNameTableViewController : UITableViewController
@property NSDictionary<NSString*,NSString*>*data;
@property (strong, nonatomic) Species * specy;
@property (strong, nonatomic) NSArray * flagImage ; 
@end
