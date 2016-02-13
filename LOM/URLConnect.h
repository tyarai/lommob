//
//  URLConnect.h
//  GenericMTC
//
//  Created by Andrew Watson on 27/11/2012.
//  Copyright 2012 mtc Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLConnectDelegate.h"

@interface URLConnect : NSObject
{
    NSString* project;
   
}

@property (nonatomic, strong) NSMutableData* data;
@property (nonatomic, strong) id <URLConnectDelegate> delegate;

+(URLConnect*)getInstance;

-(void)sendServer:(NSString*)server withData:(NSArray*)data;
-(void)sendServer:(NSString*)server withDictionary:(NSDictionary*)data;
-(void)sendServer:(NSString*)server withDictionary:(NSDictionary*)data withRequestType:(NSString*)type;
-(void)sendServerWithString:(NSArray*)postInfo;

-(NSString*)getDatafromServer:(NSString*)url;
-(void)getDatafromServerSecure:(NSString*)url  withRequestType:(NSString*)type;
//-(NSString*)getDatafromServerSecure:(NSString*)url;
-(NSString*)getDatafromServerSecure:(NSString*)url withArray:(NSArray*)data withRequestType:(NSString*)type;
-(void)getDatafromServerSecure:(NSString*)url withDictionary:(NSDictionary*)data withRequestType:(NSString*)type withParam:(NSMutableDictionary*)param;

-(BOOL)checkConnection;
@end
