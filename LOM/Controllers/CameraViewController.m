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

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.imageView.backgroundColor = nil;
    self.takePhotoButton.tintColor = ORANGE_COLOR;
    self.selectPhotoButton.tintColor = ORANGE_COLOR;
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
    [self saveImageToFile:image];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void) saveImageToFile:(UIImage*) image{
    if(image){
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * fileName = [NSString stringWithFormat: @"%ld_%@_", appDelegate._curentUser.uid, self.currentSpecies._title];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd_HH_mm_ss"];
        NSString * date = [dateFormatter stringFromDate:[NSDate date]];
         fileName = [fileName stringByAppendingString:date];
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
        
        
        /*NSData *data = UIImagePNGRepresentation(image);
        UIImage *tmp = [UIImage imageWithData:data];
        UIImage *afterFixingOrientation = [UIImage imageWithCGImage:tmp.CGImage
                                                              scale:image.scale
                                                        orientation:image.imageOrientation];*/
        
        [UIImageJPEGRepresentation(image, 1.0)writeToFile:filePath atomically:YES];
        
        // Save image.
        //[UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
        
        
        [self addToTakenPhotosCollection:filePath];
        
    }
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
@end
