//
//  PostsTableViewCell.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 5/23/16.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "AppDelegate.h"
#import "PostsTableViewCell.h"
#import "Tools.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "Species.h"
#import "Photographs.h"
#import "Constants.h"
#import "UIImage+Resize.h"
#import "PostEditTableViewController.h"
#import "LemursWatchingSites.h"

@implementation PostsTableViewCell{
    WYPopoverController *popoverController;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


#pragma WYPopoverControllerDelegate
    
- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller{
    popoverController.delegate = nil;
    popoverController = nil;
}


- (IBAction)menuButtonTapped:(id)sender {
   
    //**** Atao editing eto @ zay ity publication ity dia setter-na ilay variabla any @ appDelegate
    // Ireto publication sy species ireto no raisin'ny SightingDataViewController avy eo
    
    AppDelegate * appDelagate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appDelagate != nil){
        
        appDelagate.appDelegateCurrentPublication = currentPublication;
        Species * currentSpecies = [Species getSpeciesBySpeciesNID:currentPublication.speciesNid];
        appDelagate.appDelegateCurrentSpecies     = currentSpecies;
        
        NSInteger siteNID = currentPublication.place_name_reference_nid;
        LemursWatchingSites * currenSite = [LemursWatchingSites getLemursWatchingSitesByNID:siteNID];
        appDelagate.appDelegateCurrentSite = currenSite;
        
        if(currentPublication && currentSpecies){
            [postsTableViewController performSegueWithIdentifier:@"showPost" sender:postsTableViewController];
        }
    }
   
}

- (IBAction)btnSpeciesInfoTapped:(id)sender {
    if(speciesNID != 0){
    }
    
}

- (void) displaySighting:(Publication*) publication postsTableViewController:(id)tableView{
    
    currentPublication = publication;
    postsTableViewController = tableView;
    
    NSString * syncedText = @"";
    if (!publication.isSynced && publication.isLocal) {
        syncedText = NSLocalizedString(@"not_synced_sighting",@"");;
    }
    self.syncInfo.text = syncedText;
    
    if (![Tools isNullOrEmptyString:publication.species]) {
        self.lblSpecies.text = publication.species;
    }
    
    if (![Tools isNullOrEmptyString:publication.title]) {
        self.lblTitle.text = publication.title;
    }
    
    if (![Tools isNullOrEmptyString:publication.date]) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        NSDate *date = [dateFormat dateFromString:publication.date];
        [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString * strDate = [dateFormat stringFromDate:date];
        self.lblDate.text = strDate;
    }
    
    if(![Tools isNullOrEmptyString:publication.place_name]){
        self.lblPlaceName.text = publication.place_name;
    }
    
       
    NSString * strCount = nil;
    if(publication.count > 0){
        strCount = [NSString stringWithFormat:@"Number observed: %ld",(long)publication.count];
        
    }else{
        strCount = [NSString stringWithFormat:@"%@",@""];
        
    }
    self.lblSumberObserved.text = strCount;
    
    NSInteger speciesNid = publication.speciesNid;
    speciesNID = speciesNid;
    
    
    if (publication.field_photo != nil && ![Tools isNullOrEmptyString:publication.field_photo.src]){
        
       
        //if(publication.isLocal || !publication.isSynced){
            
            NSFileManager * fileManager = [NSFileManager defaultManager];
        
            //-- T@ nampiditra ilay fileName dia natao escape ny "'" character dia lasa "''"
            // Dia mila unescape 
            NSString * unescapedFileName = [publication.field_photo.src stringByReplacingOccurrencesOfString:@"''" withString:@"'"];
        
            //--- Manao error ilay NSTempUrl any @ PostCellViewController raha vao misy 'space' ilay url dia tsy maintsy solona '%20' ny space eto
            unescapedFileName = [unescapedFileName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSURL * tempURL = [NSURL URLWithString:unescapedFileName];
            //--- Jerena sao dia efa URL ilay fileName ---//
        
        
            if(tempURL && tempURL.scheme && tempURL.host){
                [self.imgPhoto setImageWithURL:tempURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error != nil) {
                        [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
                    }
                    
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }else{
            
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *ImagePath = [documentsDirectory stringByAppendingPathComponent:publication.field_photo.src];
                
                UIImage *img = nil;
                
                if([fileManager fileExistsAtPath:ImagePath]){
                    NSURL * fileUrl = [NSURL fileURLWithPath:ImagePath];
                    NSData * data = [NSData dataWithContentsOfURL:fileUrl];
                    img = [UIImage imageWithData:data];
                    [self.imgPhoto setImage:img];
                }else{
                    
                    @try {
                        //--- Ilay profile photo no lasa photo satria tsy naka sary ilay olona --//
                        [self.imgPhoto setImage:[UIImage imageNamed:publication.field_photo.src]];
                    } @catch (NSException *exception) {
                        NSLog(@"File does not exist");
                        [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
                    } @finally {
                        
                    }
                    
                    
                    
                }
            }
            
            
        /*}else{
            
            [self.imgPhoto setImageWithURL:[NSURL URLWithString: publication.field_photo.src] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error != nil) {
                    [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
                }
                
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

        }*/
        
    }else{
        [self.imgPhoto setImage:[UIImage imageNamed:@"ico_default_specy"]];
    }
    
    
}

#pragma CameraViewControllerDelegate

-(void)dismissCameraViewController{
    [self.parentTableView dismissCameraViewController];
}

#pragma PostEditTableViewControllerDelagate

-(void)cancelPostEditTableViewController{
    [popoverController dismissPopoverAnimated:YES completion:nil];
}

-(void)reloadPostsTableView{
    
    if(self.parentTableView){
        PostsViewController * postViewController = (PostsViewController*)self.parentTableView;
        //[postViewController dismissViewControllerAnimated:NO completion:nil];
        [postViewController loadLocalSightings];
        //[postViewController synWithServer];
    }
}

@end
