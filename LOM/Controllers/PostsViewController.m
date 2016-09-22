//
//  PostsViewController.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "PostsViewController.h"
#import "PostsTableViewCell.h"
#import "Tools.h"
#import "AppData.h"
#import "PublicationResult.h"
#import "PopupLoginViewController.h"
#import "LoginResult.h"
#import "Constants.h"
#import "Sightings.h"
#import "PublicationNode.h"
#import "UserConnectedresult.h"
#import "PublicationResult.h"

@interface PostsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewLifeList;
@property (weak, nonatomic) IBOutlet UIButton *buttonConnect;
@end

@implementation PostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pullToRefresh = NO;
    isSearchShown = NO;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];//ORANGE_COLOR;
    self.refreshControl.tintColor = [UIColor blackColor];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshListFromOnlineData)
                  forControlEvents:UIControlEventValueChanged];
    //--Rehefa tsy subclass n'ny UITableViewController ilay ViewController dia mila apina
    //--- ao @ subView n'ilay TableView ny refreshController --
    [self.tableViewLifeList addSubview:self.refreshControl];
    
    self.searchText.delegate = self;
    [self.btnSearch setImage:[UIImage imageNamed:@"ico_find_off"] forState:UIControlStateNormal];
    
    
}

-(void) refreshListFromOnlineData{
    self.pullToRefresh = YES;
    appDelegate.showActivity = NO;
    [self loadOnlineSightings];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showLoginPopup{
    NSString* indentifier=@"PopupLoginViewController";
    PopupLoginViewController* controller = (PopupLoginViewController*) [Tools getViewControllerFromStoryBoardWithIdentifier:indentifier];
    controller.delegate = self;
    controller.preferredContentSize = CGSizeMake(300, 200);
    popoverController = [[WYPopoverController alloc] initWithContentViewController:controller];
    popoverController.delegate = self;
    [popoverController presentPopoverFromRect:self.view.bounds inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:NO options:WYPopoverAnimationOptionScale];
    
}


- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self loadLocalSightings];
}


- (void) loadLocalSightings{
    if(!self.pullToRefresh && !appDelegate.showActivity){
        [self showActivityScreen];
    }
    
    NSArray * allSightings = [Sightings getAllSightings];
    NSMutableArray * nodeLists = nil;
    if([allSightings count] > 0 ){
        nodeLists = [NSMutableArray new];
        
        for (Sightings *row in allSightings) {
            
            PublicationNode * listNode = [PublicationNode new];
            Publication * node = [Publication new];
            node.title          = row._title;
            node.species   = row._speciesName;
            node.place_name      = row._placeName;
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:row._createdTime];
            node.created = [date description];
            Photo * photo       = [Photo new];
            photo.src           = row._photoFileNames;//<--- Mety sary betsaka
            node.field_photo    = photo;
            node.nid            = row._nid;
            node.speciesNid     = row._speciesNid;
            node.uuid           = row._uuid;
            listNode.node       = node;
            [nodeLists addObject:listNode];
        }
        
        _sightingsList = nodeLists;
        
    }
    
    self.tableViewLifeList.delegate = self;
    self.tableViewLifeList.dataSource = self;
    
    [self.tableViewLifeList setHidden:NO];
    
    //---Satria mandeha au background ireto functions ireto dia mila
    // any @ mainThread no manao appel
    
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    //[self performSelectorOnMainThread:@selector(updateViewTitle) withObject:nil waitUntilDone:NO];

}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark UITableviewDataSource Implements

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_sightingsList count];

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        [self removeActivityScreen];
        
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    if([_sightingsList count] != 0){
        return 1;
    }else{
        //---Mbola vide ny _sightingsList local ---
        CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        UILabel * message = [[UILabel alloc] initWithFrame:rect];
        message.text = NSLocalizedString(@"empty_posts_list",@"");
        message.textColor = [UIColor blackColor];
        message.numberOfLines = 0;
        message.textAlignment = NSTextAlignmentCenter;
        message.font = [UIFont fontWithName:@"Arial" size:23];
        [message sizeToFit];
        self.tableViewLifeList.backgroundView = message;
        self.tableViewLifeList.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self removeActivityScreen];
    }
    return 0;
}



