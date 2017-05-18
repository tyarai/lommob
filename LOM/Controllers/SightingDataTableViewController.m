     //
//  SightingDataTableViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 10/10/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "SightingDataTableViewController.h"
#import "Constants.h"
#import "Tools.h"
#import "CameraViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SpeciesSelectorViewController.h"
#import "Species.h"
#import "LemursWatchingSites.h"
#import "Tools.h"
#import "UIImage+Resize.h"

#define ROWHEIGHT 44
#define PICKERVIEW_ROW_HEIGHT 34

@interface SightingDataTableViewController (){
    NSArray<Species*> * allSpecies;
}

@end

@implementation SightingDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.title;
    
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];
    
    self.cancelButton.tintColor = ORANGE_COLOR;
    self.doneBUtton.tintColor = ORANGE_COLOR;
    
    self.comments.delegate = self;
    self.numberObserved.delegate = self;
    self.placename.delegate = self;
    
    NSDate *today = [[NSDate alloc]init];
    [self.date setMaximumDate:today];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = ROWHEIGHT;
    
    didSelectNewSite = NO;
    
    allSpecies = [Species allSpeciesOrderedByTitle:@"ASC"];
    self.species.delegate = self; // UIPickerView Delegate
    
    self.takenPhotoFileName = nil;
    
    self.scientificName.text = @"";
    self.malagasyName.text   = @"";
 
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * appDelagate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Publication * publication = appDelagate.appDelegateCurrentPublication ;
    Species * currentSpecies = [Species getSpeciesBySpeciesNID:publication.speciesNid];
    
    if(appDelagate.appDelegateCurrentSpecies._species_id != currentSpecies._species_id){
        //***** Izany hoe efa vao avy nanova species tany @ speciesSelector ilay user na koa izay species by default no izy ***//
         currentSpecies = appDelagate.appDelegateCurrentSpecies;
    }
    
    //didSelectNewSite = NO;
    
    if(publication != nil && currentSpecies != nil){
        
        //---- Edit sighting ----
        
        self.numberObserved.text = [NSString stringWithFormat:@"%li",publication.count];
        
        if(didSelectNewSite){
            self.placename.text      = appDelagate.appDelegateCurrentSite._title;
        }else{
            self.placename.text      = publication.place_name;
        }
        self.comments.text       = publication.title;
        
        self.scientificName.text = currentSpecies._title;
        self.malagasyName.text   = currentSpecies._malagasy;
        
        self.takenPhotoFileName = publication.field_photo.src;
        
        if(publication.isLocal || !publication.isSynced){
            
            //--- Jerena sao dia efa URL ilay fileName ---//
            NSURL * tempURL = [NSURL URLWithString:publication.field_photo.src];
            
            if(tempURL && tempURL.scheme && tempURL.host){
                [self.speciesImage setImageWithURL:tempURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error != nil) {
                        [self.speciesImage setImage:[UIImage imageNamed:@"ico_default_specy"]];
                    }
                    
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }else{
                
                NSString *getImagePath = [publication getSightingImageFullPathName];
                UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
                [self.speciesImage setImage:img];
            }
            
        }else{
            
            [self.speciesImage setImageWithURL:[NSURL URLWithString: publication.field_photo.src] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"Finished");
                
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
        }
    
        //Hanaovana conversion ity format voalohany ity
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        
        NSDate *date = [dateFormat dateFromString:publication.date];
        self.date.date = date;
        
    }else{
        //**** Sighting vaovao mihitsy ity ******////
        
        
        if(didSelectNewSite){
            self.placename.text      = appDelagate.appDelegateCurrentSite._title;
        }
        
        [self.delteBtn setHidden:YES]; // Tsy aseho ity button ity raha newSighting
        
        //---- Rehefa "new Sighting" dia izay species voalohany no "by default" --//
        self.scientificName.text = currentSpecies._title;
        self.malagasyName.text   = currentSpecies._malagasy;
        
        if([self.takenPhotoFileName length] != 0){
            
            //****** Jerena sao dia efa URL ilay fileName ******//
            NSURL * tempURL = [NSURL URLWithString:self.takenPhotoFileName ];
            
            if(tempURL && tempURL.scheme && tempURL.host){
                [self.speciesImage setImageWithURL:tempURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error != nil) {
                        [self.speciesImage setImage:[UIImage imageNamed:@"ico_default_specy"]];
                    }
                    
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }else{

                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *ImagePath = [documentsDirectory stringByAppendingPathComponent:self.takenPhotoFileName];
                NSURL * fileUrl = [NSURL fileURLWithPath:ImagePath];
                NSData * data = [NSData dataWithContentsOfURL:fileUrl];
                UIImage * img = [UIImage imageWithData:data];
                [self.speciesImage setImage:img];
            }
        }
        
    }
    
}


