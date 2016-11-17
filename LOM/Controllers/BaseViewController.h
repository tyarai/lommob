
#import <UIKit/UIKit.h>
#import "MTCSimpleActivityView.h"
#import "AppDelegate.h"
#import "AppData.h"

@interface BaseViewController : UIViewController
{
    MTCSimpleActivityView* activityScreen;
    AppDelegate* appDelegate;
    AppData* appData;
    
}
@property  UIRefreshControl *refreshControl;

-(AppDelegate*) getAppDelegate;

-(void) showActivityScreen;
-(void)removeActivityScreen;


@end
