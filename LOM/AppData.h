//
//  AppData.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONHTTPClient.h"

#define SERVER @"https://www.lemursofmadagascar.com/html"
#define LOGIN_ENDPOINT @"/user/login.json"
#define ALL_PUBLICATION_ENDPOINT @"/all-publication-json"
#define LIFELIST_ENDPOINT @"/list/my-lemur-life-list-json"


@interface AppData : NSObject

+(AppData*)getInstance;

-(void) loginWithUserName:(NSString*)userName andPassword:(NSString*) password forCompletion:(JSONObjectBlock)completeBlock;

-(void) getPublicationForCompletion:(JSONObjectBlock)completeBlock;

-(void) getMyLemurLifeListForCompletion:(JSONObjectBlock)completeBlock;


@end
