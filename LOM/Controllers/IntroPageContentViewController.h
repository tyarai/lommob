//
//  IntroPageContentViewController.h
//  LOM
//
//  Created by Ranto Andrianavonison on 14/02/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroPageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property NSUInteger pageIndex;
@property NSString * text;

@end
