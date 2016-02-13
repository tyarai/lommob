//
//  UIView+Corner.m
//  ATA-Client
//
//  Created by Hugo Scano on 14/10/2015.
//  Copyright © 2015 Synertic. All rights reserved.
//

#import "UIView+Corner.h"

@implementation UIView (Corner)

@dynamic borderColor,borderWidth,cornerRadius;

-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}


@end
