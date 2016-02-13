//
//  UIView+Corner.h
//  ATA-Client
//
//  Created by Hugo Scano on 14/10/2015.
//  Copyright © 2015 Synertic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (Corner)

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@end
