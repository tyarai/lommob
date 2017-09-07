//
//  ViewController.m
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
#import "LOM_TableViewCell.h"
#import "UITableViewCell+Stretch.h"
#import "SDImageCache.h"
#import "SpeciesDetailsViewController.h"
#import "SightingDataTableViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"



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
    
    
    self.navigationItem.title = NSLocalizedString(@"sightings_title",@"");
    self.navigationItem.titleView = nil;
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];
    
    self.tableViewLifeList.rowHeight = UITableViewAutomaticDimension;
    self.tableViewLifeList.estimatedRowHeight = 365;
    self.tableViewLifeList.backgroundColor = nil;
    self.tableViewLifeList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //---- Array of photo to be shown on the next Window ----
    self.currentPhotos = [[NSMutableArray alloc] init];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableViewLifeList reloadData];
}

-(void) refreshListFromOnlineData{
    
    if ([Tools isNullOrEmptyString:appDelegate._currentToken]){
        [self showLoginPopup ];
        [self.tableViewLifeList setHidden:YES];
    }else{
        self.pullToRefresh = YES;
        appDelegate.showActivity = NO;
        [self syncWithServer];
        //[self loadOnlineSightings];
        
    }
    
}
     
-(void) syncWithServer{
    
    if ([Tools isNullOrEmptyString:appDelegate._currentToken]){
        
        [self showLoginPopup ];
        [self.tableViewLifeList setHidden:YES];
        //[Tools emptySightingTable];
        //[Tools emptyLemurLifeListTable];
        
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
                [self.refreshControl endRefreshing];
                return;
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
                
                //--- Rehefa vita tanteraka mitsy ny syncWithServer zay vao mampidina ny avy any @ server ---
                postsViewControllerFunctionCallback callback = ^(void){
                    [self loadOnlineSightings];
                };
                
                [appData syncWithServer:notSyncedSightings
                            sessionName:sessionName
                              sessionID:sessionID
                               callback:callback];
                
                [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                
                
            }else{
                [self showLoginPopup ];
                [self.tableViewLifeList setHidden:YES];
               
            }
        }];
        
    }

    
    
    
}

#pragma CameraViewControllerDelegate

-(void)dismissCameraViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showLoginPopup{
    NSString* indentifier=@"PopupLoginViewController";
    loginPopup = (PopupLoginViewController*) [Tools getViewControllerFromStoryBoardWithIdentifier:indentifier];
    loginPopup.delegate = self;
    
  
    [self presentViewController:loginPopup animated:YES completion:nil];
    
}


- (void) viewWillAppear:(BOOL)animated{
    
    isAdding = NO;
    [super viewWillAppear:animated];
    [self loadLocalSightings];
    
}


- (void) loadLocalSightings{
    if(!self.pullToRefresh && !appDelegate.showActivity){
        [self showActivityScreen];
    }
    
    NSInteger _uid = appDelegate._uid;
    NSArray *  currentUserSighting = [Sightings getSightingsByUID:_uid];
    NSMutableArray * nodeLists = nil;
    _sightingsList = nil;
    
    if([currentUserSighting count] > 0 ){
        nodeLists = [NSMutableArray new];
        
        @try{
            
            for (Sightings *row in currentUserSighting) {
                
                PublicationNode * listNode = [PublicationNode new];
                Publication * node = [Publication new];
                node.title          = row._title;
                node.species        = row._speciesName;
                node.place_name      = row._placeName;
                node.uid            = row._uid;
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:row._date];
                node.date = [date description];
                NSDate* createdDate = [NSDate dateWithTimeIntervalSince1970:row._createdTime];
                node.created        = [createdDate description];

                Photo * photo       = [Photo new];
                photo.src           = row._photoFileNames;//<--- Mety sary betsaka
                node.field_photo    = photo;
                node.nid            = row._nid;
                node.speciesNid     = row._speciesNid;
                node.uuid           = row._uuid;
                node.isLocal        = row._isLocal;
                node.isSynced       = row._isSynced;
                node.count          = row._speciesCount;
               
                //--- Updated May 20 2017 ---//
                //node.deleted        = row._deleted;
                node.place_name_reference_nid = row._place_name_reference_nid;
                //NSDate* modifiedDate = [NSDate dateWithTimeIntervalSince1970:row._modifiedTime];
                //node.modified        = [modifiedDate description];
                //-----------------------------------------------//
                
                listNode.node       = node;
                [nodeLists addObject:listNode];
            }
            
            _sightingsList = nodeLists;
            
        }@catch(NSException *e){
            NSLog(@"%@",e.description);
        }
        
        
    }
    
    self.tableViewLifeList.delegate = self;
    self.tableViewLifeList.dataSource = self;
    
    [self.tableViewLifeList setHidden:NO];
    
    //---Satria mandeha au background ireto functions ireto dia mila
    // any @ mainThread no manao appel
    
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    //[self performSelectorOnMainThread:@selector(updateViewTitle) withObject:nil waitUntilDone:NO];

}

