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

#define ROWHEIGHT 70
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
    self.tableView.estimatedRowHeight = 100;

    
    allSpecies = [Species allSpeciesOrderedByTitle:@"ASC"];
    self.species.delegate = self; // UIPickerView Delegate
    
    self.takenPhotoFileName = nil;
 
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.publication != nil){
        
        //---- Edit sighting ----
        
        self.numberObserved.text = [NSString stringWithFormat:@"%li",self.publication.count];
        self.placename.text      = self.publication.place_name;
        self.comments.text       = self.publication.title;
        
        NSInteger speciesNID = self.publication.speciesNid;
        Species * pubSpecies = [Species getSpeciesBySpeciesNID:speciesNID];
        
        self.scientificName.text = pubSpecies._title;
        self.malagasyName.text   = pubSpecies._malagasy;
        
        self.takenPhotoFileName = self.publication.field_photo.src;
        
        if(self.publication.isLocal || !self.publication.isSynced){
            
            //--- Jerena sao dia efa URL ilay fileName ---//
            NSURL * tempURL = [NSURL URLWithString:self.publication.field_photo.src];
            
            if(tempURL && tempURL.scheme && tempURL.host){
                [self.speciesImage setImageWithURL:tempURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error != nil) {
                        [self.speciesImage setImage:[UIImage imageNamed:@"ico_default_specy"]];
                    }
                    
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }else{
                
                NSString *getImagePath = [self.publication getSightingImageFullPathName];
                UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
                [self.speciesImage setImage:img];
            }
            
        }else{
            
            [self.speciesImage setImageWithURL:[NSURL URLWithString: self.publication.field_photo.src] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"Finished");
                
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
        }
    
        //Hanaovana conversion ity format voalohany ity
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        
        NSDate *date = [dateFormat dateFromString:self.publication.date];
        self.date.date = date;
        
    }else{
        //---- Sighting vaovao mihitsy ity ----
        if([self.takenPhotoFileName length] != 0){
            
            //--- Jerena sao dia efa URL ilay fileName ---//
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
    self.publication = nil;
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
    //NSUInteger selectedIndex = [self.species selectedRowInComponent:0];
    //Species * selectedSpecies = allSpecies[selectedIndex];
    
    if([self validateEntries:comments
                 observation:obs
                   placeName:place
               photoFileName:self.takenPhotoFileName
                       error:&error]){
        
       [self.delegate saveSightingInfo:_currentSpecies
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
    if(indexPath.row == 1){
        [self performSegueWithIdentifier:@"takeAnotherPhoto" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"takeAnotherPhoto"]){
        CameraViewController        *dest = (CameraViewController*)[segue destinationViewController];
        if(dest){
            NSUInteger selectedIndex = [self.species selectedRowInComponent:0];
            Species * selectedSpecies = allSpecies[selectedIndex];
            dest.currentSpecies = selectedSpecies;
            dest.delegate = self;
            
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

-(void)saveCamera:(NSString *)photoFileName{
    if([photoFileName length] != 0){
        self.takenPhotoFileName = photoFileName;
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma SpeciesSelectorDelegate

-(void)cancelSpeciesSelector{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)doneSpeciesSelector:(Species*)species{
    if(species){
        self.scientificName.text = species._title;
        self.malagasyName.text   = species._malagasy;
        self.currentSpecies      = species;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
