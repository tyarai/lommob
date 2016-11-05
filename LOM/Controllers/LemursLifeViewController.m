//
//  LemursLifeViewController.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "LemursLifeViewController.h"
#import "LemurLifeListTableViewCell.h"
#import "Tools.h"
#import "AppData.h"
#import "PublicationResult.h"
#import "LemurLifeListResult.h"
#import "LemurLifeListTable.h"
#import "LemurLifeList.h"
#import "Photo.h"
#import "PopupLoginViewController.h"
#import "LoginResult.h"
#import "Constants.h"
#import "LemurLifeListNode.h"
#import "Reachability.h"
#import "UserConnectedResult.h"
#import "UITableViewCell+Stretch.h"
#import "PostsViewController.h"

#define ROWHEIGHT 121
#define TABLEVIEWHEADERHEIGHT 44

@interface LemursLifeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableViewLifeList;
@property (weak, nonatomic) IBOutlet UIButton *buttonConnect;
@property bool intialLoad;



@end

@implementation LemursLifeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.intialLoad = YES;
    self.pullToRefresh = NO;
    appDelegate.showActivity = YES;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];//ORANGE_COLOR;
    self.refreshControl.tintColor = [UIColor blackColor];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshListFromOnlineData)
                  forControlEvents:UIControlEventValueChanged];
    //--Rehefa tsy subclass n'ny UITableViewController ilay ViewController dia mila apina
    //--- ao @ subView n'ilay TableView ny refreshController --
    [self.tableViewLifeList addSubview:self.refreshControl];
    
    self.tableViewLifeList.rowHeight = UITableViewAutomaticDimension;
    self.tableViewLifeList.estimatedRowHeight = ROWHEIGHT;
    
    
    self.searchText.delegate = self;
    [self.btnSearch setImage:[UIImage imageNamed:@"ico_find_off"] forState:UIControlStateNormal];
    
    self.navigationItem.title = NSLocalizedString(@"lemur_life_list_title",@"");
    self.navigationItem.titleView = nil;
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];
    
    [self.buttonConnect setHidden:YES];
    
    _lemurLifeList = [[NSMutableArray alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) showLoginPopup{
    NSString* indentifier=@"PopupLoginViewController";
    PopupLoginViewController* controller = (PopupLoginViewController*) [Tools getViewControllerFromStoryBoardWithIdentifier:indentifier];
    controller.delegate = self;
    
    //controller.preferredContentSize = CGSizeMake(300, 200);
    //popoverController = [[WYPopoverController alloc] initWithContentViewController:controller];
    //popoverController.delegate = self;
    //[popoverController presentPopoverFromRect:self.view.bounds inView:self.buttonConnect permittedArrowDirections:WYPopoverArrowDirectionNone animated:NO options:WYPopoverAnimationOptionScale];
    [self presentViewController:controller animated:YES completion:nil];
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadLocalLemurLifeLists];
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

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if([_lemurLifeList count] != 0){
        return 1;
    }else{
        //---Mbola vide ny _lemurlifelist local ---
        CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        UILabel * message = [[UILabel alloc] initWithFrame:rect];
        message.text = NSLocalizedString(@"empty_lemur_life_list",@"");
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //-- Raha vao tsy atsoina ity dia tsy miseho ilay Header
    return TABLEVIEWHEADERHEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSInteger countLifeList = [_lemurLifeList count];
    NSString * title = [NSString stringWithFormat:@"You have %ld species in your list",(long)countLifeList];
    
    UIView * view = [[UIView alloc]init];
    [view setFrame:CGRectMake(0, 0, self.tableViewLifeList.frame.size.width, TABLEVIEWHEADERHEIGHT)];
    view.backgroundColor = ORANGE_COLOR;
    
    UILabel * tableTitle = [[UILabel alloc]init];
    [tableTitle setFrame:CGRectMake(0, 0, self.tableViewLifeList.frame.size.width, TABLEVIEWHEADERHEIGHT)];
    tableTitle.text = title;
    tableTitle.textAlignment = NSTextAlignmentCenter;
    
    [tableTitle setFont:[UIFont fontWithName:@"Open Sans" size:19]];
    
    [view addSubview:tableTitle];
    
   

    return view;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _lemurLifeList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LemurLifeListTableViewCell* cell = (LemurLifeListTableViewCell*) [Tools getCell:tableView identifier:@"lemurLifeListTableViewCell"];
    
    
   
    NSDictionary * lifeList = [_lemurLifeList objectAtIndex:indexPath.row];
    [cell displayLemurLifeData:lifeList];
    
    //LemurLifeListNode* lifeList = (LemurLifeListNode*) [_lemurLifeList objectAtIndex:indexPath.row];
    //[cell displayLemurLife:lifeList.node];
    
    //cell = (LemurLifeListTableViewCell*)[cell stretchCell:cell width:self.view.frame.size.width height:self.view.frame.size.height-5];
    
    
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
    [self.buttonConnect setHidden:NO];
    [popoverController dismissPopoverAnimated:YES];
}


- (void) validWithUserName:(NSString*) userName password:(NSString*) password andRememberMe:(BOOL) rememberMe
{
    
    //[popoverController dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self showActivityScreen];
    
    [appData loginWithUserName:userName andPassword:password forCompletion:^(id json, JSONModelError *err) {
        
        if (err)
        {
            [self removeActivityScreen];
            [Tools showError:err onViewController:self];
     
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
                        [self saveSessId:loginResult.sessid sessionName:loginResult.session_name andToken:loginResult.token uid:loginResult.user.uid];
                    }
                    
                    appDelegate._currentToken = loginResult.token;
                    appDelegate._curentUser = loginResult.user;
                    appDelegate._sessid = loginResult.sessid;
                    appDelegate._sessionName = loginResult.session_name;
                    appDelegate._uid    = loginResult.user.uid;
                    
                    [self loadOnlineSightings];
                    
                
                }
            }
        }
        
    }];
    
    //
    
}



