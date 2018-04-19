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
#import "SVProgressHUD.h"

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
    
    //[popoverController dismissPopoverAnimated:YES];
    
    //[self showActivityScreen];
    [SVProgressHUD  setBackgroundColor:[UIColor lightGrayColor]];
    [SVProgressHUD  show];
    
    [appData loginWithUserName:userName andPassword:password forCompletion:^(id json, JSONModelError *err) {
        
        //[self removeActivityScreen];
        [SVProgressHUD  dismiss];
        
        if (err){
            [Tools showError:err onViewController:loginViewController];
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
                    
                    
                    [Tools     saveSessId:loginResult.sessid
                              sessionName:loginResult.session_name
                                 andToken:loginResult.token
                                      uid:loginResult.user.uid
                                 userName:loginResult.user.name
                                 userMail:loginResult.user.mail
                     ];
                    
                    appDelegate._currentToken   = loginResult.token;
                    appDelegate._curentUser     = loginResult.user;
                    appDelegate._sessid         = loginResult.sessid;
                    appDelegate._sessionName    = loginResult.session_name;
                    appDelegate._uid            = loginResult.user.uid;
                    appDelegate._userName       = loginResult.user.name;
                    appDelegate._userMail       = loginResult.user.mail;
                    
                    [appDelegate syncSettings]; // Asaina mi-load settings avy any @ serveur avy hatrany eto
                    
                    [self dismissViewControllerAnimated:NO completion:nil];
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
    
    
    loginViewController = (PopupLoginViewController*) [Tools getViewControllerFromStoryBoardWithIdentifier:indentifier];
    loginViewController.delegate = self;
    
    [self presentViewController:loginViewController animated:YES completion:nil];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
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
