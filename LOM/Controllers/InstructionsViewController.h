//
//  InstructionsViewController.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 29/09/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionsViewController : UIViewController

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
@property (weak, nonatomic) IBOutlet UIImageView *image;



@end
