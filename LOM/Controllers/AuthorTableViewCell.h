//
//  AuthorTableViewCell.h
//  LOM
//
//  Created by Ranto Andrianavonison on 15/03/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *authorDetails;

@end
