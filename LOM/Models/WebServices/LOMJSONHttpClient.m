//
//  LOMJSONHttpClient.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 06/04/2018.
//  Copyright © 2018 Kerty KAMARY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LOMJSONHttpClient.h"


@implementation LOMJSONHttpClient

+(void) deleteJSONFromURLWithString:urlString completion:(JSONObjectBlock)completeBlock {
    
    [self JSONFromURLWithString:urlString method:@"DELETE"
                         params:nil
                   orBodyString:nil
                     completion:^(id json, JSONModelError* e) {
                       if (completeBlock) completeBlock(json, e);
                   }];
}

+(void) putJSONFromURLWithString:urlString
                      bodyString:body
                      completion:(JSONObjectBlock)completeBlock {

    
    [self JSONFromURLWithString:urlString method:@"PUT"
                         params:nil
                   orBodyString:body
                     completion:^(id json, JSONModelError* e) {
                         if (completeBlock) completeBlock(json, e);
                     }];
}

@end
