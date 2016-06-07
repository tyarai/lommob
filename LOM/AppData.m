//
//  AppData.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "AppData.h"
#import "Tools.h"

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


- (void) buildPOSTHeader{
    
    [[JSONHTTPClient requestHeaders] setValue:@"application/json" forKey:@"Accept"];
    [[JSONHTTPClient requestHeaders] setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    
    NSString* token = [Tools getAppDelegate]._currentToken;
    
    if (![Tools isNullOrEmptyString:token]) {
        [[JSONHTTPClient requestHeaders] setValue:token forKey:@"CX-CSRF-Token"];
    }
}


- (void) buildGETHeader{
    
    [[JSONHTTPClient requestHeaders] setValue:@"application/json" forKey:@"Accept"];
    [[JSONHTTPClient requestHeaders] setValue:@"application/json" forKey:@"Content-Type"];
    
    NSString* token = [Tools getAppDelegate]._currentToken;
    
    if (![Tools isNullOrEmptyString:token]) {
        [[JSONHTTPClient requestHeaders] setValue:token forKey:@"CX-CSRF-Token"];
    }
}


- (NSString*) buildBodyForLoginWithUserName:(NSString*) userName andPassword:(NSString*) password{
    return [NSString stringWithFormat:@"username=%@&password=%@",
            userName,
            password];
}


-(void) loginWithUserName:(NSString*)userName andPassword:(NSString*) password forCompletion:(JSONObjectBlock)completeBlock
{
    [self buildPOSTHeader];
    
    NSString* body = [self buildBodyForLoginWithUserName:userName andPassword:password];
    
    NSString* url = [NSString stringWithFormat:@"%@%@", SERVER, LOGIN_ENDPOINT];
    
//    NSString* url = [NSString stringWithFormat:@"https://www.lemursofmadagascar.com%@", LOGIN_ENDPOINT];
    
    [JSONHTTPClient postJSONFromURLWithString:url bodyString:body completion:completeBlock];
}


-(void) getPublicationForSessionId:(NSString*) session_id andCompletion:(JSONObjectBlock)completeBlock
{
    [self buildGETHeader];
    
    if (![Tools isNullOrEmptyString:session_id]) {
        
        NSString* url = [NSString stringWithFormat:@"%@%@?session_name=%@", SERVER, ALL_PUBLICATION_ENDPOINT, session_id];
        
        [JSONHTTPClient getJSONFromURLWithString:url completion:completeBlock];
        
    }
    
    NSString* url = [NSString stringWithFormat:@"%@%@", SERVER, ALL_PUBLICATION_ENDPOINT];
    
    [JSONHTTPClient getJSONFromURLWithString:url completion:completeBlock];
}


-(void) getMyLemurLifeListForSessionId:(NSString*) session_id andCompletion:(JSONObjectBlock)completeBlock
{
    [self buildGETHeader];
    
    if (![Tools isNullOrEmptyString:session_id]) {
    
        NSString* url = [NSString stringWithFormat:@"%@%@?session_name=%@", SERVER, LIFELIST_ENDPOINT, session_id];
        
        [JSONHTTPClient getJSONFromURLWithString:url completion:completeBlock];
        
    }
    
    
}




@end