- (void) saveSessId:(NSString*)sessid sessionName:(NSString*) session_name andToken:(NSString*) token uid:(NSInteger) uid{
    NSString * strUid = [NSString stringWithFormat:@"%ld",(long)uid];
    [Tools setUserPreferenceWithKey:KEY_SESSID andStringValue:sessid];
    [Tools setUserPreferenceWithKey:KEY_SESSION_NAME andStringValue:session_name];
    [Tools setUserPreferenceWithKey:KEY_TOKEN andStringValue:token];
    [Tools setUserPreferenceWithKey:KEY_UID andStringValue:strUid  ];
}

-(void) refreshListFromOnlineData{
    self.pullToRefresh = YES;
    appDelegate.showActivity = NO;
    
    //[self loadOnlineLemurLifeList];
    
    [self loadOnlineSightings]; // Ny sightings no alaina dia manao updateInsert automatic ny LemurLifeList
    [self syncSightingsWithServer]; // Ny sightings no atao syncronization
}

/**
 Zay Sightings tsy mbola synced dia apekarina any @ server
 */
 
-(void) syncSightingsWithServer{
    
    if ([Tools isNullOrEmptyString:appDelegate._currentToken]){
        
        [self showLoginPopup ];
        [self.tableViewLifeList setHidden:YES];
        
    }else{
        
        NSString * sessionName = [appDelegate _sessionName];
        NSString * sessionID   = [appDelegate _sessid];
        
        
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
                NSArray * notSyncedSightings = [Sightings getNotSyncedSightings];
                [appData syncWithServer:notSyncedSightings sessionName:sessionName sessionID:sessionID ];
                [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                
            }else{
                [self showLoginPopup ];
                [self.tableViewLifeList setHidden:YES];
              
            }
        }];
        
    }
    
    
    
    
}

-(void) syncWithServer{
    
    if ([Tools isNullOrEmptyString:appDelegate._currentToken]){
        [self showLoginPopup ];
        [self.tableViewLifeList setHidden:YES];
        
    }else{
        
        NSString * sessionName = [appDelegate _sessionName];
        NSString * sessionID   = [appDelegate _sessid];
        
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
                NSArray * notSyncedLifeList = [LemurLifeListTable getNotSyncedLifeList];
                [appData syncLifeListWithServer:notSyncedLifeList sessionName:sessionName sessionID:sessionID];
                [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                
            }else{
                [self showLoginPopup ];
                [self.tableViewLifeList setHidden:YES];
            }
        }];
        
    }
    
    

}