-(Species*) findSpeciesByTitle:(NSString*) title{
    if([title length] > 0){
        for (Species* sp in allSpecies) {
            if([sp._title isEqualToString:title]){
                return sp;
            }
        
        }
    }
    return nil;
}


-(NSInteger) findSpeciesBySpeciesID:(NSInteger) speciesNID{
    if(speciesNID > 0){
        NSInteger index = 0;
        for (Species* sp in allSpecies) {
            if(sp._species_id == speciesNID){
                return index;
            }
            index++;
        }
    }
    return -1;
}

-(void)viewWillDisappear:(BOOL)animated{
    //AppDelegate * appDelagate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelagate.appDelegateCurrentPublication   = nil;
    //appDelagate.appDelegateCurrentSpecies       = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (IBAction)cancelTapped:(id)sender {
    
    [self.delegate cancelSightingData];
}

- (IBAction)doneTapped:(id)sender {
    NSString  * comments = self.comments.text;
    NSInteger obs      = [self.numberObserved.text intValue];
    NSDate * obsDate = [self.date date];
    NSString  * place    = self.placename.text;
    NSString * error = nil;
    
    AppDelegate * appDelagate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Publication * currentPublication = appDelagate.appDelegateCurrentPublication;
    Species     * currentSpecies     = appDelagate.appDelegateCurrentSpecies;
    
    //-- Updated on May 17th 2017 -----//
    // Rehefa manao save sighting ka tsy naka sary, dia izay saryin'ilay species no atao by default
    // miaraka amin'ilay publication
    if([Tools isNullOrEmptyString:self.takenPhotoFileName] || self.speciesImage.image == nil){
        self.takenPhotoFileName = [self setDefaultSpeciesImage:currentSpecies];
        //[self saveCamera:self.takenPhotoFileName
        //     publication:currentPublication
        //         species:currentSpecies];
    }
    
    if([self validateEntries:comments
                 observation:obs
                   placeName:place
               photoFileName:self.takenPhotoFileName
                       error:&error]){
        
       [self.delegate saveSightingInfo :currentPublication
                           species     :currentSpecies
                            observation:obs
                              placeName:place
                                   date:obsDate
                               comments:comments
                          photoFileName:self.takenPhotoFileName];
    }else{
        UIAlertController* alert = [Tools createAlertViewWithTitle:NSLocalizedString(@"sightings_title",@"") messsage:error];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
/**
 Raha toa ka tsy naka sary na tsy manana sarin'ilay species ilay olona 
 dia atao sary by default eto (maka sary random @ izay sarin'ilay species
 */
-(NSString*) setDefaultSpeciesImage:(Species*)species{
    
    if(species){
        
        @try {
            
            NSString* imageName = nil;
            NSArray<Photographs*>* speciesPhotos = [species getSpeciePhotographs];
            
            //--- Sarin'ilay species alohan no alaina raha misy, raha toa ka tsy misy mihitsy zay vao atao profile_image
            if([speciesPhotos count] != 0){
                for (Photographs * photo in speciesPhotos) {
                 
                    if(photo != nil){
                        
                        if(![Tools isNullOrEmptyString:photo._photograph]){
                            imageName = [NSString stringWithFormat:@"%@.jpg",photo._photograph];
                            break;
                        }
                    }
                 
                }
            }else{
            
                Photographs* specyProfilPhotograph = [species getSpecieProfilePhotograph];
                imageName = [NSString stringWithFormat:@"%@.jpg", specyProfilPhotograph._photograph];
            }
            
            UIImage* image = [UIImage imageNamed:imageName];
            
            //--- Compresser-na eto ity sary by default ity fa tsy eken'ny serveur online raha mihoatra ny 500KB -----//
            UIImage * resizedImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                                 bounds:CGSizeMake(IMAGE_RESIZED_WIDTH , IMAGE_RESIZED_HEIGHT)
                                                   interpolationQuality:1];
            

            
            
            AppDelegate * appDelegate = [Tools getAppDelegate];
            
            NSString * newfileName = [NSString stringWithFormat: @"%ld_%li", appDelegate._uid, (long)species._species_id];
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"_yyyy-MM-dd_HH_mm_ss"];
            NSString * date = [dateFormatter stringFromDate:[NSDate date]];
            newfileName = [newfileName stringByAppendingString:date];
            newfileName = [newfileName stringByAppendingString:FILE_EXT];

            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:newfileName];
           
            
            NSFileManager * fileManager = [NSFileManager defaultManager];
           
            if(! [fileManager fileExistsAtPath:filePath]){
                //-- Raha tsy misy ilay fichier vao re-creer-na eto --//
                [UIImageJPEGRepresentation(resizedImage, 1.0)writeToFile:filePath atomically:YES];
            }

            
            self.speciesImage.image = resizedImage;
            
            return newfileName;

        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    return nil;
}

-(BOOL) validateEntries:(NSString*)comment
            observation:(NSInteger)observation
            placeName  :(NSString*)placeName
          photoFileName:(NSString*)takenPhotoFileName
            error      : (NSString**) error{
    
    
    if(observation <= 0){
        *error = NSLocalizedString(@"sightingNumberObservedError", @"");
        return NO;
    }

    if([Tools isNullOrEmptyString:placeName]){
        *error = NSLocalizedString(@"sightingPlaceNameError", @"");
        return NO;
    }

    if([Tools isNullOrEmptyString:takenPhotoFileName]){
        *error = NSLocalizedString(@"sightingPhotoFileNameError", @"");
        return NO;
    }

    
    if([Tools isNullOrEmptyString:comment]){
        *error = NSLocalizedString(@"sightingCommentError", @"");
        return NO;
        
    }
    
    
    return YES;
}



#pragma UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma  UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row == 1 && indexPath.section == 0){
        [self performSegueWithIdentifier:@"takeAnotherPhoto" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"takeAnotherPhoto"]){
        CameraViewController        *dest = (CameraViewController*)[segue destinationViewController];
        if(dest){
            dest.delegate = self;
            dest.isAdding = self.isAdding;
        }
    }
}

