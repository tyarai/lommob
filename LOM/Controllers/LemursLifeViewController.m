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

#define ROWHEIGHT 115

@interface LemursLifeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableViewLifeList;
@property (weak, nonatomic) IBOutlet UIButton *buttonConnect;
@property bool intialLoad;



@end

@implementation LemursLifeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.viewTitle.text = NSLocalizedString(@"title_lemur_life_list",@"");
    
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
    //self.tableViewLifeList.estimatedRowHeight = 110;
    
    self.searchText.delegate = self;
    [self.btnSearch setImage:[UIImage imageNamed:@"ico_find_off"] forState:UIControlStateNormal];
    
    self.navigationItem.title = NSLocalizedString(@"lemur_life_list_title",@"");
    
    
    
    
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
    [popoverController presentPopoverFromRect:self.view.bounds inView:self.buttonConnect permittedArrowDirections:WYPopoverArrowDirectionNone animated:NO options:WYPopoverAnimationOptionScale];
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
    }
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _lemurLifeList.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ROWHEIGHT;
}
 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LemurLifeListTableViewCell* cell = (LemurLifeListTableViewCell*) [Tools getCell:tableView identifier:@"lemurLifeListTableViewCell"];
    
    
   
    LemurLifeListNode* lifeList = (LemurLifeListNode*) [_lemurLifeList objectAtIndex:indexPath.row];
    
    
    [cell displayLemurLife:lifeList.node];
    
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
                    
                    [self loadOnlineLemurLifeList];
                    
                    
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
    [self loadOnlineLemurLifeList];
    
}

-(void) loadOnlineLemurLifeList{
    
    if ([Tools isNullOrEmptyString:appDelegate._currentToken]){
        
        [self showLoginPopup ];
        [self.tableViewLifeList setHidden:YES];
        [Tools emptyLemurLifeListTable];
        [Tools emptySightingTable];
            
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
                [Tools emptyLemurLifeListTable];
                [Tools emptySightingTable];
            }
        }];

    }

}


-(void) function{
    [appData getMyLemurLifeListForSessionId:appDelegate._sessid andCompletion:^(id json, JSONModelError *err) {
        
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

-(void) loadLocalLemurLifeLists{
    
    if(!self.pullToRefresh && !appDelegate.showActivity){
        [self showActivityScreen];
    }
    
    NSArray * allLemurLifeList = [LemurLifeListTable getAllLemurLifeLists];
    NSMutableArray * nodeLists = nil;
    if([allLemurLifeList count] > 0 ){
        nodeLists = [NSMutableArray new];
        
        for (LemurLifeListTable *row in allLemurLifeList) {
            LemurLifeListNode * listNode = [LemurLifeListNode new];
            LemurLifeList * node = [LemurLifeList new];
            node.title          = row._title;
            node.species        = row._species;
            node.where_see      = row._where_see_it;
            node.see_first_time = row._when_see_it;
            Photo * photo       = [Photo new];
            photo.src           = row._photo_name;
            node.lemur_photo    = photo;
            node.nid            = row._nid;
            node.species_nid    = row._species_id;
            node.uuid           = row._uuid;
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
    
    [self performSelectorOnMainThread:@selector(updateViewTitle) withObject:nil waitUntilDone:NO];

}

-(void) getLemursListJSONCall{
    
    [appData getMyLemurLifeListForSessionId:appDelegate._sessid andCompletion:^(id json, JSONModelError *err) {
        
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
        /*NSString *updateText = NSLocalizedString(@"updating_list",@"");
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:updateText attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;*/
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
                node.see_first_time = row._when_see_it;
                Photo * photo       = [Photo new];
                photo.src           = row._photo_name;
                node.lemur_photo    = photo;
                node.nid            = row._nid;
                node.species_nid    = row._species_id;
                node.uuid           = row._uuid;
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
        [self searchLemurLifeListByString:searchStr];
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
@end
