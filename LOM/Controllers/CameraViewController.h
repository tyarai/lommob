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

@interface CameraViewController : BaseViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,SightingDataTableViewControllerDelegate>{
    
    WYPopoverController* popoverController;
}
@property (nonatomic, retain) id<CameraViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)takePhoto:(id)sender;
- (IBAction)cancelPhoto:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollection;
@property (strong) NSString * photoFileName;
@property (weak, nonatomic) IBOutlet UIButton *saveSightingButton;
- (IBAction)saveSightingTapped:(id)sender;
@property (strong) Species *currentSpecies;
@end
