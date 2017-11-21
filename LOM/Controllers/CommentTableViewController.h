//
//  CommentTableViewController.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 06/11/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenEditViewController.h"
#import "Comment.h"


@interface CommentTableViewController : UITableViewController <CommenEditViewControllerDelegate>{
    
}
@property (nonatomic,strong) NSArray<Comment*>* comments;

@property BOOL newComment;
@property Comment * selectedComment;

@end
