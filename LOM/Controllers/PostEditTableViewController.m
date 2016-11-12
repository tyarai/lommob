//
//  PostEditTableViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 05/11/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "PostEditTableViewController.h"
#import "SightingDataTableViewController.h"
#import "AppDelegate.h"
#import "Tools.h"

@interface PostEditTableViewController ()

@end

@implementation PostEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch(indexPath.row){
        case 0:
            [self.delegate cancelPostEditTableViewController];
            [self performSegueWithIdentifier:@"editPost" sender:self];
            break;
        case 1:
            [self.delegate cancelPostEditTableViewController];
            break;
        default:
            break;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //[self.delegate cancelPostEditTableViewController];
    if([[segue identifier] isEqualToString:@"editPost"]){
        SightingDataTableViewController * dest = (SightingDataTableViewController*)[segue destinationViewController];
        dest.delegate = self;
        dest.publication = self.currentPublication;
    }
    
}

#pragma SightingDataTableViewController

-(void)cancelSightingData{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)saveSightingInfo:(NSInteger)observation placeName:(NSString *)placeName date:(NSDate *)date comments:(NSString *)comments{
    
    AppDelegate * appDelegate = [Tools getAppDelegate];
    
    NSString * sessionName = [appDelegate _sessionName];
    NSString * sessionID   = [appDelegate _sessid];
    NSString * token       = [appDelegate _currentToken];
    NSInteger uid          = [appDelegate _uid];
    
    
    //--- atao Update @ zay ilay  Publication ---//
    if(![Tools isNullOrEmptyString:sessionID] && ![Tools isNullOrEmptyString:sessionName] &&
       ![Tools isNullOrEmptyString:token] &&  uid != 0 && self.currentPublication != nil){
        
        if(observation && placeName && comments && date ){
            
            NSInteger   _nid        = self.currentPublication.nid;
            NSString *  _uuid       = self.currentPublication.uuid;
            NSInteger  _count       = observation;
            NSString *_placeName    = placeName;
            NSString *_title        = comments;
            double _date            = [date timeIntervalSince1970];
            double  _modified       = [[NSDate date] timeIntervalSince1970];
            NSString * query        = nil;
            
            if(_nid > 0){
                //------ Update by _nid : Raha efa synced sady nahazo _nid ilay sighting --- //
                
                query = [NSString stringWithFormat:@"UPDATE $T SET  _placeName = '%@' , _title = '%@' , _speciesCount = '%li' ,_modifiedTime = '%f' ,_date = '%f' ,_isSynced = '0' WHERE _nid = '%li' ", _placeName,_title,_count,_modified,_date,(long)_nid];
            }else{
                //---- Update by _uuid : tsy mbola synced sady tsy nahazo _nid avy any @ server
                query = [NSString stringWithFormat:@"UPDATE $T SET  _placeName = '%@' , _title = '%@' , _speciesCount = '%li' ,_modifiedTime = '%f' ,_date = '%f' ,_isSynced = '0' WHERE _uuid = '%@' ", _placeName,_title,_count,_modified,_date,_uuid];
                
            }
            
            [Sightings executeUpdateQuery:query];

            [self.delegate reloadPostsTableView];
            
        }
        /**
         @TODO Right after saving this sighting we could directly sync with server all un-synced sightings --
         ---- NSArray * notSyncedSightings = [Sightings getNotSyncedSightings];
         ---- [appData syncWithServer:notSyncedSightings sessionName:sessionName sessionID:sessionID ];
         */
        
    }else{
        
        [Tools showSimpleAlertWithTitle:NSLocalizedString(@"authentication_issue", @"") andMessage:NSLocalizedString(@"session_expired", @"")];
        
    }
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.delegate dismissCameraViewController];
    
}

@end
