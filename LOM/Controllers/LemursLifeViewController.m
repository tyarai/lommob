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
#import "PopupLoginViewController.h"
#import "LoginResult.h"
#import "Constants.h"
#import "LemurLifeListNode.h"
#import "Reachability.h"

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
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];//ORANGE_COLOR;
    self.refreshControl.tintColor = [UIColor blackColor];
    
    [self.refreshControl addTarget:self
                            action:@selector(getMyLemursLifeList)
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
    
    //    Publication* publication = (Publication*) [_lemurLifeList objectAtIndex:indexPath.row];
    
    //LemurLifeListNode* lifeList = (LemurLifeListNode*) [_lemurLifeList objectAtIndex:indexPath.row];
    
   
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
        
        [self removeActivityScreen];
        
        if (err)
        {
            //[Tools showSimpleAlertWithTitle:@"LOM" andMessage:err.debugDescription];
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
    
}


- (void) saveSessId:(NSString*)sessid sessionName:(NSString*) session_name andToken:(NSString*) token{
    
    [Tools setUserPreferenceWithKey:KEY_SESSID andStringValue:sessid];
    [Tools setUserPreferenceWithKey:KEY_SESSION_NAME andStringValue:session_name];
    [Tools setUserPreferenceWithKey:KEY_TOKEN andStringValue:token];
}



- (void) getMyLemursLifeList{
    
    
    
    
    if(self.intialLoad) [self showActivityScreen];
    
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
                
                
                self.tableViewLifeList.delegate = self;
                self.tableViewLifeList.dataSource = self;
                
                //[self.tableViewLifeList reloadData];
                
                [self.tableViewLifeList setHidden:NO];
                
                                //---Satria mandeha au background ireto functions ireto dia mila
                // any @ mainThread no manao appel
                
                [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                
                [self performSelectorOnMainThread:@selector(updateViewTitle) withObject:nil waitUntilDone:NO];
                
                
                
            }
            
        }
        [self removeActivityScreen];
        
    }];
    
    self.intialLoad = NO;
    
}

- (void) updateViewTitle{
    NSInteger count = [_lemurLifeList count];
    NSString * _count = [NSString stringWithFormat:@" (%ld species)",count];
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
}


#pragma IBAction

- (IBAction)buttonConnet_Touch:(id)sender {
    
    [self showLoginPopup];
    
}


@end
