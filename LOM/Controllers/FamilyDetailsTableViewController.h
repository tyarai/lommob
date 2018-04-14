//
//  FamilyDetailsTableViewController.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 13/04/2018.
//  Copyright © 2018 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "Families.h"

@interface FamilyDetailsTableViewController : UITableViewController <UIScrollViewDelegate, MWPhotoBrowserDelegate>{
    NSInteger _imagePosition;
    CGFloat _lastContentOffset;
    NSArray* _illustrations;
    NSTimer* _timerScrollImage;
    MWPhotoBrowser *browser;
}

@property (nonatomic, strong) Families* families;
@property (strong,nonatomic) NSMutableArray *photos;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UITextView *txtText;
@property (weak, nonatomic) IBOutlet UIPageControl*sliderImageControl;

@end