-(Species*) sightingSpecies:(Sightings*)sighting{
    if(sighting){
        NSInteger speciesNid = sighting._speciesNid;
        NSString * query = [NSString stringWithFormat:@" _species_id = '%ld' ",(long)speciesNid];
        return [Species firstInstanceWhere:query];
    }
    return nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SightingDataTableViewController* dest = (SightingDataTableViewController*) [segue destinationViewController];
    if(!isAdding){
        dest.title =  NSLocalizedString(@"edit_sighting_title",@"");
        //dest.publication = self.selectedPublication;
        
    }else{
        //** Rehefa hanao new Sighting dia atao by default izay species voalohany no atao current
        NSArray<Species*>* _allSpecies = [Species allSpeciesOrderedByTitle:@"ASC"];
        // local variable ao @ Class BaseViewController ny appDelegate --//
        appDelegate.appDelegateCurrentSpecies = (Species*)_allSpecies[0];
        
        //** Atao nil ihany koa ny publication satri vao hanao vaovao **//
        appDelegate.appDelegateCurrentPublication = nil;
        
        dest.title  = NSLocalizedString(@"new_sighting_title",@"");
    }
    dest.delegate = self;
    dest.isAdding = isAdding;
}

#pragma PostTableViewCellDelegate

-(void)performSegueWithSpecies:(Species *)species{
    if(species){
        //self.selectedSpecies = species;
        [self performSegueWithIdentifier:@"showSpeciesInfoFromPost" sender:self];
    }
}


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

#pragma UITableView



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PostsTableViewCell* cell = (PostsTableViewCell*) [Tools getCell:tableView identifier:@"PostsTableViewCell"];
    
    cell.parentTableView = self;
    PublicationNode* sightingNode = (PublicationNode*) [_sightingsList objectAtIndex:indexPath.row];
    
    [cell displaySighting:sightingNode.node postsTableViewController:self];
    
    cell = (PostsTableViewCell*)[cell stretchCell:cell width:self.view.frame.size.width height:self.view.frame.size.height-10];
    
    return cell;
    
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //PublicationNode * sighting = (PublicationNode*) [_sightingsList objectAtIndex:indexPath.row];
    //self.selectedPublication = sighting.node;
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.currentPhotos removeAllObjects];
    
    PublicationNode * sighting = (PublicationNode*) [_sightingsList objectAtIndex:indexPath.row];
    __block UIImageView * tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    __block UIImage * image = [UIImage imageNamed:@"ico_default_specy"];
    if(sighting){
        
        NSString * imageBundleName = [sighting.node getSightingImageFullPathName];
        if(sighting.node.isLocal || !sighting.node.isSynced){
            
            //--- Jerena sao dia efa URL ilay fileName ---//
            NSURL * tempURL = [NSURL URLWithString:sighting.node.field_photo.src];
            
            if(tempURL && tempURL.scheme && tempURL.host){
                
                [tempImageView setImageWithURL:tempURL completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error == nil) {
                        image = tempImageView.image;
                    }
                    
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }else{
                image = [UIImage imageWithContentsOfFile:imageBundleName];
            }
            
            
        }else{
            
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            [imageCache queryDiskCacheForKey:imageBundleName done:^(UIImage *cachedImage,SDImageCacheType cacheType)
             {
                 if(cachedImage){
                    image = cachedImage;
                 }
                 
             }];
            
            
        }
    }
    
    MWPhoto* photo = [MWPhoto photoWithImage:image];
    [self.currentPhotos addObject:photo];
    browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    //browser.navigtionBar.navigationItem.tintColor = ORANGE_COLOR;
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = YES; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = NO; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    [browser setCurrentPhotoIndex:0];
    
    
    [self.navigationController pushViewController:browser animated:YES];
  
}

