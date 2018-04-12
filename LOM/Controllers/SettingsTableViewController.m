//
//  SettingsTableViewController.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 17/05/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AppDelegate.h"
#import "AppData.h"
#import "Tools.h"
#import "UserConnectedResult.h"
#import "Constants.h"
#import "Tools.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "LoginResult.h"
#import "SVProgressHUD.h"


@interface SettingsTableViewController ()
@property AppDelegate * appDelegate;
@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateOptions];
    self.updateText.text      = NSLocalizedString(@"no_available_update", @"");
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    
     self.appDelegate = [Tools getAppDelegate];
    
    self.navigationItem.title=  NSLocalizedString(@"settings_title", @"");
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];
}

-(void) checkUserSession{
    if([Tools isNullOrEmptyString:self.appDelegate._currentToken]){
        [self showLoginPopup];
    }
}

// Setup login message and button text
-(void) setupLoginInfo{
    
    NSString *updateTExt =[Tools getStringUserPreferenceWithKey:UPDATE_TEXT] ;
    NSString * currentUserName = [Tools getStringUserPreferenceWithKey:KEY_USERNAME] ;
    self.userName.text = @"";
    
    if([Tools isNullOrEmptyString:self.appDelegate._currentToken] ){
        [self.btnLogOUt setTitle:NSLocalizedString(@"log_in", @"") forState:UIControlStateNormal];
        self.logginMessageLabel.text =NSLocalizedString(@"not_logged_in_message", @"");
        self.logginMessageLabel.textColor = [UIColor redColor];
        
    }else{
        
        [self setControlsHidden:NO];
        self.userName.text = currentUserName;
        [self.btnLogOUt setTitle:NSLocalizedString(@"log_out", @"") forState:UIControlStateNormal];
        self.logginMessageLabel.text =NSLocalizedString(@"logged_in_message", @"");
        self.logginMessageLabel.textColor = [UIColor blackColor];
    }
    
    if( ![Tools isNullOrEmptyString:updateTExt]){
        self.updateText.text      = updateTExt;
        self.updateButton.hidden  = NO;
        
    }else{
        [self resetUpdateControl];
        
    }
    
    
    /*
    if( ![Tools isNullOrEmptyString:currentUserName]){
        //self.userName.text = currentUserName;
        //self.btnLogOUt.hidden = NO;
        [self setControlsHidden:NO];
        
    }else{
        //self.btnLogOUt.hidden = YES;
        [self setControlsHidden:YES];
    }
    
    
    if( ![Tools isNullOrEmptyString:updateTExt]){
        self.updateText.text      = updateTExt;
        self.updateButton.hidden  = NO;
        
    }else{
        [self resetUpdateControl];
        
    }*/
    
    
}

// PopupLoginDelegate

- (void) cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) validWithUserName:(NSString*) userName password:(NSString*) password andRememberMe:(BOOL) rememberMe
{
    AppData * appData = [[AppData alloc] init];
    
    [SVProgressHUD setBackgroundColor:[UIColor darkGrayColor]];
    [SVProgressHUD show];
    
    [appData loginWithUserName:userName andPassword:password forCompletion:^(id json, JSONModelError *err) {
        
        [SVProgressHUD dismiss];
        
        if (err != nil){
            
            UIAlertController * alert = [Tools handleError:err];
            [self.loginViewController presentViewController:alert animated:YES completion:nil];
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
                    
                    
                    self.appDelegate._currentToken   = loginResult.token;
                    self.appDelegate._curentUser     = loginResult.user;
                    self.appDelegate._sessid         = loginResult.sessid;
                    self.appDelegate._sessionName    = loginResult.session_name;
                    self.appDelegate._uid            = loginResult.user.uid;
                    self.appDelegate._userName       = loginResult.user.name;
                    self.appDelegate._userMail       = loginResult.user.mail;
                    
                    [self.appDelegate syncSettings]; // Asaina mi-load settings avy any @ serveur avy hatrany eto
                    
                    [self dismissViewControllerAnimated:NO completion:nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setupLoginInfo];
                    });
                    
                    
                }
            }
        }
        
    }];
    
}

-(void) showLoginPopup{
    
    NSString* indentifier=@"PopupLoginViewController";
   
    self.loginViewController = (PopupLoginViewController*) [Tools getViewControllerFromStoryBoardWithIdentifier:indentifier];
    self.loginViewController.delegate = self;
    
    [self presentViewController:self.loginViewController animated:YES completion:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    
    
    [self setupLoginInfo];
    
    // -- Commented out April 11 2018 - Ranto
    //[self updateOptions]; // Manao update ny options rehetra rehefa mipoitra ity view ity na koa rehefa mahazo front ilay app
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self updateOptions]; // Manao update ny options rehetra rehefa mipoitra
    //[self setupLoginInfo];
}

