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
#define ALL_PUBLICATION_ENDPOINT @"/all-publication-json"
#define LIFELIST_ENDPOINT @"/list/my-lemur-life-list-json"



@interface AppData : NSObject

+(AppData*)getInstance;

-(void) loginWithUserName:(NSString*)userName andPassword:(NSString*) password forCompletion:(JSONObjectBlock)completeBlock;


-(void) getPublicationForSessionId:(NSString*) session_id andCompletion:(JSONObjectBlock)completeBlock;

-(void) getMyLemurLifeListForSessionId:(NSString*) session_id andCompletion:(JSONObjectBlock)completeBlock;


@end
