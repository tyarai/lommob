//
//  AppData.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONHTTPClient.h"


#ifdef DEBUG
    #define SERVER @"http://192.168.2.242"
#else
    #define SERVER @"https://www.lemursofmadagascar.com/html"
#endif


#define LOGIN_ENDPOINT @"/lom_endpoint/user/login.json"
#define LOGOUT_ENDPOINT @"/lom_endpoint/user/logout.json"
#define ISCONNECTED_ENDPOINT @"/lom_endpoint/system/connect.json"
#define ALL_PUBLICATION_ENDPOINT @"/all-publication-json"
#define MY_SIGHTINGS_ENDPOINT @"/api/v1/list/my-sightings-json"
#define LIFELIST_ENDPOINT @"/api/v1/list/my-lemur-life-list-json"



@interface AppData : NSObject

+(AppData*)getInstance;

-(void) loginWithUserName:(NSString*)userName andPassword:(NSString*) password forCompletion:(JSONObjectBlock)completeBlock;

-(void) logoutUserName:(NSString*)userName forCompletion:(JSONObjectBlock)completeBlock;

-(void) CheckSession:(NSString*)sessionName
           sessionID:(NSString*)sessionID
      viewController:(id) viewController
       completeBlock:(JSONObjectBlock)completeBlock;


-(void) getSightingsForSessionId:(NSString*) session_id andCompletion:(JSONObjectBlock)completeBlock;

-(void) getMyLemurLifeListForSessionId:(NSString*) session_id andCompletion:(JSONObjectBlock)completeBlock;


@end
