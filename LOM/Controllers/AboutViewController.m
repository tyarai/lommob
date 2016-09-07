//
//  AboutViewController.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "AboutViewController.h"
#import "Constants.h"
#import "Tools.h"
#import "AppData.h"
#import "AppDelegate.h"
#import "UserConnectedResult.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=  NSLocalizedString(@"About this app", @"About this app");
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:ORANGE_COLOR }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)logoutTapped:(id)sender {
    NSString * sessionName = [appDelegate _sessionName];
    NSString * sessionID   = [appDelegate _sessid];
    
    
    [appData CheckSession:sessionName sessionID:sessionID viewController:self completeBlock:^(id json, JSONModelError *err){
        BOOL stillConnected = YES;
       
        
        UserConnectedResult* sessionCheckResult = nil;
        if (err)
        {
            [Tools showError:err onViewController:self];
        }
        else
        {
            NSError* error;
            NSDictionary* tmpDict = (NSDictionary*) json;
            sessionCheckResult = [[UserConnectedResult alloc] initWithDictionary:tmpDict error:&error];
            
            if (error){
                NSLog(@"Error parse : %@", error.debugDescription);
            }else{
                if(sessionCheckResult.user != nil){
                    if (sessionCheckResult.user.uid == 0){
                        stillConnected = NO;
                    }
                    
                }
            }

        }
        //--- Only logout when stillConnected = YES ---//
        if(stillConnected){
            [appData logoutUserName:sessionCheckResult.user.name  forCompletion:^(id json, JSONModelError *error){
            
                if (error){
                    NSLog(@"Error when log out : %@", error.debugDescription);
                }else{
                    appDelegate._currentToken = nil;
                    appDelegate._sessid = nil;
                    appDelegate._sessionName = nil;
                    [Tools setUserPreferenceWithKey:KEY_SESSID andStringValue:nil];
                    [Tools setUserPreferenceWithKey:KEY_SESSION_NAME andStringValue:nil];
                    [Tools setUserPreferenceWithKey:KEY_TOKEN andStringValue:nil];
                }
            }];
        }
    
    }];
    
}
@end
