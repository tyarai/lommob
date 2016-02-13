//
//  SpeciesDetailsViewController.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 16/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species.h"
#import "MWPhotoBrowser.h"

@interface SpeciesDetailsViewController : UIViewController <UIScrollViewDelegate, MWPhotoBrowserDelegate>
{
    NSInteger _imagePosition;
    CGFloat _lastContentOffset;
    NSArray* _photographs;
    NSTimer* _timerScrollImage;
    MWPhotoBrowser *browser;
}

@property (nonatomic, strong) Species* specy;
@property (strong,nonatomic) NSMutableArray *photos;

@end
