//
//  ExtinctLemursViewController.h
//  LOM
//
//  Created by Ranto Andrianavonison on 27/02/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtinctLemursViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *extinctLemursButton;
- (IBAction)extinctLemursButtontapped:(id)sender;
@property UIActivityIndicatorView * activityIndicator;
@end
