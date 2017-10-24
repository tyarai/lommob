//
//  PrivacyPolicyViewController.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 20/10/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PrivacyPolicyViewControllerDelegate <NSObject>

-(void) readPrivacyPolicy;

@end


@interface PrivacyPolicyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,retain) id<PrivacyPolicyViewControllerDelegate> delegate;

- (IBAction)closeButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end
