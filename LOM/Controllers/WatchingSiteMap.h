//
//  WatchingSiteMap.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 10/08/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Maps.h"
#import "LemursWatchingSites.h"

@interface WatchingSiteMap : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property LemursWatchingSites * currentSite;

@end
