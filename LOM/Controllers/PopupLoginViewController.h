//
//  PopupLoginViewController.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopupLoginViewControllerDelegate <NSObject>
- (void) cancel;
- (void) validWithUserName:(NSString*) userName password:(NSString*) password andRememberMe:(BOOL) rememberMe;
@end



@interface PopupLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) id<PopupLoginViewControllerDelegate> delegate;

@end
