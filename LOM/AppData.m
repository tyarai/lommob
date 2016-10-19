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


-(void) loginWithUserName:(NSString*)userName andPassword:(NSString*) password forCompletion:(JSONObjectBlock)completeBlock
{
    [self buildPOSTHeader];
    
    NSString* body = [self buildBodyForLoginWithUserName:userName andPassword:password];
    
    NSString* url = [NSString stringWithFormat:@"%@%@", SERVER, LOGIN_ENDPOINT];
    
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
   
        NSString* url = [NSString stringWithFormat:@"%@%@", SERVER, MY_SIGHTINGS_ENDPOINT];
        
        [JSONHTTPClient getJSONFromURLWithString:url completion:completeBlock];
        
    }
    
}


-(void) getMyLemurLifeListForSessionId:(NSString*) session_id andCompletion:(JSONObjectBlock)completeBlock
{
    [self buildGETHeader];
    
    
    if (![Tools isNullOrEmptyString:session_id]) {
        
        NSString * sessionName = [[Tools getAppDelegate] _sessionName];
        NSString * cookie = [NSString stringWithFormat:@"%@=%@",sessionName,session_id];
        [[JSONHTTPClient requestHeaders] setValue:cookie forKey:@"Cookie"];
    
        NSString* url = [NSString stringWithFormat:@"%@%@", SERVER, LIFELIST_ENDPOINT];
        
        
        [JSONHTTPClient getJSONFromURLWithString:url completion:completeBlock];
        
    }
    
    
}


-(void) syncWithServer:(NSArray<Sightings *>*)sightings sessionName:(NSString*)sessionName sessionID:(NSString*) sessionID{
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
                                       
            
            if(sighting._isLocal && !sighting._isSynced){
                
                [self uploadImage:_base64Image
                         fileName:fileName
                         fileSize:(NSUInteger)fileSize
                         completeBlock:^(id json, JSONModelError *err) {
                        
                    if(err){
                        NSLog(@"Error : %@", err.description);
                    }else{
                        
                        sighting._isSynced = YES;
                        [sighting save];
                        /*NSError* error;
                        NSDictionary* tmpDict = (NSDictionary*) json;
                        FileResult* fileResult = [[FileResult alloc] initWithDictionary:tmpDict error:&error];
                        
                        if (error){
                        
                            NSLog(@"Error parse : %@", error.debugDescription);
                        }
                        else{
                            NSInteger fid  = fileResult.fid;
                            //NSString * uri = fileResult.uri;
                            [self saveSighting:sighting fileID:fid completeBlock:^(id json, JSONModelError *err) {
                                NSError* error;
                                NSDictionary* tmpDict = (NSDictionary*) json;
                                //FileResult* fileResult = [[FileResult alloc] initWithDictionary:tmpDict error:&error];
                                
                                if (error){
                                    NSLog(@"Error parse : %@", error.debugDescription);
                                }
                                else{
                                    
                                }
                            }];
                        }
                         */
                            
                    }
                }];
            }
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
        
        //NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]" "";
        NSString *charactersToEscape = @"!*'();:@+$,/?%#[]" "";
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
        NSString *encodedBody = [body stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
                                 
                                 ;
        
        NSString* url = [NSString stringWithFormat:@"%@%@", SERVER, FILE_ENDPOINT];
        [JSONHTTPClient postJSONFromURLWithString:url bodyString:encodedBody completion:completeBlock];
        
        
       
        
    }
    return 0;
}

-(void) saveSighting:(Sightings*)sighting fileID:(NSInteger)fid completeBlock:(JSONObjectBlock) completeBlock{
    if(sighting){
        NSString * sightingTitle = sighting._title;
        NSInteger speciesNID = sighting._speciesNid;
        
        NSString * body = [NSString stringWithFormat:@"title=[%@]&type=publication&language=und&                           body[und][0][format]=full_html&body[und][0][value]=[%@]&field_associated_species[und][nid]=[%ld]& field_photo[und][0][fid]=[%ld]",sightingTitle,sightingTitle,(long)speciesNID,(long)fid];
        NSString* url = [NSString stringWithFormat:@"%@%@", SERVER, NODE_ENDPOINT];
        [JSONHTTPClient postJSONFromURLWithString:url bodyString:body completion:completeBlock];
        
    }
}

@end
