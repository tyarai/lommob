//
//  FamiliesDetailsViewController.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 01/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "Families.h"

@interface FamiliesDetailsViewController : UIViewController <UIScrollViewDelegate, MWPhotoBrowserDelegate>{
    NSInteger _imagePosition;
    CGFloat _lastContentOffset;
    NSArray* _illustrations;
    NSTimer* _timerScrollImage;
    MWPhotoBrowser *browser;
}

@property (nonatomic, strong) Families* families;
@property (strong,nonatomic) NSMutableArray *photos;

@end
