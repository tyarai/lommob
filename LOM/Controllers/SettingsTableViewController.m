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

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateOptions];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    NSString * currentUserName = [Tools getStringUserPreferenceWithKey:KEY_USERNAME] ;
    self.userName.text = @"";
    
    if( ![Tools isNullOrEmptyString:currentUserName]){
        self.userName.text = currentUserName;
        self.btnLogOUt.hidden = NO;
    }else{
        self.btnLogOUt.hidden = YES;
    }
    
    [self updateOptions]; // Manao update ny options rehetra rehefa mipoitra ity view ity na koa rehefa mahazo front ilay app
    
}



-(void)updateOptions{
    NSString * listOptions = [Tools getStringUserPreferenceWithKey:KEY_PUBLIC_LIST] ;
    BOOL option = [listOptions isEqualToString:@"1" ]? YES : NO;
    
    [self.switchBtn setOn:option];
}

- (IBAction)logOuttapped:(id)sender {
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString * sessionName = [appDelegate _sessionName];
    NSString * sessionID   = [appDelegate _sessid];
    AppData * appData      = [[AppData alloc] init];
    //[self showActivityScreen];
    
    [appData CheckSession:sessionName sessionID:sessionID completeBlock:^(id json, JSONModelError *err){
        BOOL stillConnected = YES;
        
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
                    
                    self.userName.text = @"";
                    self.btnLogOUt.hidden = YES;
                }
            }];
        }
        
    }];

    
    
    
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
    if(sender.isOn == true){
        [Tools setUserPreferenceWithKey:KEY_PUBLIC_LIST andStringValue:@"1"];
    }else{
        [Tools setUserPreferenceWithKey:KEY_PUBLIC_LIST andStringValue:@"0"];
    }
}


@end
