//
//  CommenEditViewController.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 06/11/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommenEditViewControllerDelegate <NSObject>

@optional

- (void) cancel;
- (void) saveComment:(NSString*) comment;


@end



@interface CommenEditViewController : UIViewController

@property (nonatomic, retain) id<CommenEditViewControllerDelegate> delegate;

- (IBAction)cancelTapped:(id)sender;
- (IBAction)saveTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end
