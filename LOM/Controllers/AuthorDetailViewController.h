//
//  AuthorDetailViewController.h
//  LOM
//
//  Created by Ranto Andrianavonison on 16/03/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Authors.h"
@interface AuthorDetailViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UITextView *detail;
@property Authors * selectedAuthor;
@end