- (IBAction)myUnwindAction:(UIStoryboardSegue*)unwindSegue{
    NSLog(@"unWindAction");
}

#pragma UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [allSpecies count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Species * species = allSpecies[row];
    return species._title;
}

-(UIView *)pickerView:(UIPickerView *)pickerView
           viewForRow:(NSInteger)row
         forComponent:(NSInteger)component
          reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        CGRect frame = CGRectMake(0.0, 0.0, 300, PICKERVIEW_ROW_HEIGHT);
        tView = [[UILabel alloc] initWithFrame:frame];
        [tView setFont:[UIFont boldSystemFontOfSize:16]];//;[UIFont fontWithName:@"Helvetica" size:14 ]];
        [tView setTextAlignment:NSTextAlignmentLeft];
        tView.numberOfLines=0;
        
    }
    Species * species = allSpecies[row];
    tView.text=species._title;
    
    return tView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return PICKERVIEW_ROW_HEIGHT;
}

#pragma CameraDelegate
-(void)dismissCameraViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveCamera:(NSString *)photoFileName
      publication:(Publication*)publication
          species:(Species *)species{
 
    self.takenPhotoFileName = photoFileName;
    
    if(publication != nil){
        
        publication.field_photo.src = photoFileName;
        //** Niova ny sarin'ity publication ity. Tokony averina notSynced izy izany : Feb-27-2017
        publication.isSynced = NO;
    
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)choosePlaceNameTapped:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WatchingSitesSelectorViewController * siteSelector = [storyboard instantiateViewControllerWithIdentifier:@"siteSelector"];
    
    if(siteSelector){
        siteSelector.delegate = self;
        NSArray* _allSites = [LemursWatchingSites allSitesOrderedByTitle:@"ASC"];
        siteSelector.sites = _allSites;

        siteSelector.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:siteSelector animated:YES completion:nil];
        UIPopoverPresentationController *popController = [siteSelector popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popController.sourceView = self.view;
        popController.sourceRect = CGRectMake(50, 50, 361,361);
        popController.delegate = self;

    }
    
}


