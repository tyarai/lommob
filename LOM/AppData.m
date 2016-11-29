    //
//  AppData.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "AppData.h"
#import "Tools.h"
#import "UserConnectedResult.h"
#import "BaseViewController.h"
#import "FileResult.h"

@implementation AppData

static AppData* _instance;

+(AppData*)getInstance
{
    @synchronized(self){
        if(!_instance){
            _instance = [[AppData alloc]init];
        }
    }
    return _instance;
}

-(id)init{
    self = [super init];
    if (self){
    }
    return self;
}

- (void) buildPOSTHeader:(NSString*)contentType{
    
    [[JSONHTTPClient requestHeaders] setValue:@"application/json" forKey:@"Accept"];
    [[JSONHTTPClient requestHeaders] setValue:contentType forKey:@"Content-Type"];
    
    NSString* token = [Tools getAppDelegate]._currentToken;
    
    if (![Tools isNullOrEmptyString:token]) {
        [[JSONHTTPClient requestHeaders] setValue:token forKey:@"X-CSRF-Token"];
    }
}




- (void) buildPOSTHeader{
    
    [[JSONHTTPClient requestHeaders] setValue:@"application/json" forKey:@"Accept"];
    [[JSONHTTPClient requestHeaders] setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    
    NSString* token = [Tools getAppDelegate]._currentToken;
    
    if (![Tools isNullOrEmptyString:token]) {
        [[JSONHTTPClient requestHeaders] setValue:token forKey:@"X-CSRF-Token"];
    }
}


- (void) buildGETHeader{
    
    [[JSONHTTPClient requestHeaders] setValue:@"application/json" forKey:@"Accept"];
    [[JSONHTTPClient requestHeaders] setValue:@"application/json" forKey:@"Content-Type"];
    
    NSString* token = [Tools getAppDelegate]._currentToken;
    
    if (![Tools isNullOrEmptyString:token]) {
        [[JSONHTTPClient requestHeaders] setValue:token forKey:@"X-CSRF-Token"];
    }
}


- (NSString*) buildBodyForLoginWithUserName:(NSString*) userName andPassword:(NSString*) password{
    return [NSString stringWithFormat:@"username=%@&password=%@",
            userName,
            password];
}



- (NSString*) buildBodyWithUserName:(NSString*) userName {
    return [NSString stringWithFormat:@"username=%@",userName];
}


#pragma User

-(void) loginWithUserName:(NSString*)userName andPassword:(NSString*) password forCompletion:(JSONObjectBlock)completeBlock
{
    [self buildPOSTHeader];
    
    NSString* body = [self buildBodyForLoginWithUserName:userName andPassword:password];
    
    NSString* url = [NSString stringWithFormat:@"%@%@", SERVER, LOGIN_ENDPOINT];
    
    [JSONHTTPClient postJSONFromURLWithString:url bodyString:body completion:completeBlock];
}

-(void) registerUserName:(NSString*)userName
                password:(NSString*)password
                mail    :(NSString*)mail
           forCompletion:(JSONObjectBlock)completeBlock
{
    [self buildPOSTHeader];
    
    NSString* body = [NSString stringWithFormat:@"account[name]=%@&account[mail]=%@&account[pass]=%@",userName,mail,password];
    
    NSString* url = [NSString stringWithFormat:@"%@%@", SERVER, REGISTER_ENDPOINT];
    
    [JSONHTTPClient postJSONFromURLWithString:url bodyString:body completion:completeBlock];
}



-(void) logoutUserName:(NSString*)userName forCompletion:(JSONObjectBlock)completeBlock {
    
    if(![Tools isNullOrEmptyString:userName]){
        
        [self buildPOSTHeader];
        NSString * sessionName = [[Tools getAppDelegate] _sessionName];
        NSString * sessionID = [[Tools getAppDelegate] _sessid];
        NSString * cookie = [NSString stringWithFormat:@"%@=%@",sessionName,sessionID];
        
        if( ! [Tools isNullOrEmptyString:sessionName] && ! [Tools isNullOrEmptyString:sessionID] && ! [Tools isNullOrEmptyString:cookie]){
            
            NSString* body = [self buildBodyWithUserName:userName] ;
            [[JSONHTTPClient requestHeaders] setValue:cookie forKey:@"Cookie"];
            NSString* url = [NSString stringWithFormat:@"%@%@", SERVER, LOGOUT_ENDPOINT];
            [JSONHTTPClient postJSONFromURLWithString:url bodyString:body completion:completeBlock];
        }

        
    }
}


-(void) CheckSession:(NSString*)sessionName
           sessionID:(NSString*)sessionID
      viewController:(id) viewController
       completeBlock:(JSONObjectBlock)completeBlock{

   if(viewController != nil){
        BaseViewController* viewC =(BaseViewController*)viewController;
       AppDelegate * appDelegate = [viewC getAppDelegate];
       
       if(appDelegate.showActivity ){
            [viewC showActivityScreen];
       }
    }
    
    [self buildPOSTHeader];
     NSString * cookie = [NSString stringWithFormat:@"%@=%@",sessionName,sessionID];
    
    if( ! [Tools isNullOrEmptyString:sessionName] && ! [Tools isNullOrEmptyString:sessionID] && ! [Tools isNullOrEmptyString:cookie]){
        
        [[JSONHTTPClient requestHeaders] setValue:cookie forKey:@"Cookie"];
        NSString* url = [NSString stringWithFormat:@"%@%@", SERVER, ISCONNECTED_ENDPOINT];
        [JSONHTTPClient postJSONFromURLWithString:url bodyString:nil completion:completeBlock];
    }
}




-(void) getSightingsForSessionId:(NSString*) session_id andCompletion:(JSONObjectBlock)completeBlock
{
    [self buildGETHeader];
    
    if (![Tools isNullOrEmptyString:session_id]) {
        
        NSString * sessionName = [[Tools getAppDelegate] _sessionName];
        NSString * cookie = [NSString stringWithFormat:@"%@=%@",sessionName,session_id];
        [[JSONHTTPClient requestHeaders] setValue:cookie forKey:@"Cookie"];
   
        
        NSString* url= nil;
        
        NSString * lastSyncDate = [Tools getStringUserPreferenceWithKey:LAST_SYNC_DATE];
        
        if([Tools isNullOrEmptyString:lastSyncDate]){
            [Tools saveSyncDate];
            //--- Rehefa vao mi-sync voalohany dia alatsaka daholo izay sighting any na Local na tsia --
            url = [NSString stringWithFormat:@"%@%@", SERVER,ALL_MY_SIGHTINGS_ENDPOINT];
            [JSONHTTPClient getJSONFromURLWithString:url completion:completeBlock];
        }else{
            //--- Rehefa vita sync voalohany dia izay Sighting modified from LAST_SYNC_DATE ka isLocal = FALSE sisa no midina ---
            
            url = [NSString stringWithFormat:@"%@%@", SERVER,MY_SIGHTINGS_MODIFIED_FROM];
            //NSDictionary *JSONParam = @{@"isLocal":@"0" , @"changed":lastSyncDate};
            
            NSDictionary *JSONParam = @{@"changed":lastSyncDate};
            
            
            [JSONHTTPClient getJSONFromURLWithString:url params:JSONParam completion:completeBlock];
        }
        
        
        
    }
    
}


-(void) getMyLemurLifeListForSessionId:(NSString*) session_id andCompletion:(JSONObjectBlock)completeBlock
{
    
    if (![Tools isNullOrEmptyString:session_id]) {
    
        [self buildGETHeader];
        
        NSString * sessionName = [[Tools getAppDelegate] _sessionName];
        NSString * cookie = [NSString stringWithFormat:@"%@=%@",sessionName,session_id];
        [[JSONHTTPClient requestHeaders] setValue:cookie forKey:@"Cookie"];
    
        NSString* url= nil;
        NSString * lastSyncDate = [Tools getStringUserPreferenceWithKey:LAST_SYNC_DATE];

        if([Tools isNullOrEmptyString:lastSyncDate]){
            //----- Alatsaka daholo ny LifeList rehetra raha NULL ity date ity ---///
            url = [NSString stringWithFormat:@"%@%@", SERVER, LIFELIST_ENDPOINT];
            [JSONHTTPClient getJSONFromURLWithString:url completion:completeBlock];
        }else{
            url = [NSString stringWithFormat:@"%@%@", SERVER, LIFELIST_ENDPOINT_MODIFIED_FROM];
            NSDictionary *JSONParam = @{@"changed":lastSyncDate};
            [JSONHTTPClient getJSONFromURLWithString:url params:JSONParam completion:completeBlock];
        }
        
    }
    
    
}

-(void) syncLifeListWithServer:(NSArray<LemurLifeListTable *>*)lifeLists
                   sessionName:(NSString*)sessionName
                     sessionID:(NSString*) sessionID{
    
    if([lifeLists count] > 0){
        
        [self buildPOSTHeader];
        NSString * cookie = [NSString stringWithFormat:@"%@=%@",sessionName,sessionID];
        [[JSONHTTPClient requestHeaders] setValue:cookie forKey:@"Cookie"];
        
        for(LemurLifeListTable * list in lifeLists){
            if(list._isLocal && !list._isSynced){
                NSString * _title       = list._title;
                int64_t     _species_id = list._species_id;
                NSString * _species     = list._species;
                //int64_t _uid            = list._uid; //<<-- Tsy mila alefa miakatra tsony ny _uid satria efa misy ilay session user no mitondra azy any @ server
                int64_t _isLocal        = list._isLocal;
                //int64_t _isSynced       = list._isSynced;
                //NSString* _uuid         = list._uuid;
                NSString* _where_see_it = list._where_see_it;
                int64_t _when_see_it    = list._when_see_it;
                //NSString* _photo_name   = list._photo_name;
                
                NSDate *vDate = [NSDate dateWithTimeIntervalSince1970:_when_see_it];
                NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
                [_formatter setDateFormat:@"y-M-d"];
                NSString * strDate = [_formatter stringFromDate:vDate];
                NSString *body = [NSString stringWithFormat:@"type=personal_lemur_life_list_item&language=und"];
                
                NSString * speciesName = [NSString stringWithFormat:@"%@(%lli)",_species,_species_id];
                body = [body stringByAppendingFormat:@"&title=%@",_title];
                body = [body stringByAppendingFormat:@"&field_species[und][0][target_id]=%@",speciesName];
                body = [body stringByAppendingFormat:@"&field_locality[und][0][value]=%@",_where_see_it];
                body = [body stringByAppendingFormat:@"&field_date[und][0][value][date]=%@",strDate];
                body = [body stringByAppendingFormat:@"&field_is_local[und][value]=%lld",_isLocal];
                
                NSString* url = [NSString stringWithFormat:@"%@%@", SERVER, NODE_ENDPOINT];
                [JSONHTTPClient postJSONFromURLWithString:url bodyString:body completion:^(id json, JSONModelError *error) {
                    
                    NSDictionary * retDict = (NSDictionary*)json;
                    
                    
                    if (error != nil){
                        NSLog(@"Error parse : %@", error.debugDescription);
                    }
                    else{
                        //-- Azo ny NID an'ity sighting vaovao ity ----
                        NSInteger newNID = [[retDict valueForKey:@"nid"] integerValue];
                        list._nid = newNID;
                        list._isSynced = YES;
                        list._isLocal  = NO;
                        [list save];
                    }
                }];
                
            }
        }
    }
}

/**
 --- Sync Sighting with server
 */


-(void) syncWithServer:(NSArray<Sightings *>*)sightings
           sessionName:(NSString*)sessionName
             sessionID:(NSString*) sessionID
              callback:(postsViewControllerFunctionCallback)func{
    if([sightings count] != 0){
        
        [self buildPOSTHeader];
        NSString * cookie = [NSString stringWithFormat:@"%@=%@",sessionName,sessionID];
        [[JSONHTTPClient requestHeaders] setValue:cookie forKey:@"Cookie"];
        
        for (Sightings * sighting in sightings) {
            
            NSString* fileName = sighting._photoFileNames;
            NSString * fullPath = [self getImageFullPath:fileName];
            NSURL * url = [NSURL fileURLWithPath: fullPath];
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSUInteger fileSize  = [data length];
            UIImage *img = [[UIImage alloc] initWithData:data];
            NSString * _base64Image = [Tools base64:img];

            
            //---- Create sighting on the server --//
            if(sighting._isLocal && !sighting._isSynced){
               
                    [self uploadImage:_base64Image
                             fileName:fileName
                             fileSize:(NSUInteger)fileSize
                             completeBlock:^(id json, JSONModelError *err) {
                            
                        if(err){
                            NSLog(@"Error : %@", err.description);
                        }else{
                            
                            NSError* error;
                            NSDictionary* tmpDict = (NSDictionary*) json;
                            FileResult* fileResult = [[FileResult alloc] initWithDictionary:tmpDict error:&error];
                            
                            if (error){
                            
                                NSLog(@"Error parse : %@", error.debugDescription);
                            }
                            else{
                                NSInteger fid  = fileResult.fid;
                              
                                [self saveSighting:sighting fileID:fid sessionName:sessionName sessionId:sessionID completeBlock:^(id RETjson, JSONModelError *err) {
                                    NSError* error;
                                    
                                    NSDictionary * retDict = (NSDictionary*)RETjson;
                                    
                                    
                                    if (error){
                                        NSLog(@"Error parse : %@", error.debugDescription);
                                    }
                                    else{
                                        //-- Azo ny NID an'ity sighting vaovao ity ----
                                        NSInteger newNID = [[retDict valueForKey:@"nid"] integerValue];
                                        NSString * photoFileName = [NSString stringWithFormat:@"%@%@%@", SERVER,SERVER_IMAGE_PATH,sighting._photoFileNames];
                                        sighting._photoFileNames = photoFileName;
                                        sighting._nid = newNID;
                                        sighting._isSynced = YES;
                                        sighting._isLocal = NO;
                                        [sighting save];
                                        
                                        //---- Miantso ilay [postViewController loadOnlineSightings] --//
                                        if(func != nil){
                                            func();
                                        }
                                        
                                    }
                                }];
                            }
                            
                            
                        }
                    }];
            }
            
            //--- Update Sighting On Server --//
            if(!sighting._isLocal && !sighting._isSynced){
                
                [self uploadImage:_base64Image
                         fileName:fileName
                         fileSize:(NSUInteger)fileSize
                    completeBlock:^(id json, JSONModelError *err) {
                        
                        if(err){
                            NSLog(@"Error : %@", err.description);
                        }else{
                            NSError* error;
                            NSDictionary* tmpDict = (NSDictionary*) json;
                            FileResult* fileResult = [[FileResult alloc] initWithDictionary:tmpDict error:&error];
                            
                            if (error == nil){
                            
                                NSInteger fid  = fileResult.fid;
                                
                                Species * species = [Species getSpeciesBySpeciesNID:sighting._speciesNid];
                                [self updateSightingWithNID:sighting._nid
                                                      Title:sighting._title
                                                  placeName:sighting._placeName
                                                       date:sighting._date
                                                      count:sighting._speciesCount
                                                    species:species
                                                     fileID:fid
                                                sessionName:sessionName
                                                  sessionId:sessionID
                                              completeBlock:^(id json, JSONModelError *error) {
                                    
                                                  if (error){
                                                      NSLog(@"Error parse : %@", error.debugDescription);
                                                  }
                                                  else{
                                                      
                                                      sighting._isSynced = YES;
                                                      [sighting save];
                                                      
                                                      //---- Miantso ilay [postViewController loadOnlineSightings] --//
                                                      if(func != nil){
                                                          func();
                                                      }
                                                  }
                                }];
                                
                            }
                      }
                        
                }];
                
            }//--Updating
            
            
            
        }//for loop
        
    }else{
        //---- Raha tsy misy ny sightings to alefa miakatra dia tonga dia asaina mi-load ny online avy hatrany --/
        if(func != nil){
            func();
        }
    }
}

-(NSString*) getImageFullPath:(NSString*)file{
    if(file){
        NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir  = [documentPaths objectAtIndex:0];
        
        NSString *outputPath    = [documentsDir stringByAppendingPathComponent:file];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        if ([fileManager fileExistsAtPath:outputPath])
        {
            
            return outputPath;
        }
    }
    return nil;
}



-(NSInteger) uploadImage:(NSString*)imagebase64
                fileName:(NSString*) fileName
                fileSize:(NSUInteger)fileSize
                completeBlock:(JSONObjectBlock) completeBlock{
    
    if(imagebase64){
        
        NSString * body = [NSString stringWithFormat:@"file[file]=%@&file[filename]=%@&file[filepath]=public://%@",imagebase64,fileName,fileName];
        
        NSString *charactersToEscape = @"!*'();:@+$,/?%#[]" "";
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
        NSString *encodedBody = [body stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
                                 
                                 ;
        
        NSString* url = [NSString stringWithFormat:@"%@%@", SERVER, FILE_ENDPOINT];
        [JSONHTTPClient postJSONFromURLWithString:url bodyString:encodedBody completion:completeBlock];
        
        
       
        
    }
    return 0;
}

#pragma SYNC SERVER

/*
    Sync Sighting to server
 */
-(void) saveSighting:(Sightings*)sighting
              fileID:(NSInteger)fid
         sessionName:(NSString*)sessionName
          sessionId :(NSString*)sessionId

       completeBlock:(JSONObjectBlock) completeBlock{
    
    if(sighting && sessionName && sessionId && fid != 0){
        
        [self buildPOSTHeader];
        NSString * cookie = [NSString stringWithFormat:@"%@=%@",sessionName,sessionId];
        [[JSONHTTPClient requestHeaders] setValue:cookie forKey:@"Cookie"];

        NSString * uuid         = sighting._uuid;
        NSString * sightingTitle = sighting._title;
        NSInteger speciesNID = sighting._speciesNid;
        NSString * placeName = sighting._placeName;
        NSString * latitude  = sighting._placeLatitude;
        NSString * longitude = sighting._placeLongitude;
        NSInteger  count     = sighting._speciesCount;
        NSInteger  isLocal   = NO;//sighting._isLocal;
        NSInteger  isSynced  = (int)YES;
        double dateTimeStamp = sighting._date;
        NSTimeInterval _interval= dateTimeStamp;
        NSDate *vDate = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"M/d/y"];
        NSString * strDate = [_formatter stringFromDate:vDate];

        NSString *body = [NSString stringWithFormat:@"type=publication&language=und"];
        
        body = [body stringByAppendingFormat:@"&title=%@",sightingTitle];
        body = [body stringByAppendingFormat:@"&field_uuid[und][0][value]=%@",uuid];
        body = [body stringByAppendingFormat:@"&body[und][0][value]=%@",sightingTitle];
        body = [body stringByAppendingFormat:@"&field_place_name[und][0][value]=%@",placeName];
        body = [body stringByAppendingFormat:@"&field_date[und][0][value][date]=%@",strDate];
        body = [body stringByAppendingFormat:@"&field_associated_species[und][nid]=%lu",speciesNID];
        body = [body stringByAppendingFormat:@"&field_latitude[und][0][value]=%@",latitude];
        body = [body stringByAppendingFormat:@"&field_longitude[und][0][value]=%@",longitude];
        body = [body stringByAppendingFormat:@"&field_is_local[und][value]=%lu",isLocal];
        body = [body stringByAppendingFormat:@"&field_is_synced[und][value]=%lu",isSynced];
        body = [body stringByAppendingFormat:@"&field_count[und][0][value]=%lu",count];
        body = [body stringByAppendingFormat:@"&field_photo[und][0][fid]=%lu",fid];
        
        NSString* url = [NSString stringWithFormat:@"%@%@", SERVER, NODE_ENDPOINT];
        [JSONHTTPClient postJSONFromURLWithString:url bodyString:body completion:completeBlock];
        
    }
}


/*
 Sync-Udate Sighting to server
 */
-(void)   updateSightingWithNID:(NSInteger)nid
                          Title:(NSString*)title
                      placeName:(NSString*) placeName
                           date:(NSInteger)date
                          count:(NSInteger)count
                        species:(Species*) species
                         fileID:(NSInteger)fid
                    sessionName:(NSString*)sessionName
                     sessionId :(NSString*)sessionId
                  completeBlock:(JSONObjectBlock) completeBlock{
    
    if(![Tools isNullOrEmptyString:sessionName] && ![Tools isNullOrEmptyString:sessionId] && nid > 0 &&
       ![Tools isNullOrEmptyString:title] && ![Tools isNullOrEmptyString:placeName] && date != 0 && count > 0 && species != nil && fid >0 ){
        
        [self buildPOSTHeader];
       
        NSString * cookie = [NSString stringWithFormat:@"%@=%@",sessionName,sessionId];
        [[JSONHTTPClient requestHeaders] setValue:cookie forKey:@"Cookie"];
        
       
        NSTimeInterval _interval= date;
        NSDate *vDate = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"M/d/y"];
        NSString * strDate = [_formatter stringFromDate:vDate];
        
        //NSString *body = [NSString stringWithFormat:@"type=publication&language=und"];
        NSString *body = [NSString stringWithFormat:@""];
        
        body = [body stringByAppendingFormat:@"title=%@",title];
        body = [body stringByAppendingFormat:@"&body[und][0][value]=%@",title];
        body = [body stringByAppendingFormat:@"&field_place_name[und][0][value]=%@",placeName];
        body = [body stringByAppendingFormat:@"&field_date[und][0][value][date]=%@",strDate];
        body = [body stringByAppendingFormat:@"&field_count[und][0][value]=%lu",count];
        body = [body stringByAppendingFormat:@"&field_associated_species[und][nid]=%li",(long)species._species_id];
        body = [body stringByAppendingFormat:@"&field_photo[und][0][fid]=%lu",fid];
        
        NSString* url = [NSString stringWithFormat:@"%@%@%li", SERVER, NODE_UPDATE_ENDPOINT,(long)nid];
        [JSONHTTPClient putJSONFromURLWithString:url bodyString:body completion:completeBlock];
        
    }
}


@end
