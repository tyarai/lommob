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

@protocol WatchingSiteMapDelegate <NSObject>

-(void) dismissSiteMapViewController;

@end

@interface WatchingSiteMap : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UILabel *siteName;
@property LemursWatchingSites * currentSite;
@property (nonatomic,strong) id<WatchingSiteMapDelegate> delegate;


@end