#pragma mark MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.currentPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.currentPhotos.count) {
        return [self.currentPhotos objectAtIndex:index];
    }
    return nil;
}



#pragma mark WYPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller{
    popoverController.delegate = nil;
    popoverController = nil;
    loginPopup = nil;
}

#pragma mark LoginPopoverDelegate

- (void) cancel{
    [popoverController dismissPopoverAnimated:YES];
}


- (void) validWithUserName:(NSString*) userName password:(NSString*) password andRememberMe:(BOOL) rememberMe
{
    
    [self showActivityScreen];
    
    [appData loginWithUserName:userName andPassword:password forCompletion:^(id json, JSONModelError *err) {
        
        
        if (err)
        {
            [self removeActivityScreen];
            [Tools showError:err onViewController:loginPopup];
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
                        [self saveSessId:loginResult.sessid
                             sessionName:loginResult.session_name
                                andToken:loginResult.token
                                     uid:loginResult.user.uid
                                userName:userName];
                    }
                    
                    appDelegate._currentToken = loginResult.token;
                    appDelegate._curentUser = loginResult.user;
                    appDelegate._sessid = loginResult.sessid;
                    appDelegate._sessionName = loginResult.session_name;
                    appDelegate._uid    = loginResult.user.uid;

                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self refreshListFromOnlineData];
                    [appDelegate syncSettings]; // Asaina mi-load settings avy any @ serveur avy hatrany eto

                    
                }
            }
        }
        
    }];
    
}



    
-(void) loadOnlineSightings{
    
    NSString * sessionName = [appDelegate _sessionName];
    NSString * sessionID   = [appDelegate _sessid];
    
    self.initialLoad = TRUE;
    [appData CheckSession:sessionName sessionID:sessionID viewController:self completeBlock:^(id json, JSONModelError *err) {
        BOOL stillConnected = YES;
        
        [self.refreshControl endRefreshing];
        
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
            [self getPostsJSONCall];// Sady maka ny online no manao update ny local DB
            //[self getChangedNodesJSONCall];
            
        }else{
            [self showLoginPopup ];
            [self.tableViewLifeList setHidden:YES];
            
        }
        
        //[self loadLocalSightings];
    }];
    
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
                [Tools saveSyncDate]; // Ovaina androany ny LAST_SYNC_DATE
                [Tools updateSightingsWithNodes:result.nodes];
                [self loadLocalSightings];
                
                //-- fafana ilay message Empty List lasa background view teo aloha --
                self.tableViewLifeList.backgroundView = nil;
                self.tableViewLifeList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            }
            
        }
        
    }];
    
}



