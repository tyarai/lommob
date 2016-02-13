

#import "MTCSimpleActivityView.h"
#import "AppUtilities.h"


@implementation MTCSimpleActivityView


/**
    Init the activicty view
 @param activity frame a CGRect argument
 @param text loading a NSString or nil argument
 */
- (id)initWithFrame:(CGRect)frame withTextActivity:(NSString*)message
{
    self = [super initWithFrame:frame];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLabelCalled:)
                                                 name:@"updateLabel"
                                               object:nil];
    
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75]];
        
        //add the indicator
        /*UIActivityIndicatorView*activityIndicator = [[UIActivityIndicatorView alloc]
                            initWithFrame:[AppUtilities generateFrame:CGRectMake(105, 420, 420, 30)]];*/
        /*UIActivityIndicatorView*activityIndicator = [[UIActivityIndicatorView alloc]
                                                     initWithFrame:[AppUtilities generateFrame:CGRectMake(52, 210, 210, 15)]];*/
        UIActivityIndicatorView*activityIndicator = [[UIActivityIndicatorView alloc]
                                                     initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width)/2 - 15, ([UIScreen mainScreen].bounds.size.height)/2 - 15, 30, 30)];
        
       ;
        

        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator setHidden:NO];
        [activityIndicator startAnimating];
        [activityIndicator setHidesWhenStopped:YES];
        [self addSubview:activityIndicator];
        
        //add the label
        if (![AppUtilities isNullOrEmptyString:message])
        {
           /* UILabel* activityText = [[UILabel alloc] initWithFrame:[AppUtilities generateFrame:CGRectMake([AppUtilities getScreenWidth], 480, 640, 100)]];*/
            UILabel* activityText = [[UILabel alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height)/2 + 45, [AppUtilities getScreenWidth], 30)];
            activityText.textAlignment  = NSTextAlignmentCenter;
            [activityText setText:message];
            [activityText setTextColor:[UIColor whiteColor]];
            [self addSubview:activityText];
        }
        
        
    }
    return self;
}

- (void) updateLabelCalled:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"updateLabel"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.activityText.text = @"test";
            [self setNeedsDisplay];
            });
    }
    
}



-(void)setMessageActivity:(NSString*) message
{
    
}
@end