/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0f;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PostsTableViewCell* cell = (PostsTableViewCell*) [Tools getCell:tableView identifier:@"PostsTableViewCell"];
    
    PublicationNode* sightingNode = (PublicationNode*) [_sightingsList objectAtIndex:indexPath.row];
    
    [cell displaySighting:sightingNode.node];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    
    [popoverController dismissPopoverAnimated:YES];
    
    [self showActivityScreen];
    
    [appData loginWithUserName:userName andPassword:password forCompletion:^(id json, JSONModelError *err) {
        
        [self removeActivityScreen];
        
        if (err)
        {
            [Tools showSimpleAlertWithTitle:@"LOM" andMessage:err.debugDescription];
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
                    
                    if (rememberMe) {
                        [self saveSessId:loginResult.sessid sessionName:loginResult.session_name andToken:loginResult.token];
                    }
                    
                    appDelegate._currentToken = loginResult.token;
                    appDelegate._curentUser = loginResult.user;
                    appDelegate._sessid = loginResult.sessid;
                    appDelegate._sessionName = loginResult.session_name;
                    
                    [self loadOnlineSightings];
                    
                }
            }
        }
        
    }];
    
}


-(void) loadOnlineSightings{
    
    if ([Tools isNullOrEmptyString:appDelegate._currentToken]){
        
        [self showLoginPopup ];
        [self.tableViewLifeList setHidden:YES];
        [Tools emptySigntingTable];
        
    }else{
        
        NSString * sessionName = [appDelegate _sessionName];
        NSString * sessionID   = [appDelegate _sessid];
        
        self.initialLoad = TRUE;
        [appData CheckSession:sessionName sessionID:sessionID viewController:self completeBlock:^(id json, JSONModelError *err) {
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
            //--- Only do this when stillConnected = YES ---//
            if(stillConnected){
                [self getPostsJSONCall];
                
            }else{
                [self showLoginPopup ];
                [self.tableViewLifeList setHidden:YES];
                [Tools emptyLemurLifeListTable];
            }
        }];
        
    }
    
}


-(void) getPostsJSONCall{
    
    [appData getSightingsForSessionId:appDelegate._sessid andCompletion:^(id json, JSONModelError *err) {
        
        if (err) {
            if(self.refreshControl){
                [self.refreshControl endRefreshing];
            }
            [Tools showError:err onViewController:self];
            
        }else{
            
            NSDictionary* tmpDict = (NSDictionary*) json;
            NSError* error;
            //--- overLoaded ito function ito . Manao parsing ny JSON fields sy
            //---- ny Class propertries
            PublicationResult * result = [[PublicationResult alloc] initWithDictionary:tmpDict error:&error];
            
            if (error){
                NSLog(@"Error parse : %@", error.debugDescription);
            }
            else{
                [Tools updateSightingsWithNodes:result.nodes];
                [self loadLocalSightings];
                
                //-- fafana ilay message Empty List lasa background view teo aloha --
                self.tableViewLifeList.backgroundView = nil;
                self.tableViewLifeList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            }
            
        }
        
    }];
    
}



-(void) reloadData
{
    [self.tableViewLifeList reloadData];
    if(self.refreshControl){
        /*NSString *updateText = NSLocalizedString(@"updating_list",@"");
         NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
         forKey:NSForegroundColorAttributeName];
         NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:updateText attributes:attrsDictionary];
         self.refreshControl.attributedTitle = attributedTitle;*/
        [self.refreshControl endRefreshing];
    }
    
}




- (void) saveSessId:(NSString*)sessid sessionName:(NSString*) session_name andToken:(NSString*) token{
    
    [Tools setUserPreferenceWithKey:KEY_SESSID andStringValue:sessid];
    [Tools setUserPreferenceWithKey:KEY_SESSION_NAME andStringValue:session_name];
    [Tools setUserPreferenceWithKey:KEY_TOKEN andStringValue:token];
    
}

