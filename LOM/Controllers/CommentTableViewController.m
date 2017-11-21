//
//  CommentTableViewController.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 06/11/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import "CommentTableViewController.h"
#import "Tools.h"
#import "Comment.h"
#import "Publication.h"
#import "CommentTableViewCell.h"

@interface CommentTableViewController ()

@end

@implementation CommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.comments = [[NSArray alloc]init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 125;

    self.navigationItem.title = NSLocalizedString(@"comment_title",@"");
    
    self.newComment = YES;
    self.selectedComment = nil;
    
}

-(void)viewWillAppear:(BOOL)animated{
    AppDelegate * appDelegate       = [Tools getAppDelegate];
    Publication * currenPublication = appDelegate.appDelegateCurrentPublication;
    if(currenPublication){
        
        if(currenPublication.nid != 0){
            // Tsy mbola synced sady tsy mbol nahazo nid ilay sighting
            self.comments = [Comment getCommentsByNID:currenPublication.nid];
        }else{
            self.comments = [Comment getCommentsByUUID:currenPublication.uuid];
        }
        
        [self.tableView reloadData];
    }
    
    
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
    return [self.comments count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentTableViewCell *cell = (CommentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    
    Comment * comment = self.comments[indexPath.row];
    
    if(comment._new){
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
        comment._new    = (int)NO; // Averina tsy hoe "new" intsony
        [comment save];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    cell.userName.text = comment._name;
    cell.comment.text  = comment._commentBody;
    
    NSString * diff = [self dateDifference:comment._modified];
    cell.date.text  = diff;
    
    return cell;
}

-(NSString*) dateDifference:(NSTimeInterval)commentModifiedTimeStamp{
    
    
    NSString * diff = @"";
    
    if(commentModifiedTimeStamp){
    
        NSDate * modified  = [NSDate dateWithTimeIntervalSince1970:commentModifiedTimeStamp];
        NSDate * now       = [[NSDate alloc] init];
        NSTimeInterval ti  = [now timeIntervalSinceDate:modified];
        
        NSUInteger d, h, m, s;
        
        d = (ti / 86400);
        h = (ti / 3600);
        m = ((NSUInteger)(ti / 60)) % 60;
        s = ((NSUInteger) ti) % 60;
        
        if(s <= 59 && m == 0){
            diff = [NSString stringWithFormat:@"%02lus ago", s];
            
        }else{
            
            if(m >= 1 && m <= 59 && h == 0){
                diff = [NSString stringWithFormat:@"%02lum ago", m];
            }else{
                if(h >= 1 && h <= 24 && d == 0){
                    diff = [NSString stringWithFormat:@"%02luh ago", h];
                }else{
                    diff = [NSString stringWithFormat:@"%02lud ago", d];
                }
            }
        }
    }
    
    return diff;
    
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
 */

    


- (IBAction)addComment:(id)sender {
    self.newComment = YES;
    [self performSegueWithIdentifier:@"editComment" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"editComment"]){
        CommenEditViewController * vc = (CommenEditViewController*)[segue destinationViewController];
        vc.delegate             = self;
        
        if(self.newComment){
            vc.navigationItem.title = NSLocalizedString(@"add_comment_title", @"");
            vc.currentComment       = nil;
        }else{
            vc.currentComment       = self.selectedComment;
            vc.navigationItem.title = NSLocalizedString(@"edit_comment_title", @"");
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.newComment = NO;
    self.selectedComment = self.comments[indexPath.row];
    [self performSegueWithIdentifier:@"editComment" sender:self];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 Save Comment to database
 */
- (void) saveComment:(Comment*)commentObject comment:(NSString*)comment{
    
    if(! [Tools isNullOrEmptyString:comment]){
        
        AppDelegate * appDelegate = [Tools getAppDelegate];
        
        if(appDelegate){
            
            Publication*    _publication    = appDelegate.appDelegateCurrentPublication;
            
            if(_publication && commentObject == nil){
                //---- Hi- creer comment vaovao mihitsy ho an'ity sighting ity ---//
                
                NSInteger       _uid            = appDelegate._uid;
                NSInteger       _nid            = _publication.nid;
                NSInteger       _cid            = 0;// New comment
                NSInteger       _pid            = 0;// No parent
                int             _status         = 1;// Show this comment
                NSUUID*         _uuid           = [NSUUID UUID];
                double  _created                = [[NSDate date] timeIntervalSince1970];
                double  _modified               = [[NSDate date] timeIntervalSince1970];
                NSString*       _userName       = appDelegate._userName;
                NSString*       _usermail       = appDelegate._userMail;
                NSString*       _language       = @"und";
                NSString*       _commentBody    = comment;
                NSString*       _sighting_uuid  = _publication.uuid;
                
                Comment * newComment      = [Comment new];
                newComment._uid           = _uid;
                newComment._nid           = _nid;
                newComment._cid           = _cid;
                newComment._pid           = _pid;
                newComment._status        = _status;
                newComment._uuid          = [_uuid UUIDString] ;
                newComment._created       = _created;
                newComment._modified      = _modified;
                newComment._name          = _userName;
                newComment._mail          = _usermail;
                newComment._language      = _language;
                newComment._commentBody   = _commentBody;
                newComment._sighting_uuid = _sighting_uuid;
                
                [newComment save];
               
            }
            
            if(_publication && commentObject != nil){
                //---- Hanova comment ho an'ity sighting ity ---//
                
                double  _modified               = [[NSDate date] timeIntervalSince1970];
                NSString*       _commentBody    = comment;
                
                commentObject._modified      = _modified;
                commentObject._commentBody   = _commentBody;
                commentObject._synced        = (int)NO;
                commentObject._locked        = (int)NO;
                
                [commentObject save];
                
                //------ Atao SAVE ilay sighting dia mba afaka ampiakarana
                
            }

            
            
        }
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
