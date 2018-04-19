//
//  SpeciesNameTableViewController.m
//  LOM
//
//  Created by nyr5k on 19/04/2018.
//  Copyright © 2018 Kerty KAMARY. All rights reserved.
//

#import "SpeciesNameTableViewController.h"
#import "SpeciesNameTableViewCell.h"
#define _ROWHEIGHT 48

@interface SpeciesNameTableViewController ()
@end

@implementation SpeciesNameTableViewController

- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    self.data = @{};
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = _ROWHEIGHT;
    
    if(self.specy) {
        self.navigationItem.title = self.specy._title;
        NSString* mg = self.specy._malagasy;
        NSString* en = self.specy._english;
        NSString* fr = self.specy._french;
        NSString* de = self.specy._german;
        self.flagImage  = @[@"btn_malagasy_on",@"btn_english_on",@"btn_french_on",@"btn_german_on"];
        self.data       = @{@"Malagasy" : mg,@"English" : en,@"German" : de,@"French" : fr};
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpeciesNameTableViewCell *cell = (SpeciesNameTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"speciesNameCell" forIndexPath:indexPath];
    
    NSArray * keys  =  [self.data allKeys];
    NSArray *values =  [self.data allValues];
    
    cell.language.text  = keys[indexPath.row];
    cell.name.text      = values[indexPath.row];
    cell.flagImage.image = [UIImage imageNamed:self.flagImage[indexPath.row]];
    
    
    return cell;
}


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

@end
