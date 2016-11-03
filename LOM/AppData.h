//
//  AppData.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONHTTPClient.h"
#import "Sightings.h"


#ifdef DEBUG
    #define SERVER @"http://192.168.2.242"
    //#define SERVER @"http://172.20.10.10"
#else
    #define SERVER @"https://www.lemursofmadagascar.com/html"
#endif


#define LOGIN_ENDPOINT @"/lom_endpoint/user/login.json"
#define LOGOUT_ENDPOINT @"/lom_endpoint/user/logout.json"
#define REGISTER_ENDPOINT @"/lom_endpoint/user/register.json"
#define FILE_ENDPOINT @"/lom_endpoint/file.json"
#define NODE_ENDPOINT @"/lom_endpoint/node.json"

#define ISCONNECTED_ENDPOINT @"/lom_endpoint/system/connect.json"
#define ALL_PUBLICATION_ENDPOINT @"/all-publication-json"
#define MY_SIGHTINGS_ENDPOINT @"/api/v1/list/sightings" // Misy parameters isLocal
#define ALL_MY_SIGHTINGS_ENDPOINT @"/api/v1/list/all-my-sightings" // Tsy misy parameter
#define MY_SIGHTINGS_MODIFIED_FROM @"/api/v1/list/my-sightings-modified-from" // Parameter  updated date >= date & isLocal = value

#define LIFELIST_ENDPOINT @"/api/v1/list/my-lemur-life-list-json"
#define LAST_SYNC_DATE @"last_sync_date"




@interface AppData : NSObject

+(AppData*)getInstance;

-(void) loginWithUserName:(NSString*)userName andPassword:(NSString*) password forCompletion:(JSONObjectBlock)completeBlock;

-(void) logoutUserName:(NSString*)userName forCompletion:(JSONObjectBlock)completeBlock;

-(void) registerUserName:(NSString*)userName
                password:(NSString*)password
                mail    :(NSString*)mail
           forCompletion:(JSONObjectBlock)completeBlock;

-(void) CheckSession:(NSString*)sessionName
           sessionID:(NSString*)sessionID
      viewController:(id) viewController
       completeBlock:(JSONObjectBlock)completeBlock;


-(void) getSightingsForSessionId:(NSString*) session_id andCompletion:(JSONObjectBlock)completeBlock;

-(void) getMyLemurLifeListForSessionId:(NSString*) session_id andCompletion:(JSONObjectBlock)completeBlock;

-(void) syncWithServer:(NSArray<Sightings *>*)sightings sessionName:(NSString*)sessionName sessionID:(NSString*) sessionID ;


@end
