//
//  AppUtilities.m
//  LCCapp
//
//  Created by Andy Watson on 19/11/2012.
//  Copyright (c) 2012 mtcMobile. All rights reserved.
//

#import "AppUtilities.h"

@implementation AppUtilities


//Default scale of 1.0 is for 960x640

static float appScale = 1.0;
static bool cacheImages = YES;


/**
 Return a device UUID
 @return NSString
 */
+(NSString*)getUUID
{
    NSUserDefaults* defaluts = [NSUserDefaults standardUserDefaults];
    NSString* uuid = [defaluts stringForKey:@"UUID"];
    if(uuid==nil)
    {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        uuid = (__bridge NSString*)string;
        [defaluts setObject:uuid forKey:@"UUID"];
    }
    return uuid;
}

/**
 Init appScale using the screen width
 */
+(void)initAppSettings
{
    float width = [[UIScreen mainScreen] bounds].size.width/**[AppUtilities getScreenScale]*/;
    if(width<640)
        appScale=0.5;
    else
        appScale=1.0;
}

/**
Return the status bar height using the appScale
@return float
 */
+(float) statusBarHeight
{
    return 40.f*appScale;
}

/**
 Return the screen width
 @return float
*/
+(float) getScreenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}

/**
 Return the screen height
 @return float
 */
+(float) getScreenHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

/**
 Return the screen scale 
 @return float
 */
+(float) getScreenScale
{
    float scale=1.0;
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        scale=[[UIScreen mainScreen] scale];
    return scale;
}

/**
 Setter for appScale property
 @param scale a float argument
 */
+(void)setAppScale:(float)scale
{
    appScale=scale;
}

/**
 Return a frame CGRect
 @param frame CGRect a CGRect argument
 @return CGRect
 */
+(CGRect) generateFrame:(CGRect) frame
{
    return [AppUtilities generateFrame:frame Centred:NO];
}

/**
 Return a frame  using appScale
 @param frame CGRect a CGRect argument 
 @param centered the frame a BOOL argument 
 @return CGRect
 */
+(CGRect) generateFrame:(CGRect) frame Centred:(BOOL)state
{
    float width = floor(frame.size.width*appScale);
    float height = floor(frame.size.height*appScale);
    float x = floor(frame.origin.x*appScale);
    float y = floor(frame.origin.y*appScale);
    
    if(state)
    {
        x -= floor(width*0.5);
        y -= floor(height*0.5);
    }

    return CGRectMake(x, y, width, height);
}

/**
 Return size using appScale
 @param size a CGSize argument
 @return CGSize
 */
+(CGSize) generateSize:(CGSize) size
{
    float width = floor(size.width*appScale);
    float height = floor(size.height*appScale);
    return CGSizeMake(width, height);
}

/**
 Return a image if it exists in the ressource file
 @param image name a NSString argument
 @return UIImage or nil if doesn't exist
 */
+(UIImage*)loadImage:(NSString*) filename
{
    if(cacheImages)
    {
        return [UIImage imageNamed:filename];
    }
    else
    {
        return nil;
    }
}


/**
 Return the font size using the label size
 @param the font required an UIFont argument
 @param the font size required a CGSize argument 
 @param the label used an UILabel argument
 @return CGFloat
 */
+ (CGFloat)fontSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size AndLabel:(UILabel*)label
{
    CGFloat fontSize = [font pointSize];
    CGFloat height = [label.text sizeWithFont:font constrainedToSize:CGSizeMake(size.width,FLT_MAX) lineBreakMode:NSLineBreakByCharWrapping].height;
    UIFont *newFont = font;
    
    //Reduce font size while too large, break if no height (empty string)
    while (height > size.height && height != 0)
    {
        fontSize--;
        newFont = [UIFont fontWithName:font.fontName size:fontSize];
        height = [label.text sizeWithFont:newFont constrainedToSize:CGSizeMake(size.width,FLT_MAX) lineBreakMode:NSLineBreakByCharWrapping].height;
    };
    
    // Loop through words in string and resize to fit
    for (NSString *word in [label.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]])
    {
        CGFloat width = [word sizeWithFont:newFont].width;
        while (width > size.width && width != 0)
        {
            fontSize--;
            newFont = [UIFont fontWithName:font.fontName size:fontSize];
            width = [word sizeWithFont:newFont].width;
        }
    }
    return fontSize;
}

+(BOOL)isNullOrEmptyString:(NSString*)input
{
    if (input!=nil && input.length > 0)
        return NO;
    else
        return YES;
}

+ (NSDate*)parseDate:(NSString*)inStrDate format:(NSString*)inFormat
{
    NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setLocale:[NSLocale systemLocale]];
    [dtFormatter setDateFormat:inFormat];
    NSDate* dateOutput = [dtFormatter dateFromString:inStrDate];
    return dateOutput;
}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight;
    }
    else
    {
        return textView.contentSize.height;
    }
}

+ (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}




+ (void)createFileWithName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // 1st, This funcion could allow you to create a file with initial contents.
    // 2nd, You could specify the attributes of values for the owner, group, and permissions.
    // Here we use nil, which means we use default values for these attibutes.
    // 3rd, it will return YES if NSFileManager create it successfully or it exists already.
    if ([manager createFileAtPath:filePath contents:nil attributes:nil]) {
        NSLog(@"Created the File Successfully.");
    } else {
        NSLog(@"Failed to Create the File");
    }
}

+ (void)deleteFileWithName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // Have the absolute path of file named fileName by joining the document path with fileName, separated by path separator.
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // Need to check if the to be deleted file exists.
    if ([manager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        // This function also returnsYES if the item was removed successfully or if path was nil.
        // Returns NO if an error occurred.
        [manager removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"There is an Error: %@", error);
        }
    } else {
        NSLog(@"File %@ doesn't exists", fileName);
    }
}


+ (void) configureScrollViewContentSize:(UIScrollView*) scrollView{
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in scrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [scrollView setContentSize:(CGSizeMake([AppUtilities getScreenWidth], scrollViewHeight + 10.0f))];
}


+ (void) loadHtmlFile:(NSString*) htmlFile WithWebView:(UIWebView*) webView{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:htmlFile ofType:@"html" inDirectory:@"groupe_html"]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}





@end