/*

- (void) getAllPosts{
    
    [self showActivityScreen];
    
    [appData getPublicationForSessionId:appDelegate._sessid andCompletion:^(id json, JSONModelError *err) {
        
        if (err) {
            [Tools showSimpleAlertWithTitle:@"LOM" andMessage:err.debugDescription];
        }else{
            
            NSDictionary* tmpDict = (NSDictionary*) json;
            NSError* error;
            PublicationResult* result = [[PublicationResult alloc] initWithDictionary:tmpDict error:&error];
            
            if (error)
            {
                NSLog(@"Error parse : %@", error.debugDescription);
            }
            else
            {
                _lemurLifeList = result.nodes;
                
                
                self.tableViewLifeList.delegate = self;
                self.tableViewLifeList.dataSource = self;
                
                [self.tableViewLifeList reloadData];
                
                [self.tableViewLifeList setHidden:NO];
                
            }
            
        }
        
        [self removeActivityScreen];
        
    }];
    
}
*/

#pragma IBAction

- (IBAction)buttonConnet_Touch:(id)sender {
    
    [self showLoginPopup];
    
}

- (IBAction)searchButtonTapped:(id)sender {
    if (isSearchShown)
    {
        [self hideSearch];
    }else
    {
        [self showSearch];
    }

}


#pragma Search

- (void) showSearch{
    
    self.searchTopSpace.constant = -5;
    
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [self.searchView setNeedsUpdateConstraints];
                         [self.searchView layoutIfNeeded];
                         
                         [self.tableViewLifeList setNeedsUpdateConstraints];
                         [self.tableViewLifeList layoutIfNeeded];
                         
                         [self.btnSearch setImage:[UIImage imageNamed:@"ico_find_on"] forState:UIControlStateNormal];
                         
                         isSearchShown = YES;
                         
                         [self.searchText becomeFirstResponder];
                     }];
    
}


- (void) hideSearch{
    
    self.searchTopSpace.constant = -43;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [self.searchView setNeedsUpdateConstraints];
                         [self.searchView layoutIfNeeded];
                         
                         [self.tableViewLifeList setNeedsUpdateConstraints];
                         [self.tableViewLifeList layoutIfNeeded];
                         
                         [self.btnSearch setImage:[UIImage imageNamed:@"ico_find_off"] forState:UIControlStateNormal];
                         
                         isSearchShown = NO;
                         
                         [self.searchText resignFirstResponder];
                         
                         [self.view endEditing:YES];
                     }];
    
}


- (void) performSearch:(NSString*) searchStr{
    
    if ([Tools isNullOrEmptyString:searchStr]) {
        [self loadLocalSightings];
        [self.tableViewLifeList reloadData];
        
    }else{
        [self searchSightingsByString:searchStr];
        [self.tableViewLifeList reloadData];
    }
}


-(void) searchSightingsByString:(NSString*)stringValue{
    
    if(stringValue){
        NSMutableArray * nodeLists = nil;
        NSArray* lists = [Sightings getSightingsLike:stringValue];
        if([lists count] > 0 ){
            nodeLists = [NSMutableArray new];
            
            for (Sightings *row in lists) {
                PublicationNode * listNode = [PublicationNode new];
                Publication * node = [Publication new];
                node.title          = row._title;
                node.species   = row._speciesName;
                node.place_name      = row._placeName;
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:row._createdTime];
                node.created = [date description];
                Photo * photo       = [Photo new];
                photo.src           = row._photoFileNames;//<--- Mety sary betsaka
                node.field_photo    = photo;
                node.nid            = row._nid;
                node.speciesNid     = row._speciesNid;
                node.uuid           = row._uuid;
                listNode.node       = node;
                [nodeLists addObject:listNode];
            }
            
            _sightingsList = nodeLists;
        }
    }
}


#pragma UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    [self performSearch:searchStr];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    [self performSearch:nil];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString* strSearch = self.searchText.text;
    
    [self performSearch:strSearch];
    
    [self hideSearch];
    
    return YES;
}




@end
