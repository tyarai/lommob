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
#import "UserConnectedResult.h"
#import "UIImage+Resize.h"
#import "LemurLifeListTable.h"
#import "LoginResult.h"



//#define FILE_EXT @".jpeg"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.imageView.backgroundColor = nil;
    self.takePhotoButton.tintColor = ORANGE_COLOR;
    self.cancelButton.tintColor = ORANGE_COLOR;
    self.saveSightingButton.tintColor = ORANGE_COLOR;
    
    //---- Update May 17 2017 ---//
    self.photoFileName = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma UIImagePickerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    
    self.imageView.image = image;
    self.photoFileName = [self saveImageToFile:image];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(UIImage*) resizeImage:(UIImage*) image scaledSize:(CGSize) newSize{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)resizeImage:(UIImage *)image newWidth:(float)maxWidth newHeight:(float)maxHeight
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.75;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(NSString*) saveImageToFile:(UIImage*) image{
    if(image){
        AppDelegate * appDelagate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        Species * currentSpecies = appDelagate.appDelegateCurrentSpecies;
        
        if(currentSpecies != nil){
        
            UIImage * resizedImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                                 bounds:CGSizeMake(IMAGE_RESIZED_WIDTH , IMAGE_RESIZED_HEIGHT)
                                                   interpolationQuality:1];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * title     = currentSpecies._title;
            NSInteger speciesNid = currentSpecies._species_id;
            title = [title stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            NSString * fileName = [NSString stringWithFormat: @"%ld_%li", appDelegate._uid, (long)speciesNid];
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"_yyyy-MM-dd_HH_mm_ss"];
            NSString * date = [dateFormatter stringFromDate:[NSDate date]];
            fileName = [fileName stringByAppendingString:date];
            fileName = [fileName stringByAppendingString:FILE_EXT];
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
            
           [UIImageJPEGRepresentation(resizedImage, 1.0)writeToFile:filePath atomically:YES];
            
            //return filePath;
            return fileName;
        }
            
    }
    return nil;
}






#pragma SightingInfoViewControllerDelegate

- (IBAction)saveSightingTapped:(id)sender {
    
    AppDelegate * appDelagate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Publication * currentPublication = appDelagate.appDelegateCurrentPublication;
    //-- Rehefa new sighting vao tena ilaina ity currentSpecies ity izy fa rehefa edit Sighting dia izay species miaraka @ ilay currentPublication no ampiasaina --//
    Species     * currentSpecies    = nil;
    if(self.isAdding){
        currentSpecies    = appDelagate.appDelegateCurrentSpecies;
    }else{
        NSUInteger speciesID = currentPublication.speciesNid;
        currentSpecies    = [Species getSpeciesBySpeciesNID:speciesID];
    }
    [self.delegate saveCamera:self.photoFileName
                  publication:currentPublication
                      species:currentSpecies];
}

- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)cancelPhoto:(id)sender {

    //---- Delete the photo that was just taken ----//
    if(![Tools isNullOrEmptyString:self.photoFileName]){
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *ImagePath = [documentsDirectory stringByAppendingPathComponent:self.photoFileName];
        if([fileManager fileExistsAtPath:ImagePath]){
            [fileManager removeItemAtPath:ImagePath error:nil];
        }
    }
    [self.delegate dismissCameraViewController];
}




@end
