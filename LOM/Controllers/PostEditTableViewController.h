//
//  PostEditTableViewController.h
//  LOM
//
//  Created by Ranto Andrianavonison on 05/11/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species.h"
#import "Publication.h"
#import "SightingDataTableViewController.h"

@protocol PostEditTableViewControllerDelegate <NSObject>
@optional
-(void) cancelPostEditTableViewController;
-(void) reloadPostsTableView;

@end

@interface PostEditTableViewController : UITableViewController<SightingDataTableViewControllerDelegate>

@property (nonatomic,strong) Publication * currentPublication;
@property (nonatomic, retain) id<PostEditTableViewControllerDelegate> delegate;
@end
