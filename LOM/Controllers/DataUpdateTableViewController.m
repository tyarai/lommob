//
//  DataUpdateTableViewController.m
//  
//
//  Created by Ranto Tiaray Andrianavonison on 23/03/2018.
//

#import "DataUpdateTableViewController.h"
#import "AppData.h"
#import "Tools.h"

@interface DataUpdateTableViewController ()

@end

@implementation DataUpdateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.speciesUpdate.text = [Tools getStringUserPreferenceWithKey:SPECIES_UPDATE_COUNT];
    self.familyUpdate.text  = [Tools getStringUserPreferenceWithKey:FAMILY_UPDATE_COUNT];
    self.mapUPdate.text     = [Tools getStringUserPreferenceWithKey:MAP_UPDATE_COUNT];
    self.photoUpdate.text   = [Tools getStringUserPreferenceWithKey:PHOTO_UPDATE_COUNT];
    self.placeUpdate.text   = [Tools getStringUserPreferenceWithKey:PLACE_UPDATE_COUNT];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}
 */

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

/*
 Get changed species,families,maps,illustraiions,photograph
 */
/*
-(void) getChangedNodesFromServer:(NSString*)fromDate{
    
    AppData * appData = [AppData getInstance];
    AppDelegate * appDelegate =  [Tools getAppDelegate];
    //[self startSpinner];
    
    
    
    [appData getChangedNodesForSessionId:appDelegate._sessid
                                fromDate:fromDate
                           andCompletion:^(id json, JSONModelError *err) {
                               
           //[self stopSpinner];
           
           if (err) {
               [Tools showError:err onViewController:nil];
               
           }else{
               
               NSError *error = nil;
               
               NSDictionary *changedNodesJSONDictionary = (NSDictionary*)json;
               
               if (error){
                   NSLog(@"Error parse : %@", error.debugDescription);
               }
               else{
                   [appData updateLocalDatabaseWith:changedNodesJSONDictionary];
                   [Tools setUserPreferenceWithKey:UPDATE_TEXT andStringValue:@""];
                   NSDate *currDate    = [NSDate date];//Current time in UTC time
                   int64_t  _now       = [currDate timeIntervalSince1970];
                   [Tools setUserPreferenceWithKey:UPDATE_SYNC_DATE andStringValue:[NSString stringWithFormat:@"%lli",_now] ];
                   //[self resetUpdateControl];
               }
               
           }
           
       }];
    
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
