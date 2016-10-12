//
//  CameraViewController.h
//  LOM
//
//  Created by Ranto Andrianavonison on 08/10/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//


#import "WYPopoverController.h"
#import "BaseViewController.h"
#import "Species.h"
#import "SightingDataTableViewController.h"

@protocol CameraViewControllerDelegate <NSObject>

-(void) dismissCameraViewController;

@end

@interface CameraViewController : BaseViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SightingDataTableViewControllerDelegate>{
    
    WYPopoverController* popoverController;
}
@property (nonatomic, retain) id<CameraViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)takePhoto:(id)sender;
- (IBAction)selectPhoto:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *selectPhotoButton;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollection;
@property (strong) NSMutableArray* photoFileNames;
@property (weak, nonatomic) IBOutlet UIButton *saveSightingButton;
- (IBAction)saveSightingTapped:(id)sender;
@property (strong) Species *currentSpecies;
@end
