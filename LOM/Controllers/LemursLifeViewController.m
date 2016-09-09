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

@interface LemursLifeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewLifeList;
@property (weak, nonatomic) IBOutlet UIButton *buttonConnect;
@property  UIRefreshControl *refreshControl;
@property bool intialLoad;



@end

@implementation LemursLifeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.viewTitle.text = NSLocalizedString(@"title_lemur_life_list",@"");
    
    self.intialLoad = YES;
    self.pullToRefresh = NO;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];//ORANGE_COLOR;
    self.refreshControl.tintColor = [UIColor blackColor];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshListFromOnlineData)
                  forControlEvents:UIControlEventValueChanged];
    //--Rehefa tsy subclass n'ny UITableViewController ilay ViewController dia mila apina
    //--- ao @ subView n'ilay TableView ny refreshController --
    [self.tableViewLifeList addSubview:self.refreshControl];
    
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
    //if(!self.pullToRefresh){
        appDelegate.showActivity = !self.pullToRefresh;
    //}
    
        if ([Tools isNullOrEmptyString:appDelegate._currentToken]) {
            [self showLoginPopup ];
            [self.tableViewLifeList setHidden:YES];
            
        }else{
            
            [self getMyLemursLifeList];
        }
    
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
        //---Mbola vide ny _lemurlifelist ---
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
    return 115.0f;
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
            
            [Tools showError:err onViewController:self];
            [self removeActivityScreen];
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
                    
                    [self getMyLemursLifeList];
                    
                    
                }
            }
        }
        
    }];
    
    //
    
}



- (void) saveSessId:(NSString*)sessid sessionName:(NSString*) session_name andToken:(NSString*) token{
    
    [Tools setUserPreferenceWithKey:KEY_SESSID andStringValue:sessid];
    [Tools setUserPreferenceWithKey:KEY_SESSION_NAME andStringValue:session_name];
    [Tools setUserPreferenceWithKey:KEY_TOKEN andStringValue:token];
}

-(void) refreshListFromOnlineData{
    self.pullToRefresh = YES;
    appDelegate.showActivity = NO;
    [self getMyLemursLifeList];
    
}

-(void) loadLocalLemurLifeLists{
    NSArray * allLemurLifeList = [LemurLifeListTable getAllLemurLifeLists];
    NSMutableArray * nodeLists = nil;
    if([allLemurLifeList count] > 0 && self.pullToRefresh == NO){
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
        
        
    }else{
        //---- Vide ny LemurLifeList local dia mi-load ny online dia atao update ny DB local
        // na koa manaeo pull-to-refresh @ TableView
        
        
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
                    if ([result.nodes count] >0){
                        //-- Efa misy lemurlife list any @ server fa mety ni-reinstall ilay user dia lasa vide
                        // ny base local. Dia miverina mi-reload ilay view
                        [self viewWillAppear:YES];
                    }
                }

            }
            
        }];
        
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
            
            if (error)
            {
                NSLog(@"Error parse : %@", error.debugDescription);
            }
            else
            {
                _lemurLifeList = result.nodes;
                
                [Tools updateLemurLifeListWithNodes:result.nodes];
                
                
                self.tableViewLifeList.delegate = self;
                self.tableViewLifeList.dataSource = self;
                
                [self.tableViewLifeList setHidden:NO];
                
                //---Satria mandeha au background ireto functions ireto dia mila
                // any @ mainThread no manao appel
                
                [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                
                [self performSelectorOnMainThread:@selector(updateViewTitle) withObject:nil waitUntilDone:NO];
                
                
                
            }
            
        }
        
    }];
}


- (void) getMyLemursLifeList{
    
    
    //if(self.intialLoad)[self showActivityScreen];
  
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
            if(appDelegate.showActivity) [self showActivityScreen];
            //[self getLemursListJSONCall];
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
        NSString *updateText = NSLocalizedString(@"updating_list",@"");
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:updateText attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        [self.refreshControl endRefreshing];
    }
    if(appDelegate.showActivity){
        [self removeActivityScreen];
        appDelegate.showActivity = NO;
    }
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        self.pullToRefresh = NO;
        
    }
}

#pragma IBAction

- (IBAction)buttonConnet_Touch:(id)sender {
    
    [self showLoginPopup];
    
}


@end