-(void) getChangedNodesJSONCall{
    
    [appData getChangedNodesForSessionId:appDelegate._sessid
                           andCompletion:^(id json, JSONModelError *err) {
        
        if (err) {
            if(self.refreshControl){
                [self.refreshControl endRefreshing];
            }
            [Tools showError:err onViewController:self];
            
        }else{
            
            NSError *error = nil;
            NSString * Data = [NSString stringWithFormat:@"%@",json[0]];
          
            NSData *objectData = [Data dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *changedNodesJSONDictionary = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&error];
            
            if (error){
                NSLog(@"Error parse : %@", error.debugDescription);
            }
            else{
                [appData updateLocalDatabaseWith:changedNodesJSONDictionary];
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




- (void) saveSessId:(NSString*) sessid
        sessionName:(NSString*) session_name
           andToken:(NSString*) token
                uid:(NSInteger) uid
           userName:(NSString*) userName{
    
    NSString * strUid = [NSString stringWithFormat:@"%ld",(long)uid];
    [Tools setUserPreferenceWithKey:KEY_SESSID andStringValue:sessid];
    [Tools setUserPreferenceWithKey:KEY_SESSION_NAME andStringValue:session_name];
    [Tools setUserPreferenceWithKey:KEY_TOKEN andStringValue:token];
    [Tools setUserPreferenceWithKey:KEY_UID andStringValue:strUid  ];
    [Tools setUserPreferenceWithKey:KEY_USERNAME andStringValue:userName];
}

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
                         
                         [self.view layoutIfNeeded];
                         
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
                         [self.view layoutIfNeeded];
                         
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
    
    NSUInteger _uid= [appDelegate _uid];
    if(stringValue){
        NSMutableArray * nodeLists = nil;
        NSArray* lists = [Sightings getSightingsLike:stringValue withUID:_uid];
        if([lists count] > 0 ){
            nodeLists = [NSMutableArray new];
            
            for (Sightings *row in lists) {
                PublicationNode * listNode = [PublicationNode new];
                Publication * node = [Publication new];
                node.title          = row._title;
                node.species   = row._speciesName;
                node.place_name      = row._placeName;
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:row._date];
                node.date = [date description];
                Photo * photo       = [Photo new];
                photo.src           = row._photoFileNames;//<--- Mety sary betsaka
                node.field_photo    = photo;
                node.nid            = row._nid;
                node.speciesNid     = row._speciesNid;
                node.count          = row._speciesCount;
                node.uuid           = row._uuid;
                node.uid            = row._uid;
                node.isLocal        = row._isLocal;
                node.isSynced       = row._isSynced;
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

#pragma -- SightingDataTableViewController ---

-(void)cancelSightingData{
    [self dismissCameraViewController];
    [self loadLocalSightings];
    [self.tableViewLifeList reloadData];
    //[self viewWillAppear:YES];
}

-(void)saveSightingInfo:(Publication*)publication
            species    : (Species*) species
            observation:(NSInteger)observation
              placeName:(NSString *)placeName
             placeNameRef:(LemursWatchingSites*)placeReference
                   date:(NSDate *)date
               comments:(NSString *)comments
          photoFileName:(NSString*)takenPhotoFileName
          placeLatitude:(float)latitude
         placeLongitude:(float)longitude{  
    
    NSString * sessionName = [appDelegate _sessionName];
    NSString * sessionID   = [appDelegate _sessid];
    NSString * token       = [appDelegate _currentToken];
    NSInteger uid          = [appDelegate _uid];
    
    
    //--- atao Update @ zay ilay  Publication ---//
    if(![Tools isNullOrEmptyString:sessionID] && ![Tools isNullOrEmptyString:sessionName] &&
       ![Tools isNullOrEmptyString:token] &&  uid != 0 ){
        
        if(!isAdding && observation && placeName && placeReference && comments && date && publication != nil  && species != nil){
            
                 //----- Updating Sighting ------------//
                
                NSInteger   _nid        = publication.nid;
                NSString *  _uuid       = publication.uuid;
                NSInteger  _count       = observation;
                NSString *_placeName    = placeName;
                NSString *_title        = comments;
                NSString * _speciesName = species._title;
                NSInteger   _speciesNID = species._species_id;
                NSInteger _place_name_reference_nid = placeReference._site_id;
            
                //-- Mampisy error any @ SQLLite raha tsy escaper-na ny quote ' ---//
                //   Special charcetr koa ny '\' dia tsy maintsy atao '\\'
                _title = [_title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                
            
                double _date            = [date timeIntervalSince1970];
                double  _modified       = [[NSDate date] timeIntervalSince1970];
                NSString * query        = nil;
                
                if(_nid > 0 ){
                    
                    //******** Update by _nid : Raha efa synced sady nahazo _nid ilay sighting - //
                    
                    query = [NSString stringWithFormat:@"UPDATE $T SET  _placeName = '%@' , _title = '%@' , _speciesCount = '%li' ,_modifiedTime = '%f' ,_date = '%f' ,_isSynced = '0' , _speciesName = '%@' , _speciesNid ='%li', _photoFileNames = '%@', _place_name_reference_nid = '%li'  WHERE _nid = '%li' ", _placeName,_title,_count,_modified,_date,_speciesName,(long)_speciesNID,takenPhotoFileName,(long)_place_name_reference_nid,(long)_nid];
                }else{
                    //*** Update by _uuid : tsy mbola synced sady tsy nahazo _nid avy any @ server
                    query = [NSString stringWithFormat:@"UPDATE $T SET  _placeName = '%@' , _title = '%@' , _speciesCount = '%li' ,_modifiedTime = '%f' ,_date = '%f' ,_isSynced = '0'  , _speciesName = '%@' , _speciesNid ='%li', _photoFileNames = '%@', _place_name_reference_nid = '%li' WHERE _uuid = '%@' ", _placeName,_title,_count,_modified,_date,_speciesName,(long)_speciesNID,takenPhotoFileName,(long)_place_name_reference_nid,_uuid];
                    
                }
                
                [Sightings executeUpdateQuery:query];
                
            }
        
            if(isAdding && observation && placeName && comments && date && species != nil){
                
                //----- Creating new Sighting ------------//
                
                NSInteger _uid = uid;
                NSUUID *uuid = [NSUUID UUID];
                NSString * _uuid        = [uuid UUIDString];
                NSInteger   _speciesNid = species._species_id;
                NSString *_speciesName  = species._title;
                NSInteger   _nid        = 0;
                NSInteger  _count       = observation;
                NSString *_placeName    = placeName;
                NSString *_placeLatitude = @"";
                NSString *_placeLongitude= @"";
                NSString *_photoName     = takenPhotoFileName;
                NSString *_title         = comments;
                double _date             = [date timeIntervalSince1970];
                double  _created         = [[NSDate date] timeIntervalSince1970];
                double  _modified        = [[NSDate date] timeIntervalSince1970];
                NSInteger _place_name_ref_nid = placeReference._site_id;
                
                Sightings * newSightings = [Sightings new];
                newSightings._uuid          = _uuid;
                newSightings._speciesName   = _speciesName;
                newSightings._speciesNid    = _speciesNid;
                newSightings._nid           = _nid;
                newSightings._uid           = _uid;
                newSightings._speciesCount  = _count;
                newSightings._placeName     = _placeName;
                newSightings._placeLatitude = _placeLatitude;
                newSightings._placeLongitude= _placeLongitude;
                newSightings._photoFileNames= _photoName;
                newSightings._title         = _title;
                newSightings._date          = _date;
                newSightings._createdTime   = _created;
                newSightings._modifiedTime  = _modified;
                newSightings._isLocal       = (int)YES; //From iPhone = YES
                newSightings._isSynced      = (int)NO; // Not yet synced with server
                newSightings._deleted       = (int)NO;
                newSightings._place_name_reference_nid =_place_name_ref_nid;
                
                [newSightings save];
                
            }
                
            [self.tableViewLifeList reloadData];
            
        
        
        
    }else{
        
        [Tools showSimpleAlertWithTitle:NSLocalizedString(@"authentication_issue", @"") andMessage:NSLocalizedString(@"session_expired", @"")];
        
    }
  
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)addButtonTapped:(id)sender {
    
    isAdding = YES;
    [self performSegueWithIdentifier:@"showPost" sender:self];
}
@end