-(void) loadOnlineSightings{
    
    if ([Tools isNullOrEmptyString:appDelegate._currentToken]){
        [self showLoginPopup ];
        [self.tableViewLifeList setHidden:YES];
        //[Tools emptyLemurLifeListTable];
        //[Tools emptySightingTable];
        
    }else{
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
                    [Tools saveSyncDate]; // Ovaina androany ny LAST_SYNC_DATE
                    [Tools updateSightingsWithNodes:result.nodes];
                    [self loadLocalLemurLifeLists];
                    //-- fafana ilay message Empty List lasa background view teo aloha --
                    self.tableViewLifeList.backgroundView = nil;
                    self.tableViewLifeList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                }
                
            }
            
        }];
    }
}

-(void) loadOnlineLemurLifeList{
    
    if ([Tools isNullOrEmptyString:appDelegate._currentToken]){
        [self showLoginPopup ];
        [self.tableViewLifeList setHidden:YES];
        
    }else{
        
        NSString * sessionName = [appDelegate _sessionName];
        NSString * sessionID   = [appDelegate _sessid];
        
        self.intialLoad = TRUE;
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
                [self getLemursListJSONCall];
                
            }else{
                [self showLoginPopup ];
                [self.tableViewLifeList setHidden:YES];
              
            }
        }];

    }

}

-(void) loadLocalLemurLifeLists{
     NSInteger _uid = appDelegate._uid;
    NSArray * speciesInLifeList = [Sightings getLemurLifeLists:_uid search:nil];
    [_lemurLifeList removeAllObjects];
    for(id row in speciesInLifeList){
        [_lemurLifeList addObject:row];
    }
    self.tableViewLifeList.delegate = self;
    self.tableViewLifeList.dataSource = self;
    
    [self.tableViewLifeList setHidden:NO];
    
    //---Satria mandeha au background ireto functions ireto dia mila
    // any @ mainThread no manao appel
    
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
}

/*
-(void) loadLocalLemurLifeLists{
    
    if(!self.pullToRefresh && !appDelegate.showActivity){
        [self showActivityScreen];
    }
    
    //NSArray * allLemurLifeList = [LemurLifeListTable getAllLemurLifeLists];
    NSInteger _uid = appDelegate._uid;
    NSArray* currentUserLifeList =  [LemurLifeListTable getLemurLifeListsByUID:_uid];
    NSMutableArray * nodeLists = nil;
    if([currentUserLifeList count] > 0 ){
        nodeLists = [NSMutableArray new];
        
        for (LemurLifeListTable *row in currentUserLifeList) {
            LemurLifeListNode * listNode = [LemurLifeListNode new];
            LemurLifeList * node = [LemurLifeList new];
            node.title          = row._title;
            node.species        = row._species;
            node.where_see      = row._where_see_it;
            
            NSDate * date       = [NSDate dateWithTimeIntervalSince1970:row._when_see_it];
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *strDate = [formatter stringFromDate:date];
            node.see_first_time = strDate;
            Photo * photo       = [Photo new];
            photo.src           = row._photo_name;
            node.lemur_photo    = photo;
            node.nid            = row._nid;
            node.species_nid    = row._species_id;
            node.uuid           = row._uuid;
            node.isLocal        = row._isLocal;
            listNode.node       = node;
            
            [nodeLists addObject:listNode];
        }
        
        _lemurLifeList = nodeLists;
    
    }
    
    self.tableViewLifeList.delegate = self;
    self.tableViewLifeList.dataSource = self;
    
    [self.tableViewLifeList setHidden:NO];
    
    //---Satria mandeha au background ireto functions ireto dia mila
    // any @ mainThread no manao appel
    
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
}
 */

