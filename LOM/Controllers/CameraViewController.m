//
//  CameraViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 08/10/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "CameraViewController.h"
#import "Constants.h"
#import "PhotoCollectionViewCell.h"
#import "SightingsInfoViewController.h"
#import "SightingDataTableViewController.h"
#import "Tools.h"
#import "Sightings.h"
#import "AppDelegate.h"
#import "User.h"

#define FILE_EXT @".jpeg"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.imageView.backgroundColor = nil;
    self.takePhotoButton.tintColor = ORANGE_COLOR;
    self.selectPhotoButton.tintColor = ORANGE_COLOR;
    self.saveSightingButton.tintColor = ORANGE_COLOR;
    self.photoFileNames = [[NSMutableArray alloc]init];
    self.photoCollection.dataSource = self;
    self.photoCollection.delegate = self;
    self.photoCollection.backgroundColor = [UIColor blackColor];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma UIImagePickerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    NSString * filePath = nil;
    //if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
         //filePath = [self saveImageToFile:image];
    //}
     filePath = [self saveImageToFile:image];
    
    [self addToTakenPhotosCollection:filePath];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(NSString*) saveImageToFile:(UIImage*) image{
    if(image){
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * title = self.currentSpecies._title;
        title = [title stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString * fileName = [NSString stringWithFormat: @"%ld_%@", appDelegate._curentUser.uid, title];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"_yyyy-MM-dd_HH_mm_ss"];
        NSString * date = [dateFormatter stringFromDate:[NSDate date]];
        fileName = [fileName stringByAppendingString:date];
        fileName = [fileName stringByAppendingString:FILE_EXT];
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
        
       [UIImageJPEGRepresentation(image, 1.0)writeToFile:filePath atomically:YES];
        
        return filePath;
        
        
        
    }
    return nil;
}
-(void) addToTakenPhotosCollection:(NSString*)fileName{
    if(fileName){
        [self.photoFileNames addObject:fileName];
        [self.photoCollection reloadData];
    }
}
#pragma UICollectionView 

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.photoFileNames count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCollectionViewCell" forIndexPath:indexPath];

    NSString * fileName = self.photoFileNames[indexPath.row];
    if(fileName && cell){
        UIImage *image = [UIImage imageNamed:fileName];
        if(image){
            [cell addImage:image];
        }
    }
    
    return cell;
}
#pragma SightingInfoViewControllerDelegate

- (IBAction)saveSightingTapped:(id)sender {
    
}

-(void)cancel{
    //[popoverController dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveSightingInfo:(NSInteger)observation placeName:(NSString *)placeName date:(NSDate*)date comments:(NSString *)comments{
    NSInteger _uid = [[Tools getStringUserPreferenceWithKey:KEY_UID] integerValue];
    
    if(observation && placeName && comments && date ){
        NSUUID *uuid = [NSUUID UUID];
        NSString * _uuid        = [uuid UUIDString];
        NSString *_speciesName  = self.currentSpecies._title;
        NSInteger   _nid        = self.currentSpecies._species_id;
        NSInteger  _count       = observation;
        NSString *_placeName    = placeName;
        NSString *_placeLatitude = @"";
        NSString *_placeLongitude= @"";
        NSString *_photoNames    = [self concatenateImageFileNames:@"@"];
        NSString *_title         = comments;
        double  _created         = [date timeIntervalSince1970];
        double  _modified        = [date timeIntervalSince1970];
        Sightings * newSightings = [Sightings new];
        newSightings._uuid          = _uuid;
        newSightings._speciesName   = _speciesName;
        newSightings._nid           = _nid;
        newSightings._uid           = _uid;
        newSightings._speciesCount  = _count;
        newSightings._placeName     = _placeName;
        newSightings._placeLatitude = _placeLatitude;
        newSightings._placeLongitude= _placeLongitude;
        newSightings._photoFileNames= _photoNames;
        newSightings._title         = _title;
        newSightings._createdTime   = _created;
        newSightings._modifiedTime  = _modified;
        newSightings._isLocal       = (int)YES; //From iPhone = YES
        newSightings._isSynced      = (int)NO; // Not yet synced with server
        
        [newSightings save];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.delegate dismissCameraViewController];
}

-(NSString*) concatenateImageFileNames:(NSString*)separator{
    if(separator == nil) separator = @"@";
    NSString * fileNames = [self.photoFileNames componentsJoinedByString:separator];;
    return fileNames;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showSightingData"] ){
        SightingDataTableViewController * vc = (SightingDataTableViewController*)[segue destinationViewController];
        vc.delegate = self;
        vc.species = self.currentSpecies;
    }
}

/*
#pragma mark WYPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller{
    popoverController.delegate = nil;
    popoverController = nil;
}
 */


@end
