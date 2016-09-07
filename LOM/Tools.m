//
//  Tools.m
//  EDF-RELAIS
//
//  Created by Hugo Scano on 14/04/2015.
//  Copyright (c) 2015 Madiapps. All rights reserved.
//

#import "Tools.h"

@implementation Tools

static float appScale = 1.0;

+ (void) setPaddingLeft:(int) padding For:(UITextField*) textfield{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padding, textfield.frame.size.height)];
    leftView.backgroundColor = textfield.backgroundColor;
    textfield.leftView = leftView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
}

+(void) underlineTextInButton:(UIButton*) button{
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:button.titleLabel.text];
    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
    [button setAttributedTitle:commentString forState:UIControlStateNormal];
}

+(AppDelegate *) getAppDelegate{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

+(void) scaleLabel:(UILabel *)label{
    CGSize constraintSize;
    constraintSize.height = MAXFLOAT;
    constraintSize.width = 355.0f;
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:label.font.familyName size:label.font.pointSize], NSFontAttributeName,
                                          nil];
    
    CGRect frame = [label.text boundingRectWithSize:constraintSize
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributesDictionary
                                            context:nil];
    
    CGSize stringSize =  CGSizeMake( roundf(frame.size.width) + 8, roundf(frame.size.height)) ;
    
    CGRect labelFrame = label.frame;
    labelFrame.origin = label.frame.origin;
    labelFrame.size = stringSize;
    label.frame = labelFrame;
    
}


+(UITableViewCell*) getCell:(UITableView*)tableView identifier:(NSString*)identifier {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        UIViewController *cellVC = [[UIViewController alloc]initWithNibName:identifier bundle:nil];
        cell = (UITableViewCell *)cellVC.view;
    }
    return cell;
}


+(UIViewController*) getViewControllerFromStoryBoardWithIdentifier:(NSString*) identifier{
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* controller = [mystoryboard instantiateViewControllerWithIdentifier:identifier];
    return controller;
}


+(void) changePlaceholderColorWith:(UIColor*) color ToTextField:(UITextField*) textField{
    [textField setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}


+(void) roundedThisImageView:(UIImageView*) imageView{
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.clipsToBounds = YES;
}


+(BOOL) isImage:(UIImage*) image1 EqualTo:(UIImage*) image2{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    return [data1 isEqualToData:data2];
}

+(UIImage *)roundedRectImageFromImage:(UIImage *)image withRadious:(CGFloat)radious {
    
    if(radious == 0.0f)
        return image;
    
    if( image != nil) {
        
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        
        CGRect rect = CGRectMake(0.0f, 0.0f, imageWidth, imageHeight);
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        const CGFloat scale = window.screen.scale;
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextBeginPath(context);
        CGContextSaveGState(context);
        CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextScaleCTM (context, radious, radious);
        
        CGFloat rectWidth = CGRectGetWidth (rect)/radious;
        CGFloat rectHeight = CGRectGetHeight (rect)/radious;
        
        CGContextMoveToPoint(context, rectWidth, rectHeight/2.0f);
        CGContextAddArcToPoint(context, rectWidth, rectHeight, rectWidth/2.0f, rectHeight, radious);
        CGContextAddArcToPoint(context, 0.0f, rectHeight, 0.0f, rectHeight/2.0f, radious);
        CGContextAddArcToPoint(context, 0.0f, 0.0f, rectWidth/2.0f, 0.0f, radious);
        CGContextAddArcToPoint(context, rectWidth, 0.0f, rectWidth, rectHeight/2.0f, radious);
        CGContextRestoreGState(context);
        CGContextClosePath(context);
        CGContextClip(context);
        
        [image drawInRect:CGRectMake(0.0f, 0.0f, imageWidth, imageHeight)];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    return nil;
}

+(NSString*) getAlphabetLetterAtIndex:(NSInteger) index{
    NSArray* alphabet = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    return [alphabet objectAtIndex:index];
}

+(void) setUserPreferenceWithKey:(NSString*) key andStringValue:(NSString*) value{
    
    NSLog(@"VALUE : %@ KEY :%@", value, key);
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:value forKey:key];
    //  Save to disk
    const BOOL didSave = [preferences synchronize];
    if (!didSave){
        NSLog(@"Could not save to disk");
    }
}

+(NSString*) getStringUserPreferenceWithKey:(NSString*) key{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([preferences objectForKey:key] == nil){
        return @"";
    }
    else{
        return [preferences objectForKey:key];
    }
}


+(void) showSimpleAlertWithTitle:(NSString*) title andMessage:(NSString*) message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

+ (void) copyDatabaseIfNeeded:(NSString*) databaseName {
    
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [Tools getDatabasePath:databaseName];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

+ (NSString *) getDatabasePath:(NSString*) fileName
{
    //Search for standard documents using NSSearchPathForDirectoriesInDomains
    //First Param = Searching the documents directory
    //Second Param = Searching the Users directory and not the System
    //Expand any tildes and identify home directories.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:fileName];
}

+(NSString*) getNowDateFormated:(NSString*) dateFormat
{
    NSDate* nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:nowDate];
}

+(NSString*) getUdid{
    if (IS_OS_8_OR_LATER) {
        return [Tools getUdidIOS8Above];
    }
    NSString* uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uniqueIdentifier;
}

+(NSString*) getUdidIOS8Above{
    if([[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] bundleIdentifier]])
        return [[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] bundleIdentifier]];
    
    @autoreleasepool {
        
        CFUUIDRef uuidReference = CFUUIDCreate(nil);
        CFStringRef stringReference = CFUUIDCreateString(nil, uuidReference);
        NSString *uuidString = (__bridge NSString *)(stringReference);
        [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:[[NSBundle mainBundle] bundleIdentifier]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        CFRelease(uuidReference);
        CFRelease(stringReference);
        return uuidString;
    }
}

