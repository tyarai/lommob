//
//  URLConnectDelegate.h
//  TWApp
//
//  Created by Hugo on 08/05/2013.
//  Copyright (c) 2013 Hugo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol URLConnectDelegate <NSObject>

@optional
- (void)connectionFailed;
- (void)responseRecieved:(NSString*) response ;
- (void) dataFromServerSecureReceive:(NSMutableDictionary*)data andUrlCalled:(NSString*)url withParam:(NSMutableDictionary*)param;
- (void) dataFromServerSecureEmptyReply;
- (void) dataFromServerSecureTimeOut;
- (void) dataFromServerSecureError:(NSError*)error;
- (void)jsonKitException: (NSException*) ex;

@end
