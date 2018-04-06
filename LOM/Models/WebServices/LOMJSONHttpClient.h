//
//  LOMJSONHttpClient.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 06/04/2018.
//  Copyright © 2018 Kerty KAMARY. All rights reserved.
//

#ifndef LOMJSONHttpClient_h
#define LOMJSONHttpClient_h

#import "JSONHTTPClient.h"

@interface LOMJSONHttpClient : JSONHTTPClient

+(void) deleteJSONFromURLWithString:url
                   completion:(JSONObjectBlock)completeBlock;

+(void) putJSONFromURLWithString:url
                       bodyString:body
                       completion:(JSONObjectBlock)completeBlock;

@end


#endif /* LOMJSONHttpClient_h */
