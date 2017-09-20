//
//  PostEditTableViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 05/11/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "PostEditTableViewController.h"
#import "SightingDataTableViewController.h"
#import "AppDelegate.h"
#import "Tools.h"
#import "AppData.h"

#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface PostEditTableViewController ()

@end

@implementation PostEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*if(self.currentPublication && self.currentSpecies == nil){
        NSInteger speciesNid = self.currentPublication.speciesNid;
        self.currentSpecies = nil;
        if(speciesNid > 0){
            Species * species = [Species getSpeciesBySpeciesNID:speciesNid];
            self.currentSpecies = species;
        }
    }*/
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch(indexPath.row){
        case 0:
            [self.delegate cancelPostEditTableViewController];
            [self performSegueWithIdentifier:@"editPost" sender:self];
            break;
        case 1:
            [self.delegate cancelPostEditTableViewController];
            break;
        default:
            break;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //[self.delegate cancelPostEditTableViewController];
    if([[segue identifier] isEqualToString:@"editPost"]){
        SightingDataTableViewController * dest = (SightingDataTableViewController*)[segue destinationViewController];
        dest.delegate = self;
        //dest.species = self.currentSpecies;
        //dest.publication = self.currentPublication;
        dest.UIViewDelegate = self.delegate;
        
        __block UIImage *img = nil;
        
        if(self.currentPublication.isLocal){
            
            NSString *getImagePath = [self.currentPublication getSightingImageFullPathName];
            img = [UIImage imageWithContentsOfFile:getImagePath];
            
        }else{
            UIImageView * imageView = [[UIImageView alloc]init];
            
            [imageView setImageWithURL:[NSURL URLWithString: self.currentPublication.field_photo.src] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error == nil) {
                    img = imageView.image;
                }
                
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
        }
        
        //dest.takenPhoto = img;


    }
    
}

#pragma SightingDataTableViewController

-(void)cancelSightingData{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)saveSightingInfo:(NSInteger)observation
              placeName:(NSString *)placeName
                   date:(NSDate *)date
               comments:(NSString *)comments{
    
    AppDelegate * appDelegate = [Tools getAppDelegate];
    
    NSString * sessionName = [appDelegate _sessionName];
    NSString * sessionID   = [appDelegate _sessid];
    NSString * token       = [appDelegate _currentToken];
    NSInteger uid          = [appDelegate _uid];
    
    
    //--- atao Update @ zay ilay  Publication ---//
    if(![Tools isNullOrEmptyString:sessionID] && ![Tools isNullOrEmptyString:sessionName] &&
       ![Tools isNullOrEmptyString:token] &&  uid != 0 && self.currentPublication != nil){
        
        if(observation && placeName && comments && date ){
            
            NSInteger   _nid        = self.currentPublication.nid;
            NSString *  _uuid       = self.currentPublication.uuid;
            NSInteger  _count       = observation;
            NSString *_placeName    = placeName;
            NSString *_title        = comments;
            double _date            = [date timeIntervalSince1970];
            double  _modified       = [[NSDate date] timeIntervalSince1970];
            NSString * query        = nil;
            
            if(_nid > 0 ){
                //------ Update by _nid : Raha efa synced sady nahazo _nid ilay sighting --- //
                
                query = [NSString stringWithFormat:@"UPDATE $T SET  _placeName = '%@' , _title = '%@' , _speciesCount = '%li' ,_modifiedTime = '%f' ,_date = '%f' ,_isSynced = '0' WHERE _nid = '%li' ", _placeName,_title,_count,_modified,_date,(long)_nid];
            }else{
                //---- Update by _uuid : tsy mbola synced sady tsy nahazo _nid avy any @ server
                query = [NSString stringWithFormat:@"UPDATE $T SET  _placeName = '%@' , _title = '%@' , _speciesCount = '%li' ,_modifiedTime = '%f' ,_date = '%f' ,_isSynced = '0' WHERE _uuid = '%@' ", _placeName,_title,_count,_modified,_date,_uuid];
                
            }
            
            [Sightings executeUpdateQuery:query];
            
            [self.delegate reloadPostsTableView];
            
        }
        
        
    }else{
        
        [Tools showSimpleAlertWithTitle:NSLocalizedString(@"authentication_issue", @"") andMessage:NSLocalizedString(@"session_expired", @"")];
        
    }
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.delegate dismissCameraViewController];
    
}


@end
