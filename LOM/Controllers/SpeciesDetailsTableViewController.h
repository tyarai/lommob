//
//  SpeciesDetailsTableViewController.h
//  LOM
//
//  Created by Ranto Tia ray Andrianavonison on 18/04/2018.
//  Copyright © 2018 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species.h"
#import "MWPhotoBrowser.h"
#import "CameraViewController.h"
#import "PopupLoginViewController.h"

@interface SpeciesDetailsTableViewController : UITableViewController <UIScrollViewDelegate, MWPhotoBrowserDelegate>//CameraViewControllerDelegate
{
    NSInteger _imagePosition;
    CGFloat _lastContentOffset;
    NSArray* _photographs;
    NSTimer* _timerScrollImage;
    MWPhotoBrowser *browser;
    WYPopoverController* popoverController;
    NSInteger selectedMenu;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *identificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *naturalHistoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *conservationLabel;
@property (weak, nonatomic) IBOutlet UILabel *whereToSeeItLabel;
@property (weak, nonatomic) IBOutlet UILabel *geographicLabel;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;
@property (weak, nonatomic) IBOutlet UILabel *scientificName;
@property (weak, nonatomic) IBOutlet UIPageControl *sliderImageControl;
@property (nonatomic, strong) Species* specy;
@property (strong,nonatomic) NSMutableArray *photos;

@end