+(void) setBoolUserPreferenceWithKey:(NSString*) key andValue:(BOOL) value {
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setBool:value forKey:key];
    const BOOL didSave = [preferences synchronize];
    if (!didSave){
        NSLog(@"Could not save to disk");
    }
}

+(BOOL) getBoolUserPreferenceWithKey:(NSString*) key {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    return [preferences boolForKey:key] ;
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

+(BOOL)isNullOrEmptyString:(NSString*)input {
    if (input!=nil && input.length > 0)
        return NO;
    else
        return YES;
}

+(CGRect) generateFrame:(CGRect) frame
{
    return [Tools generateFrame:frame Centred:NO];
}

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

//********************************************************************
// Update Ranto July 26 2016
//********************************************************************
+(UIAlertController*) createAlertViewWithTitle:(NSString*) title messsage:(NSString*)message{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    
    
    
    [alert addAction:yesButton];
    
    return alert;
    
}

+(void) showError:(JSONModelError*) err onViewController:(UIViewController*) view{
    
    switch (err.code){
        case -1009:{
            UIAlertController* alert = [Tools createAlertViewWithTitle:NSLocalizedString(@"network_issue",@"") messsage:NSLocalizedString(@"not_connected_to_the_internet",@"")];
            [view presentViewController:alert animated:YES completion:nil];
            break;
        }
        case -1005:{
            UIAlertController* alert = [Tools createAlertViewWithTitle:NSLocalizedString(@"network_issue",@"") messsage:NSLocalizedString(@"network_connection_was_lost",@"")];
            [view presentViewController:alert animated:YES completion:nil];
            break;
        }
    
        case -1001:{
            UIAlertController* alert = [Tools createAlertViewWithTitle:NSLocalizedString(@"network_issue",@"") messsage:NSLocalizedString(@"timed_out",@"")];
            [view presentViewController:alert animated:YES completion:nil];
            break;
        }
        case -1003:{
            UIAlertController* alert = [Tools createAlertViewWithTitle:NSLocalizedString(@"server_not_found",@"") messsage:NSLocalizedString(@"timed_out",@"")];
            [view presentViewController:alert animated:YES completion:nil];
            break;
        }
        case -1012:{
            UIAlertController* alert = [Tools createAlertViewWithTitle:NSLocalizedString(@"authentication_issue",@"") messsage:NSLocalizedString(@"wrong_password_username",@"")];
            [view presentViewController:alert animated:YES completion:nil];
            break;
        }
    
            
        default:{
            UIAlertController* alert = [Tools createAlertViewWithTitle:@"Lemurs of Madagascar" messsage:err.debugDescription];
            [view presentViewController:alert animated:YES completion:nil];
            break;
        }
    }
}

@end
