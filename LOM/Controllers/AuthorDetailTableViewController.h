//
//  AuthorDetailTableViewController.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 07/04/2018.
//  Copyright © 2018 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Authors.h"

@interface AuthorDetailTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *details;
@property Authors * selectedAuthor;
@end
