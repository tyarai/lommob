//
//  AuthorsTableViewController.h
//  LOM
//
//  Created by Ranto Andrianavonison on 15/03/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Authors.h"

@interface AuthorsTableViewController : UITableViewController
@property NSArray* allAuthors;
@property Authors *selectedAuthor;
@end
