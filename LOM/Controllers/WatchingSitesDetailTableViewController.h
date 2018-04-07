//
//  WatchingSitesDetailTableViewController.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 07/04/2018.
//  Copyright © 2018 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LemursWatchingSites.h"
#import "WatchingSiteMap.h"

@interface WatchingSitesDetailTableViewController : UITableViewController <WatchingSiteMapDelegate>
@property (weak, nonatomic) IBOutlet UILabel *siteTitle;
@property (weak, nonatomic) IBOutlet UILabel *details;
@property LemursWatchingSites * lemursWatchingSites;

@end