- (IBAction)chooseSpeciesTapped:(id)sender {
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     SpeciesSelectorViewController * speciesSelector = [storyboard instantiateViewControllerWithIdentifier:@"speciesSelector"];
    if(speciesSelector){
      
        speciesSelector.delegate = self;
        
        NSArray* _allSpecies = [Species allSpeciesOrderedByTitle:@"ASC"];
        speciesSelector.species = _allSpecies;
        
        speciesSelector.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:speciesSelector animated:YES completion:nil];
        UIPopoverPresentationController *popController = [speciesSelector popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popController.sourceView = self.view;
        popController.sourceRect = CGRectMake(50, 50, 361,361);
        popController.delegate = self;
    }
}

#pragma mark - SiteSelector

-(void)cancelSiteSelector{
    didSelectNewSite = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)doneSiteSelector:(LemursWatchingSites*)site{
    if(site){
        didSelectNewSite = YES;
        //self.placename.text = site._title;
        //self.currentSpecies      = species;
        /*
         @TODO : Niova ny site eto.
         */
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma SpeciesSelectorDelegate

-(void)cancelSpeciesSelector{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)doneSpeciesSelector:(Species*)species{
    if(species){
        self.scientificName.text = species._title;
        self.malagasyName.text   = species._malagasy;
        //self.currentSpecies      = species;
        /*
         @TODO : Niova ny species eto. Raha ohatra ka isAdding=YES dia tokony ho renommer-na @ ity species ity ny self.takenPhotoFileName
         */
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (IBAction)deleteButtonTapped:(id)sender {

    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"delete_sighting_title", @"")
                                 message:NSLocalizedString(@"delete_sighting_message", @"")
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Delete sighting");
        [self deleteSighting]; //Mark the current Sighting as deleted
    }];
    
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel");
    }];
    
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

-(void) deleteSighting{

    AppDelegate * appDelagate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Publication * currentPublication = appDelagate.appDelegateCurrentPublication;
    
    
    if(currentPublication){
        @try {
            
            if(currentPublication.nid != 0){
                //--- Efa synced sady nahazo nid ilay publication
                [currentPublication updateDeletedByNID:1 nid:currentPublication.nid];//Mark as deleted
            }else{
                //--- Tsy mbola synced sady tsy nahazo nid ilay publication
                if(currentPublication.uuid != nil && currentPublication.isSynced == NO){
                    [currentPublication updateDeletedByUUID:1 nid:currentPublication.uuid];//Mark as deleted
                }
            }
            
            [self.delegate cancelSightingData];
            
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
}

@end
