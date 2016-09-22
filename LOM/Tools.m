//
//  Tools.m
//  EDF-RELAIS
//
//  Created by Hugo Scano on 14/04/2015.
//  Copyright (c) 2015 Madiapps. All rights reserved.
//

#import "Tools.h"
#import "LemurLifeListNode.h"
#import "LemurLifeList.h"
#import "LemurLifeListTable.h"
#import "Sightings.h"
#import "PublicationNode.h"


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

//********************************************************************
// Update Ranto Sept 8 2016
//********************************************************************
/*
    Manao update ny LemurLifeList ao anaty Tablet
 */
+(void) updateLemurLifeListWithNodes:(NSArray<LemurLifeListNode>*) nodes{
    if(nodes != nil && [nodes count] > 0){
        for (LemurLifeListNode *node in nodes) {
            if(node){
                LemurLifeList* lemurLifeList = node.node;
                NSString * _uuid = lemurLifeList.uuid;
                LemurLifeListTable* instance = [LemurLifeListTable getLemurLifeListByUUID:_uuid];
                NSString * _title       = lemurLifeList.title;
                NSString * _species     = lemurLifeList.species;
                NSString * _where_see_it= lemurLifeList.where_see;
                NSString * _when_see_it = lemurLifeList.see_first_time;
                NSString * _photo_name  = lemurLifeList.lemur_photo.src;
                int64_t  _species_nid   = lemurLifeList.species_nid;
                int64_t    _nid         = lemurLifeList.nid;

                if(instance == nil){
                    //---Tsy mbola misy ao anaty base-tablet ity lemur life list ity dia apina ao --
                    
                    LemurLifeListTable * newLemurLifeListTable = [LemurLifeListTable new];
                    newLemurLifeListTable._title        = _title;
                    newLemurLifeListTable._species      = _species;
                    newLemurLifeListTable._where_see_it = _where_see_it;
                    newLemurLifeListTable._when_see_it  = _when_see_it;
                    newLemurLifeListTable._photo_name   = _photo_name;
                    newLemurLifeListTable._species_id   = _species_nid;
                    newLemurLifeListTable._nid          = _nid;
                    newLemurLifeListTable._uuid         = _uuid;
                    
                    [newLemurLifeListTable save];
                }else{
                   
                    
                    NSString * query = [NSString stringWithFormat:@"UPDATE $T SET _where_see_it = '%@' , _when_see_it = '%@' , _title = '%@' , _species = '%@' , _photo_name = '%@' , _nid = '%lli' , _species_id = '%lli'  WHERE _uuid = '%@' ",
                                       _where_see_it,_when_see_it,_title,_species,_photo_name,_nid,_species_nid,_uuid];
                    
                    [LemurLifeListTable executeUpdateQuery:query];
                    
                  
                }
            }
        }
    }
}

/**
    Update the local sightings table
 */
+(void) updateSightingsWithNodes:(NSArray<PublicationNode>*) nodes{
    if(nodes != nil && [nodes count] > 0){
        for (PublicationNode *node in nodes) {
            if(node){
                Publication* sighting = node.node;
                
                NSString * _uuid = sighting.uuid;
                Sightings* instance = [Sightings getSightingsByUUID:_uuid];
                NSString * _title       = sighting.title;
                NSString * _species     = sighting.species;
                NSString * _where_see_it= sighting.place_name;
                //NSDate * date = [NSDate dateWithTimeIntervalSince1970:sighting.];
                NSString * _photo_name  = sighting.field_photo.src;
                int64_t  _species_nid   = sighting.speciesNid;
                int64_t  _nid           = sighting.nid;
                int64_t  _count         = sighting.count;
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSDate *createdDate     = [[NSDate alloc]init];
                createdDate             = [dateFormatter dateFromString:sighting.created];
                int64_t  _created       = [createdDate timeIntervalSince1970];
                NSString * _latitude    = sighting.latitude;
                NSString * _longitude   = sighting.longitude;
                
                
                NSString *error = [NSString stringWithFormat:@" title =%@ nid=%lli photo = %@ ",_title,_nid,_photo_name];
                NSAssert(_photo_name != nil, error);
                
                if(instance == nil){
                    //---Tsy mbola misy ao anaty base-tablet ity lemur life list ity dia apina ao --
                    
                    Sightings * newSighting     = [Sightings new];
                    newSighting._nid            = _nid;
                    newSighting._speciesName    = _species;
                    newSighting._speciesNid     = _species_nid;
                    newSighting._speciesCount   = _count;
                    newSighting._placeName      = _where_see_it;
                    newSighting._placeLatitude  = _latitude;
                    newSighting._placeLongitude = _longitude;
                    newSighting._photoFileNames = _photo_name;
                    newSighting._title          = _title;
                    newSighting._createdTime    = _created;
                    newSighting._uuid           = _uuid;
                    
                    [newSighting save];
                    
                }else{
                    
                    
                    NSString * query = [NSString stringWithFormat:@"UPDATE $T SET _nid = '%lli' , _speciesName = '%@' , _speciesNid = '%lli' , _speciesCount = '%lli' , _placeName = '%@' , _placeLatitude = '%@' , _placeLongitude = '%@' , _photoFileNames ='%@' , _title = '%@' , _createdTime = '%lli' WHERE _uuid = '%@' ",
                    _nid,_species,_species_nid,_count,_where_see_it,_latitude,_longitude,_photo_name,_title,_created,_uuid];
                    
                    [Sightings executeUpdateQuery:query];
                    
                    
                }
            }
        }
    }
}


/**
    UPDATE Sept 15
 */

+(void) emptyLemurLifeListTable{
    [LemurLifeListTable emptyLemurLifeListTable];
}

+(void) emptySigntingTable{
    [Sightings emptySightingsTable];
}


+(void) showError:(JSONModelError*) err onViewController:(BaseViewController*) view{
    
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
            UIAlertController* alert = [Tools createAlertViewWithTitle:NSLocalizedString(@"network_issue",@"") messsage:NSLocalizedString(@"server_not_found",@"")];
            [view presentViewController:alert animated:YES completion:nil];
            break;
        }
        case -1004:{
            UIAlertController* alert = [Tools createAlertViewWithTitle:NSLocalizedString(@"network_issue",@"") messsage:NSLocalizedString(@"could_not_connect_to_server",@"")];
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
    
    if (view.refreshControl){
        [view.refreshControl endRefreshing];
    }
}

@end
