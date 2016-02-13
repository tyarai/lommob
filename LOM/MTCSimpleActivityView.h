

#import <UIKit/UIKit.h>

@interface MTCSimpleActivityView : UIView

@property (strong,nonatomic) IBOutlet UILabel* activityText;

- (id)initWithFrame:(CGRect)frame withTextActivity:(NSString*)message;
-(void)setMessageActivity:(NSString*) message;

@end
