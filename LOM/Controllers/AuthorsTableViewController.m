//
//  AuthorsTableViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 15/03/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "AuthorsTableViewController.h"
#import "AuthorTableViewCell.h"
#import "Constants.h"
#import "Authors.h"
#import "AuthorDetailViewController.h"

@interface AuthorsTableViewController ()

@end

@implementation AuthorsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = NSLocalizedString(@"Authors",@"Authors");
     [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:ORANGE_COLOR }];
    
    _allAuthors = [Authors allInstances];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allAuthors count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AuthorTableViewCell *cell = (AuthorTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"authorCell" forIndexPath:indexPath];
    Authors *author = self.allAuthors[indexPath.row];;
    cell.authorName.text = [author _name];
    cell.authorDetails.text = [author _details];
    NSString* photoFileName = [author _photo];
    UIImage * photo = [UIImage imageNamed:photoFileName];
    
    [cell.photo setImage:photo];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    AuthorDetailViewController* vc = (AuthorDetailViewController*)segue.destinationViewController;
    vc.selectedAuthor = self.selectedAuthor;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedAuthor = self.allAuthors[indexPath.row];
    [self performSegueWithIdentifier:@"showAuthorDetails" sender:self];

}


@end
