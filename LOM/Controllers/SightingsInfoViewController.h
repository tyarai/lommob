//
//  SightingsInfoViewController.h
//  LOM
//
//  Created by Ranto Andrianavonison on 09/10/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SightingsInfoViewControllerDelegate <NSObject>
- (void) cancel;
- (void) saveSightingInfo:(NSInteger) observation placeName:(NSString*) placeName comments:(NSString*) comments;
@end



@interface SightingsInfoViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, retain) id<SightingsInfoViewControllerDelegate> delegate;
- (IBAction)cancelTapped:(id)sender;
- (IBAction)doneTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *numberObserved;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneBUtton;

@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UITextField *placename;
@property (weak, nonatomic) IBOutlet UITextView *comments;
@end