-(void) getLemursListJSONCall{
    
    [appData getMyLemurLifeListForSessionId:appDelegate._sessid andCompletion:^(id json, JSONModelError *err) {
        
        if (err) {
            [Tools showError:err onViewController:self];
            
        }else{
            
            NSDictionary* tmpDict = (NSDictionary*) json;
            NSError* error;
            //--- overLoaded ito function ito . Manao parsing ny JSON fields sy
            //---- ny Class propertries
            LemurLifeListResult* result = [[LemurLifeListResult alloc] initWithDictionary:tmpDict error:&error];
            
            if (error){
                NSLog(@"Error parse : %@", error.debugDescription);
            }
            else{
                [Tools updateLemurLifeListWithNodes:result.nodes];
                [self loadLocalLemurLifeLists];
                
                //-- fafana ilay message Empty List lasa background view teo aloha --
                self.tableViewLifeList.backgroundView = nil;
                self.tableViewLifeList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            }
            
        }
        
    }];

}


- (void) getMyLemursLifeList{
    
    
    NSString * sessionName = [appDelegate _sessionName];
    NSString * sessionID   = [appDelegate _sessid];
    
    self.intialLoad = TRUE;
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
            [self loadLocalLemurLifeLists];
            
        }else{
            [self showLoginPopup ];
            [self.tableViewLifeList setHidden:YES];
        }
    }];
  
    
    self.intialLoad = NO;
    
}

- (void) updateViewTitle{
    NSInteger count = [_lemurLifeList count];
    NSString * _count = [NSString stringWithFormat:@" (%ld species)",(long)count];
    NSString * _title = [NSLocalizedString(@"title_lemur_life_list",@"") stringByAppendingString:_count];
    self.viewTitle.text  = _title;

}

-(void) reloadData
{
    [self.tableViewLifeList reloadData];
    if(self.refreshControl){
        [self.refreshControl endRefreshing];
    }
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        [self removeActivityScreen];
        
    }
}

#pragma IBAction

- (IBAction)buttonConnet_Touch:(id)sender {
    
    [self showLoginPopup];
    
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
                         
                         [self.view layoutIfNeeded];
                         
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
                         
                         [self.view layoutIfNeeded];
                         
                         isSearchShown = NO;
                         
                         [self.searchText resignFirstResponder];
                         
                         [self.view endEditing:YES];
                     }];
    
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


-(void) searchLemurLifeListByString:(NSString*)stringValue{
    
    if(stringValue){
        NSMutableArray * nodeLists = nil;
        NSArray* lists = [LemurLifeListTable getLemurLifeListLike:stringValue];
        if([lists count] > 0 ){
            nodeLists = [NSMutableArray new];
            
            for (LemurLifeListTable *row in lists) {
                LemurLifeListNode * listNode = [LemurLifeListNode new];
                LemurLifeList * node = [LemurLifeList new];
                node.title          = row._title;
                node.species        = row._species;
                node.where_see      = row._where_see_it;
                int64_t timeStamp   = row._when_see_it;
                NSDate * date       = [NSDate dateWithTimeIntervalSince1970:timeStamp];
                NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                node.see_first_time = [formatter stringFromDate:date];
                
                Photo * photo       = [Photo new];
                photo.src           = row._photo_name;
                node.lemur_photo    = photo;
                node.nid            = row._nid;
                node.species_nid    = row._species_id;
                node.uuid           = row._uuid;
                node.isLocal        = row._isLocal;
                listNode.node       = node;
                [nodeLists addObject:listNode];
            }
            
            _lemurLifeList = nodeLists;
        }
    }
}


- (void) performSearch:(NSString*) searchStr{
    
    if ([Tools isNullOrEmptyString:searchStr]) {
        [self loadLocalLemurLifeLists];
        [self.tableViewLifeList reloadData];
        
    }else{
        //[self searchLemurLifeListByString:searchStr];
        NSInteger _uid = appDelegate._uid;
        NSArray * speciesInLifeList = [Sightings getLemurLifeLists:_uid search:searchStr];
        [_lemurLifeList removeAllObjects];
        for(id row in speciesInLifeList){
            [_lemurLifeList addObject:row];
        }
        self.tableViewLifeList.delegate = self;
        self.tableViewLifeList.dataSource = self;
        [self.tableViewLifeList setHidden:NO];
        [self.tableViewLifeList reloadData];
    }
}


- (IBAction)btnSearchTapped:(id)sender {
    if (isSearchShown)
    {
        [self hideSearch];
    }else
    {
        [self showSearch];
    }
}
- (IBAction)btnLogInTapped:(id)sender {
    [self showLoginPopup];
}
@end
