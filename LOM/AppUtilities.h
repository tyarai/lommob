//
//  AppUtilities.h
//  LCCapp
//
//  Created by Andy Watson on 19/11/2012.
//  Copyright (c) 2012 mtcMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


@interface AppUtilities : NSObject

+(void)setAppScale:(float)scale;
+(void)initAppSettings;

+(CGRect) generateFrame:(CGRect) frame;
+(CGRect) generateFrame:(CGRect) frame Centred:(BOOL)state;
+(CGSize) generateSize:(CGSize) size;
+(float) statusBarHeight;
+(UIImage*)loadImage:(NSString*) filename;
+(float) getScreenWidth;
+(float) getScreenHeight;
+(float) getScreenScale;
+(NSString*)getUUID;
+ (CGFloat)fontSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size AndLabel:(UILabel*)label;
+(BOOL)isNullOrEmptyString:(NSString*)input;
+ (NSDate*)parseDate:(NSString*)inStrDate format:(NSString*)inFormat;
+(UIColor*)colorWithHexString:(NSString*)hex;
+ (CGFloat)measureHeightOfUITextView:(UITextView *)textView;
+ (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width;
+(BOOL) saveArrayInFile:(NSString*)fileName tabToSave:(NSMutableArray*)tabToSave;
+(void) configureScrollViewContentSize:(UIScrollView*) scrollView;
+(void) loadHtmlFile:(NSString*) htmlFile WithWebView:(UIWebView*) webView;
@end
