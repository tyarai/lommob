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
#import "AppData.h"
#import "Constants.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"


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

+(void) showSimpleAlertWithTitle:(NSString*) title
                      andMessage:(NSString*) message
                     parentView :(BaseViewController*)view{
    
    UIAlertController *alertView = [Tools createAlertViewWithTitle:title messsage:message];
    [view presentViewController:alertView animated:YES completion:nil];

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
                NSString * _uuid        = lemurLifeList.uuid;
                NSInteger _uid          = lemurLifeList.uid;
                NSInteger _nid          = lemurLifeList.nid;
                int64_t  _species_nid   = lemurLifeList.species_nid;
               
                //LemurLifeListTable* instance = [LemurLifeListTable getLemurLifeListBySpeciesID:_species_nid];
                //LemurLifeListTable* instance = [LemurLifeListTable getLemurLifeListByUUID:_uuid];
                LemurLifeListTable* instance = [LemurLifeListTable getLemurLifeListBySpeciesNID:_nid];
                
                NSString * _title       = lemurLifeList.title;
                _title = [_title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                
                NSString * _species     = lemurLifeList.species;
                _species = [_species stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                NSString * _where_see_it= lemurLifeList.where_see;
                NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate * date          = [[NSDate alloc]init];
                date                   = [formatter dateFromString:lemurLifeList.see_first_time];
                int64_t  _when_see_it  = [date timeIntervalSince1970];
                NSString * _photo_name  = lemurLifeList.lemur_photo.src;
                
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
                    newLemurLifeListTable._uid          = _uid;
                    
                    [newLemurLifeListTable save];
                }else{
                   
                    //--- Update by _nid ---//
                    
                    NSString * query = [NSString stringWithFormat:@"UPDATE $T SET _where_see_it = '%@' , _when_see_it = '%li' , _title = '%@' , _species = '%@' , _photo_name = '%@'  , _uuid = '%@' , _nid = '%li' , _species_id = '%li' , _uid = '%li' WHERE _nid = '%li'  ",
                                       _where_see_it,(long)_when_see_it,_title,_species,_photo_name,_uuid,(long)_nid,(long)_species_nid,(long)_uid,(long)_nid];
                    
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
                Publication* sighting           = node.node;
                
                NSString * _uuid                = sighting.uuid;
                int64_t  _nid                   = sighting.nid;
                Sightings* instance             = [Sightings getSightingsByNID : _nid];
                NSString * _title               = sighting.title;
                _title                          = [_title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                NSString * _species             = sighting.species;
                _species                        = [_species stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                
                NSString * _where_see_it        = sighting.place_name;
                _where_see_it                   = [_where_see_it stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                
                
                
                NSDateFormatter * formatter     = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate * date                   = [[NSDate alloc]init];
                date                            = [formatter dateFromString:sighting.date];
                int64_t   _date                 =  [date timeIntervalSince1970];
                NSString * _photo_name          = sighting.field_photo.src;
                _photo_name                     = [_photo_name stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                int64_t  _species_nid           = sighting.speciesNid;
                
                int64_t  _count                 = sighting.count;
                int64_t  _uid                   = sighting.uid;
                NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                
                //NSDate *createdDate             = [[NSDate alloc]init];
                //createdDate                     = [dateFormatter dateFromString:sighting.created];
                //int64_t  _created               = [createdDate timeIntervalSince1970];
                
                NSDate * now                    = [NSDate date];
                int64_t  _created               = [now timeIntervalSince1970];
                
                float _latitude                 = (float)sighting.latitude;
                float _longitude                = (float)sighting.longitude;
                int64_t place_name_ref_nid      = sighting.place_name_reference_nid;
                
                NSString *error                 = [NSString stringWithFormat:@" PhotoName nil! title =%@ nid=%lli photo = %@ ",_title,_nid,_photo_name];
                
                int64_t _deleted                = sighting.deleted;
                int64_t _synced                 = sighting.isSynced;
                int64_t _local                  = sighting.isLocal;
                
                NSAssert(_photo_name != nil, error);
                
                @try {
                    
                    if(    instance == nil 
                           && _nid > 0
                           && ![Tools isNullOrEmptyString:_species]
                           && _species_nid > 0
                           && _count > 0
                           && ![Tools isNullOrEmptyString:_where_see_it]
                           && ![Tools isNullOrEmptyString:_photo_name]
                           && ![Tools isNullOrEmptyString:_title]
                           && ![Tools isNullOrEmptyString:_uuid]
                           && _uid > 0
                           && place_name_ref_nid > 0
                       ){
                        //---Tsy mbola misy ao anaty base-tablet ity Sighting ity dia ampina ao (créé tany @ server)
                        
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
                        newSighting._date           = _date;
                        newSighting._createdTime    = _created;
                        newSighting._modifiedTime   = _created;
                        newSighting._uuid           = _uuid;
                        newSighting._uid            = _uid;
                        //newSighting._isLocal      = _local;
                        //newSighting._isSynced     = _synced;
                        //newSighting._deleted        = _deleted;
                        newSighting._isLocal        = 0; // Update Sept 19 2017
                        newSighting._isSynced       = 1; // Update Sept 19 2017
                        newSighting._deleted        = 0; // Update Sept 19 2017
                        
                        newSighting._place_name_reference_nid = place_name_ref_nid;
                        
                        [newSighting save];
                        
                    }else{
                        
                      
                        NSString * query = [NSString stringWithFormat:@"UPDATE $T SET _uuid = '%@' , _speciesName = '%@' , _speciesNid = '%lli' , _speciesCount = '%lli' , _placeName = '%@' , _placeLatitude = '%.10f' , _placeLongitude = '%.10f' , _photoFileNames ='%@' , _title = '%@' , _modifiedTime = '%lli' , _date = '%lli', _uid = '%lli' , _isSynced = '%lli', _isLocal = '%lli', _deleted = '%lli' , _place_name_reference_nid = '%lli' WHERE _nid = '%lli' ",
                                            _uuid,_species,_species_nid,_count,_where_see_it,_latitude,_longitude,_photo_name,_title,_created,_date,_uid,_synced,_local,_deleted,place_name_ref_nid,_nid];
                        
                        [Sightings executeUpdateQuery:query];
                        
                        //---- Vonona @ izay ilay fichier image local -----//
                        [Tools removeImageFileFromDocumentsDirectory:_photo_name];
                    }
                   
                } @catch (NSException *exception) {
                    
                    NSLog(@"Insert/Update database error");
                    
                } @finally {
                    
                }
                

                
            }
        }
    }
}
/*
  --- Mamafa ny image file ao @ Documents rehefa synced any @ server --
 */

+(void) removeImageFileFromDocumentsDirectory:(NSString*) imageURL{
    if(! [Tools isNullOrEmptyString:imageURL]){
        NSURL * url = [NSURL URLWithString:imageURL];
        if(url){
            NSString* fileName = [url lastPathComponent];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
            NSFileManager * fileManager = [NSFileManager defaultManager];
            if([fileManager fileExistsAtPath:imagePath isDirectory:nil]){
                [fileManager removeItemAtPath:imagePath error:nil];
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

+(void) emptySightingTable{
    [Sightings emptySightingsTable];
}


/**
    UPDATE OCT 11 2016
 */

+(void) updateLocalSightingsUserUIDDWith:(NSUInteger) uid{
    if(uid != 0){
        NSString * query = [NSString stringWithFormat:@"UPDATE Sightings SET _uid = '%lu'",(unsigned long)uid];
        [Sightings executeUpdateQuery:query];
    }
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
        case 2:{
            UIAlertController* alert = [Tools createAlertViewWithTitle:NSLocalizedString(@"signupTitle",@"") messsage:NSLocalizedString(@"signupExistingNameOrMail",@"")];
            
            [view presentViewController:alert animated:YES completion:nil];
            break;
        }
            
            
        default:{
            UIAlertController* alert = [Tools createAlertViewWithTitle:@"Lemurs of Madagascar" messsage:@"There was an error!"];
            [view presentViewController:alert animated:YES completion:nil];
            break;
        }
    }
    
    if (view.refreshControl){
        [view.refreshControl endRefreshing];
    }
}


+(NSString*) base64:(UIImage*)image{
    if(image){
        NSData * imageData = UIImageJPEGRepresentation(image, 1.0);
        NSString * base64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        return base64;
    }
    return nil;
}

/*
+(void) saveSyncDate{

    NSDate *currDate = [NSDate date];//Current time in UTC time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *syncDate = [dateFormatter stringFromDate:currDate];
    [Tools setUserPreferenceWithKey:LAST_SYNC_DATE andStringValue:syncDate];
}*/

+(void) saveSyncDate{
    
    NSDate *currDate    = [NSDate date];//Current time in UTC time
    int64_t  _now       = [currDate timeIntervalSince1970];
    [Tools setUserPreferenceWithKey:LAST_SYNC_DATE andStringValue:[NSString stringWithFormat:@"%lli", _now]];
}


+ (void) saveSessId:(NSString*)sessid
        sessionName:(NSString*) session_name
           andToken:(NSString*) token
                uid:(NSInteger) uid
           userName:(NSString*) userName{
    
    NSString * strUid = [NSString stringWithFormat:@"%ld",(long)uid];
    [Tools setUserPreferenceWithKey:KEY_SESSID andStringValue:sessid];
    [Tools setUserPreferenceWithKey:KEY_SESSION_NAME andStringValue:session_name];
    [Tools setUserPreferenceWithKey:KEY_TOKEN andStringValue:token];
    [Tools setUserPreferenceWithKey:KEY_UID andStringValue:strUid  ];
    [Tools setUserPreferenceWithKey:KEY_USERNAME andStringValue:userName];

}


+(NSString*)htmlToString:(NSString*)html{
    if([html length] >0){
        NSScanner *myScanner;
        NSString *text = nil;
        myScanner = [NSScanner scannerWithString:html];
        
        while ([myScanner isAtEnd] == NO) {
            
            [myScanner scanUpToString:@"<" intoString:NULL] ;
            
            [myScanner scanUpToString:@">" intoString:&text] ;
            
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
        }
        //
        html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        return html;
    }
    return nil;
}


//------------------------------- Manao update ny species local ---------------------

+(void) updateLocalSpeciesWith:(NSArray*) speciesDico{
    
    if(speciesDico != nil){
        
        for (NSDictionary * species in speciesDico) {
            NSString * title                = [species valueForKey:@"title"];
            NSInteger   profile_photograph  = [[species valueForKey:@"profile_photograph_id"] integerValue];
            //NSString *  scientific_name     = [species valueForKey:@"scientific_name"];
            //NSString *  scientist_name      = [species valueForKey:@"scientist_name"];
            NSString *  malagasy            = [species valueForKey:@"malagasy"];
            NSString *  geographic_range    = [species valueForKey:@"geographic_range"];
            NSString *  where_to_see_it     = [species valueForKey:@"where_to_see_it"];
            //NSInteger   extinct             = [[species valueForKey:@"extinct"] integerValue];
            NSString *  other_english       = [species valueForKey:@"other_english"];
            NSString *  german              = [species valueForKey:@"german"];
            NSInteger   map                 = [[species valueForKey:@"map"] integerValue];
            NSInteger   lom_family_id       = [[species valueForKey:@"lom_family_id"] integerValue];
            NSString *  conservation_status = [species valueForKey:@"conservation_status"];
            NSInteger   nid                 = [[species valueForKey:@"nid"] integerValue];
            NSString *  french              = [species valueForKey:@"french"];
            NSArray  *  photograph_ids      = [species valueForKey:@"species_photographs"];
            NSString * stringPhotograph_ids = [photograph_ids componentsJoinedByString:@","];
            //NSInteger  taxa_tid             = [[species valueForKey:@"taxa_tid"]integerValue];
            NSString *  identification      = [species valueForKey:@"identification"];
            NSString *  natural_history     = [species valueForKey:@"natural_history"];
            NSString *  english             = [species valueForKey:@"english"];
            
            //---- Tadiavina aloha sao efa ao ilay Species dia atao update . raha TSIA dia atao insert satria vaovao izany ---//
            Species * species               = [Species getSpeciesBySpeciesNID:(NSInteger)nid];
            
            if(species != nil){
                //---- Efa misy fa atao update ilat speices ---//
                
                NSString * query = [NSString    stringWithFormat:@"UPDATE $T SET  _profile_photograph_id = '%li' , _family_id = '%li' , _title = '%@' , _english = '%@' , _other_english = '%@' , _french = '%@' , _german ='%@' , _malagasy = '%@' , _identification = '%@' , _natural_history = '%@', _geographic_range = '%@' , _conservation_status = '%@', _where_to_see_it = '%@', _map = '%li' , _specie_photograph = '%@' WHERE _species_id = '%li' ",
                                    (long)profile_photograph,(long)lom_family_id,title,english,other_english,french,german,malagasy,identification,natural_history,geographic_range,conservation_status,where_to_see_it,(long)map,stringPhotograph_ids,(long)nid];
                
                [Species executeUpdateQuery:query];
                
                
            }else{
                //---- Tsy mbola misy dia creer-na vaovao mihitsy ilay species ---//
                
                Species * newSpecies = [Species new];
                newSpecies._species_id              = nid;
                newSpecies._title                   = title;
                newSpecies._profile_photograph_id   = profile_photograph;
                newSpecies._family_id               = lom_family_id;
                newSpecies._english                 = english;
                newSpecies._other_english           = other_english;
                newSpecies._french                  = french;
                newSpecies._german                  = german;
                newSpecies._malagasy                = malagasy;
                newSpecies._identification          = identification;
                newSpecies._natural_history         = natural_history;
                newSpecies._geographic_range        = geographic_range;
                newSpecies._conservation_status     = conservation_status;
                newSpecies._where_to_see_it         = where_to_see_it;
                newSpecies._map                     = map;
                newSpecies._specie_photograph       = stringPhotograph_ids;
                
                [newSpecies save];
            }
            
            
        }
    }
}

//----------------- Update local map in database with ones from server (mapsDico) ---------------

+(void) updateLocalMaps:(NSArray*) mapsDico{
    
    if(mapsDico != nil){
        
        for (NSDictionary * maps in mapsDico) {
            
            NSInteger nid = [[maps valueForKey:@"nid"] integerValue];
            NSString * image_url = [maps valueForKey:@"image_url"];
            NSString *filename = [image_url lastPathComponent];
            
            
            
            
            Maps * maps = [Maps getMapByNID:nid];
            
            if(maps != nil){
                
                NSString * query = [NSString stringWithFormat:@"UPDATE $T SET  _file_name = '%@'  WHERE _nid = '%li' ",filename,(long)nid];
                
                [Maps executeUpdateQuery:query];

            }else{
                Maps * newMap = [Maps new];
                newMap._file_name = filename;
                newMap._nid       = nid;
                [newMap save];

            }
            
            [Tools downloadImageAsynchronously:image_url];
            
            
            
            //---- Raha tsy mbola misy en local ilay fichier dia alaina avy any @ server --//
            
            /*NSFileManager *fileManager = [[NSFileManager alloc] init];
            UIImage * image = [UIImage imageNamed:filename];
            
            
            SDWebImageCompletionWithFinishedBlock successBlock =
            
            ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if(image != nil && error == nil && finished){
                    if (image && finished) {
                        // Cache image to disk or memory
                        //[[SDImageCache sharedImageCache] storeImage:image
                          //                                   forKey:filename
                            //                                 toDisk:YES];
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
                        
                        [UIImageJPEGRepresentation(image, 1.0)
                                    writeToFile:filePath
                                    atomically:YES];
                    }
                    NSLog(@"Download Successed");
                }
            };
            
            //if (![fileManager fileExistsAtPath:filename] ){
                
                if(image == nil){
                    //--------- Download image here ------//
                    NSURL * url = [NSURL URLWithString:image_url];
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    [manager downloadImageWithURL:url
                                          options:SDWebImageRetryFailed | SDWebImageContinueInBackground
                                         progress:nil
                                        completed:successBlock];
                }
            //}
             */
        }
    }
}

/*
  DownloadImage from Server (asynchronously)
*/
+(void) downloadImageAsynchronously:(NSString*)image_url{
    
    if(![Tools isNullOrEmptyString:image_url]){
        
        NSURL *url = [NSURL URLWithString:image_url];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:url
                              options:0
             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                 NSLog(@"%li / %li ",(long)receivedSize,(long)expectedSize);
             }
             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image) {
                    NSLog(@"Downloaded");
                }
                else {
                    [self downloadImageAsynchronously:image_url]; //try download once again
                }
        }];
    }
}

//----------------- Update local sites in database with ones from server (sitessDico) -----------

+(void) updateLocalSites:(NSArray*) sitesDico{
    
    if(sitesDico != nil){
        
        for (NSDictionary * sites in sitesDico) {
            
            NSInteger nid     = [[sites valueForKey:@"nid"] integerValue];
            NSString * title  = [sites valueForKey:@"title"];
            NSString * body   = [sites valueForKey:@"body"];
            NSInteger map_id  = [[sites valueForKey:@"map_id"] integerValue];
            
            
            LemursWatchingSites * site = [LemursWatchingSites  getSiteByNID:nid];
            
            if(site != nil){
                
                NSString * query = [NSString stringWithFormat:@"UPDATE $T SET  _title = '%@', _body = '%@', _map_id = '%li'  WHERE _site_id = '%li' ",title,body,map_id,(long)nid];
                
                [LemursWatchingSites executeUpdateQuery:query];
                
            }else{
                LemursWatchingSites * newSite = [LemursWatchingSites new];
                newSite._title = title;
                newSite._body  = body;
                newSite._map_id = map_id;
                [newSite save];
            }
        }
    }

}

//----------------- Update local lemur Families with ones from server (familiesDico) -----------

+(void) updateLocalLemurFamilies:(NSArray*) familiesDico{
   
    if(familiesDico != nil){
        
        for (NSDictionary * family in familiesDico) {
            
            NSInteger nid               = [[family valueForKey:@"nid"] integerValue];
            NSString * title            = [family valueForKey:@"title"];
            NSString * body             = [family valueForKey:@"body"];
            NSString * illustrations    = [family valueForKey:@"illustration_ref"];
            //NSInteger extinct           = [[family valueForKey:@"extinct"] integerValue];
        
            
            Families * _family = [Families  getFamilyByNID:nid];
            
            if(_family != nil){
                
                NSString * query = [NSString stringWithFormat:@"UPDATE $T SET  _family = '%@', _family_description = '%@', _illustration = '%@'  WHERE _nid = '%li' ",title,body,illustrations,(long)nid];
                
                [Families executeUpdateQuery:query];
                
            }else{
                Families * newfamily            = [Families new];
                newfamily._family               = title;
                newfamily._family_description   = body;
                newfamily._illustration         = illustrations;
                [newfamily save];
            }
        }
    }
}

+(void) updateLocalAuthors:(NSArray*) authorDico{
    
}



@end
