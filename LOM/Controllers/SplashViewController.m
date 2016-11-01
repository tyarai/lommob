//
//  SplashViewController.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 28/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "SplashViewController.h"
#import "Tools.h"
#import "LoginResult.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self checkUserSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark methods
- (void) presentMain{
    [self performSegueWithIdentifier:@"presentMain" sender:self];
}

#pragma mark WYPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller{
    popoverController.delegate = nil;
    popoverController = nil;
}

#pragma mark LoginPopoverDelegate

- (void) cancel{
    [popoverController dismissPopoverAnimated:YES];
}


- (void) validWithUserName:(NSString*) userName password:(NSString*) password andRememberMe:(BOOL) rememberMe
{
    
    [popoverController dismissPopoverAnimated:YES];
    
    //[self showActivityScreen];
    
    [appData loginWithUserName:userName andPassword:password forCompletion:^(id json, JSONModelError *err) {
        
        //[self removeActivityScreen];
        
        if (err)
        {
            [Tools showSimpleAlertWithTitle:@"LOM" andMessage:err.debugDescription];
            //[self removeActivityScreen];
            [Tools showError:err onViewController:self];
        }
        else
        {
            NSError* error;
            NSDictionary* tmpDict = (NSDictionary*) json;
            LoginResult* loginResult = [[LoginResult alloc] initWithDictionary:tmpDict error:&error];
            
            if (error)
            {
                NSLog(@"Error parse : %@", error.debugDescription);
            }
            else
            {
                if (![Tools isNullOrEmptyString:loginResult.sessid]
                    &&![Tools isNullOrEmptyString:loginResult.session_name]
                    &&![Tools isNullOrEmptyString:loginResult.token]
                    && loginResult.user != nil) {
                    
                    
                    if (rememberMe) {
                        [Tools saveSessId:loginResult.sessid sessionName:loginResult.session_name andToken:loginResult.token uid:loginResult.user.uid];
                    }
                    
                    appDelegate._currentToken = loginResult.token;
                    appDelegate._curentUser = loginResult.user;
                    appDelegate._sessid = loginResult.sessid;
                    appDelegate._sessionName = loginResult.session_name;
                    appDelegate._uid    = loginResult.user.uid;
                    
                    
                    //[self performSelector:@selector(presentMain) withObject:nil afterDelay:3.0f];
                    [self performSelectorOnMainThread:@selector(presentMain) withObject:nil waitUntilDone:NO];
                    
                }
            }
        }
        
    }];
    
}

-(void) checkUserSession{
    if([Tools isNullOrEmptyString:appDelegate._currentToken]){
        [self showLoginPopup];
    }else{
        [self performSelector:@selector(presentMain) withObject:nil afterDelay:3.0f];
    }
}


-(void) showLoginPopup{
    NSString* indentifier=@"PopupLoginViewController";
    PopupLoginViewController* controller = (PopupLoginViewController*) [Tools getViewControllerFromStoryBoardWithIdentifier:indentifier];
    controller.delegate = self;
    controller.preferredContentSize = CGSizeMake(300, 200);
    popoverController = [[WYPopoverController alloc] initWithContentViewController:controller];
    popoverController.delegate = self;
    CGRect bounds = self.view.bounds;
    [popoverController presentPopoverFromRect:bounds inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:NO options:WYPopoverAnimationOptionScale];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
