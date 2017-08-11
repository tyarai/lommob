//
//  WatchingSiteDetailsViewController.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 01/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LemursWatchingSites.h"
#import "WatchingSiteMap.h"

@interface WatchingSiteDetailsViewController : UIViewController <WatchingSiteMapDelegate>

@property (nonatomic, strong) LemursWatchingSites* lemursWatchingSites;

@end
