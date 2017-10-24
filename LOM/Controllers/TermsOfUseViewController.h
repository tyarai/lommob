//
//  TermsOfUseViewController.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 24/10/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TermsOfUseViewControllerDelegate<NSObject>

-(void)acceptTerms;
-(void)declineTerms;

@end

@interface TermsOfUseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,retain) id<TermsOfUseViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end