/*
    Activity Indicator  Spinner
 */
-(void) startSpinner{
    
    overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    spinner = [[UIActivityIndicatorView alloc]
                                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = overlayView.center;
    spinner.hidesWhenStopped = YES;
    
    
    
    [overlayView addSubview:spinner];
    [spinner startAnimating];
    [self.navigationController.view addSubview:overlayView];
    
}

-(void) stopSpinner{
    if(overlayView && spinner){
       dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            spinner = nil;
       });
        
        overlayView.hidden = YES;
        overlayView = nil;
    }
}


-(void)updateOptions{
    NSString * listOptions = [Tools getStringUserPreferenceWithKey:KEY_PUBLIC_LIST] ;
    BOOL option = [listOptions isEqualToString:@"1" ]? YES : NO;
    
    [self.switchBtn setOn:option];
    [self.switchBtn setNeedsDisplay];
}

- (IBAction)logOuttapped:(id)sender {
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([Tools isNullOrEmptyString:appDelegate._currentToken]) {
        [self showLoginPopup];
    }else {
        [self logOut:appDelegate];
    }
    
}

-(void) logOut:(AppDelegate*)appDelegate {
   
    //AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString * sessionName = [appDelegate _sessionName];
    NSString * sessionID   = [appDelegate _sessid];
    AppData * appData      = [[AppData alloc] init];
    //[self showActivityScreen];
    
    //[self startSpinner];
    
    [SVProgressHUD show];
    
    [appData CheckSession:sessionName sessionID:sessionID completeBlock:^(id json, JSONModelError *err){
        BOOL stillConnected = YES;
        
        [SVProgressHUD dismiss];
        //[self stopSpinner];
        
        //[self removeActivityScreen];
        UserConnectedResult* sessionCheckResult = nil;
        if (err)
        {
            //[Tools showError:err onViewController:self];
            [Tools showSimpleAlertWithTitle:@"Error" andMessage:@"Error when trying to log out!"];
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
                    appDelegate._uid = 0;
                    [Tools setUserPreferenceWithKey:KEY_SESSID andStringValue:nil];
                    [Tools setUserPreferenceWithKey:KEY_SESSION_NAME andStringValue:nil];
                    [Tools setUserPreferenceWithKey:KEY_TOKEN andStringValue:nil];
                    [Tools setUserPreferenceWithKey:KEY_UID andStringValue:nil];
                    [Tools setUserPreferenceWithKey:LAST_SYNC_DATE andStringValue:nil];
                    
                    [Tools setUserPreferenceWithKey:KEY_USERNAME andStringValue:nil];
                    [Tools setUserPreferenceWithKey:KEY_ACCEPTED_TERMS andStringValue:nil];
                    
                    self.userName.text = @"";
                    [self setControlsHidden:YES];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setupLoginInfo];
                    });
                    
                    
                }
            }];
        }
        
    }];

}

-(void) setControlsHidden:(BOOL) value{
    
    //self.btnLogOUt.hidden = value;
    self.lifeListContentView.hidden = value;
    self.lifeListDescriptionView.hidden = value;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}*/
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)listOptionSwitch:(UISwitch *)sender {
    
    NSString * value = nil;
    
    if(sender.isOn == true){
        value = @"1";
    }else{
        value = @"0";
    }
    
    [self startSpinner];
    
    AppData * appData = [AppData getInstance];
    AppDelegate * appDelegate = [Tools getAppDelegate];
    NSInteger uid = appDelegate._uid;
    
    
    //--- Sync miakatra makany @ server ity settings ity --/
    [appData setUserSettingsWithUserUID:uid
                           settingsName:KEY_PUBLIC_LIST
                          settingsValue:value
                          completeBlock:^(id json, JSONModelError *err) {
                              [self stopSpinner];
                              if(err == nil){
                                  //-- Rehefa tsy nisy error ny nampiakatr tany @server zay vao atao update ny local
                                  
                                  [Tools setUserPreferenceWithKey:KEY_PUBLIC_LIST andStringValue:value];
                              }
                          }];

}


-(void)resetUpdateControl{
    self.updateText.text      = NSLocalizedString(@"no_available_update",@"");
    self.updateButton.hidden  = YES;
}


- (IBAction)tappedUpdateButton:(id)sender {
    
    NSString* updateLastSync = [Tools getStringUserPreferenceWithKey:UPDATE_SYNC_DATE];
    
    if(![Tools isNullOrEmptyString:updateLastSync]){
        //[self getChangedNodesFromServer:updateLastSync];
    }
}
@end
