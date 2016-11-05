//
//  SightingDataTableViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 10/10/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "SightingDataTableViewController.h"
#import "Constants.h"
#import "Tools.h"

@interface SightingDataTableViewController ()

@end

@implementation SightingDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if(self.species){
        self.speciesLabel.text = self.species._title;
        self.cancelButton.tintColor = ORANGE_COLOR;
        self.doneBUtton.tintColor = ORANGE_COLOR;
    }
    self.comments.delegate = self;
    self.numberObserved.delegate = self;
    self.placename.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
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

- (IBAction)cancelTapped:(id)sender {
    [self.delegate cancelSightingData];
}

- (IBAction)doneTapped:(id)sender {
    NSString  * comments = self.comments.text;
    NSInteger obs      = [self.numberObserved.text intValue];
    NSDate * obsDate = [self.date date];
    NSString  * place    = self.placename.text;
    NSString * error = nil;
    if([self validateEntries:comments observation:obs placeName:place error:&error]){
        [self.delegate saveSightingInfo:obs placeName:place date:obsDate comments:comments];
    }else{
        UIAlertController* alert = [Tools createAlertViewWithTitle:NSLocalizedString(@"sightings_title",@"") messsage:error];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


-(BOOL) validateEntries:(NSString*)comment
            observation:(NSInteger)observation
            placeName  :(NSString*)placeName
            error      : (NSString**) error{
    
    
    if(observation <= 0){
        *error = NSLocalizedString(@"sightingNumberObservedError", @"");
        return NO;
    }

    if([Tools isNullOrEmptyString:placeName]){
        *error = NSLocalizedString(@"sightingPlaceNameError", @"");
        return NO;
    }
    
    if([Tools isNullOrEmptyString:comment]){
        *error = NSLocalizedString(@"sightingCommentError", @"");
        return NO;
        
    }
    
    
    return YES;
}



#pragma UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma  UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
