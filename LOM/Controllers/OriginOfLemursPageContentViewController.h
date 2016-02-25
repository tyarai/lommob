//
//  OriginOfLemursPageContentViewController.h
//  LOM
//
//  Created by Ranto Andrianavonison on 25/02/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OriginOfLemursPageContentViewController : UIViewController
@property NSUInteger pageIndex;
@property NSString * text;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
