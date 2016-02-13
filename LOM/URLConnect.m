//
//  URLConnect.m
//  GenericMTC
//
//  Created by Andrew Watson on 27/11/2012.
//  Copyright 2012 mtc Mobile. All rights reserved.
//

#import "URLConnect.h"
#import "Reachability.h"
#import "AppDelegate.h"

#define DEBUG_REQUEST 1
#define DEBUG_REQUEST_MODE 1


@implementation URLConnect

@synthesize delegate;

static URLConnect* _instance;
static NSString* REQUEST_TYPE = @"POST";

+(URLConnect*)getInstance
{
    @synchronized(self)
    {
        if(!_instance)
        {
            _instance = [[URLConnect alloc] init];
        
            
        }
    }
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
       
        
    }
    
    return self;
}

-(BOOL)checkConnection
{
    BOOL retval = true;
    Reachability* hostReach =  [Reachability reachabilityWithHostName:@"www.google.com"];//[Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus netStatus = [hostReach currentReachabilityStatus];
    if(netStatus == NotReachable)
    {
        if([delegate respondsToSelector:@selector(connectionFailed)])
            [delegate connectionFailed];
        retval = false;
    }
    return retval;
}

    // send request to create a new session
   // [self performSelectorInBackground:@selector(sendServer:) withObject:parameters];
-(void)sendServer:(NSString*)server withDictionary:(NSDictionary*)data
{
    [self sendServer:server withDictionary:data withRequestType:@"POST"];
}

-(void)sendServer:(NSString*)server withDictionary:(NSDictionary*)data withRequestType:(NSString*)type
{
    REQUEST_TYPE = type;
    // create our parameters (array needs to be in json encoding)
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString* json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"[-] %@", json);
    
    [self performSelectorInBackground:@selector(sendServerWithString:) withObject:[NSArray arrayWithObjects:server, json, nil]];
}

-(void)sendServer:(NSString*)server withData:(NSArray*)data
{
    [self sendServer:server withData:data withRequestType:@"POST"];
}

-(void)sendServer:(NSString*)server withData:(NSArray*)data withRequestType:(NSString*)type
{
    REQUEST_TYPE = type;
    if(data)
    {
        // create our parameters (array needs to be in json encoding)
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        NSString* json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"[-] %@", json);
        
        [self performSelectorInBackground:@selector(sendServerWithString:) withObject:[NSArray arrayWithObjects:server, json, nil]];
    }
}

-(NSString*)getDatafromServer:(NSString*)url
{
    if(![self checkConnection])
        return @"";
    
    NSString* s = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    return s;
}

-(void)getDatafromServerSecure:(NSString*)url  withRequestType:(NSString*)type
{
    if(![self checkConnection])
    {
        if ([delegate respondsToSelector:@selector(dataFromServerSecureTimeOut)])
        {
            [self.delegate dataFromServerSecureTimeOut];
        }
    }
    else
    {
        if (DEBUG_REQUEST == DEBUG_REQUEST_MODE)
        {
            // NSLog(@"[-] %@", json);
            // NSLog(@"[JSON DATA] %@", jsonData);
        }
        //
        
        NSMutableURLRequest* request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: url] ];
        [request setHTTPMethod: type ];
       // [request setValue:[NSString stringWithFormat:@"%u",[jsonData length]] forHTTPHeaderField:@"Content-Length"];
        //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //[request setHTTPBody: jsonData];
        
        
       
        
        if (DEBUG_REQUEST == DEBUG_REQUEST_MODE)
        {
            //NSLog(@"REQUEST %@",data);
        }
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if ([data length] > 0 && error == nil)
             {
                 NSString* output = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                 
                
                 if (DEBUG_REQUEST == DEBUG_REQUEST_MODE)
                 {
                     NSLog(@"OUTPUT %@",output);
                 }
                 NSError *e = nil;
                 NSMutableDictionary* outputDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
                 if (DEBUG_REQUEST == DEBUG_REQUEST_MODE)
                 {
                     NSLog(@"OUTPUTDIC %@",outputDic);
                 }
                 if (!outputDic)
                 {
                     if([delegate respondsToSelector:@selector(jsonKitException:)])
                     {
                         NSLog(@"Error parsing JSON: %@", e);
                         [delegate jsonKitException:nil];
                     }
                 }
                 else
                 {
                     if (DEBUG_REQUEST == DEBUG_REQUEST_MODE)
                     {
                         //NSLog(@"RESULT %@",[outputDic objectForKey:@"result"]);
                         /*for(NSDictionary *item in outputDic)
                          {
                          NSLog(@"Item: %@", item);
                          }*/
                     }
                     
                     
                     @try
                     {
                         if ([delegate respondsToSelector:@selector(dataFromServerSecureReceive:andUrlCalled:withParam:)])
                         {
                             [delegate dataFromServerSecureReceive:outputDic andUrlCalled:url withParam:nil];
                         }
                     }
                     @catch (NSException *exception)
                     {
                         if([delegate respondsToSelector:@selector(jsonKitException:)])
                         {
                             [delegate jsonKitException:exception];
                         }
                     }
                 }
             }
             else if ([data length] == 0 && error == nil)
             {
                 if ([delegate respondsToSelector:@selector(dataFromServerSecureEmptyReply)])
                 {
                     [self.delegate dataFromServerSecureEmptyReply];
                 }
                 NSLog(@"RESPONSE EMPTY");
             }
             else if (error != nil && error.code == NSURLErrorTimedOut)
             {
                 if ([delegate respondsToSelector:@selector(dataFromServerSecureTimeOut)])
                 {
                     [self.delegate dataFromServerSecureTimeOut];
                 }
                 NSLog(@"TIMOUT");
             }
             else if (error != nil)
             {
                 NSLog(@"ERROR");
                 if ([delegate respondsToSelector:@selector(dataFromServerSecureError:)])
                 {
                     [self.delegate dataFromServerSecureError:error];
                 }
                 
             }
             
         }];
    }
}


-(void)getDatafromServerSecure:(NSString*)url withDictionary:(NSDictionary*)data withRequestType:(NSString*)type withParam:(NSMutableDictionary *)param
{
    if(![self checkConnection])
    {
        if ([delegate respondsToSelector:@selector(dataFromServerSecureTimeOut)])
        {
            [self.delegate dataFromServerSecureTimeOut];
        }
    }
    else
    {
        
        
    
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString* json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", json);
        
        //jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
       if (DEBUG_REQUEST == DEBUG_REQUEST_MODE)
       {
          // NSLog(@"[-] %@", json);
          // NSLog(@"[JSON DATA] %@", jsonData);
       }
           // 
        
        NSMutableURLRequest* request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: url] ];
        [request setHTTPMethod: type ];
        //[request setHTTPBody: jsonData];
       //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody: jsonData];
        

        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        if (DEBUG_REQUEST == DEBUG_REQUEST_MODE)
        {
                NSLog(@"REQUEST %@",data);
        }

        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if ([data length] > 0 && error == nil)
             {
                NSString* output = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                 if ([output isEqualToString:@"false"] || [output isEqualToString:@"true"])
                 {
                    //output = [NSString stringWithFormat:@"%@%@%@",@"{\"result\":[{\"code\":\"",output,@"\"}]}"];
                     output = [NSString stringWithFormat:@"%@%@%@",@"{\"code\":\"",output,@"\"}"];
                    data = [output dataUsingEncoding:NSUTF8StringEncoding];
                 }
                if (DEBUG_REQUEST == DEBUG_REQUEST_MODE)
                {
                    NSLog(@"OUTPUT %@",output);
                }
                NSError *e = nil;
                NSMutableDictionary* outputDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
                 if (DEBUG_REQUEST == DEBUG_REQUEST_MODE)
                 {
                    NSLog(@"OUTPUTDIC %@",outputDic);
                 }
                 if (!outputDic)
                 {
                     if([delegate respondsToSelector:@selector(jsonKitException:)])
                     {
                         NSLog(@"Error parsing JSON: %@", e);
                         [delegate jsonKitException:nil];
                     }
                 }
                 else
                 {
                     if (DEBUG_REQUEST == DEBUG_REQUEST_MODE)
                     {
                        //NSLog(@"RESULT %@",[outputDic objectForKey:@"result"]);
                         /*for(NSDictionary *item in outputDic)
                         {
                             NSLog(@"Item: %@", item);
                         }*/
                     }
                  
                     
                     @try
                     {
                         if ([delegate respondsToSelector:@selector(dataFromServerSecureReceive:andUrlCalled:withParam:)])
                         {
                             [delegate dataFromServerSecureReceive:outputDic andUrlCalled:url withParam:param];
                         }
                     }
                     @catch (NSException *exception)
                     {
                         if([delegate respondsToSelector:@selector(jsonKitException:)])
                         {
                             [delegate jsonKitException:exception];
                         }
                     }
                 }
             }
             else if ([data length] == 0 && error == nil)
             {
                 if ([delegate respondsToSelector:@selector(dataFromServerSecureEmptyReply)])
                 {
                     [self.delegate dataFromServerSecureEmptyReply];
                 }
                   NSLog(@"RESPONSE EMPTY");
             }
             else if (error != nil && error.code == NSURLErrorTimedOut)
             {
                 if ([delegate respondsToSelector:@selector(dataFromServerSecureTimeOut)])
                 {
                     [self.delegate dataFromServerSecureTimeOut];
                 }
                 NSLog(@"TIMOUT");
             }
             else if (error != nil)
             {
                NSLog(@"ERROR %@", error);
                if ([delegate respondsToSelector:@selector(dataFromServerSecureError:)])
                {
                    [self.delegate dataFromServerSecureError:error];
                }
                 
             }
             
         }];
    }
}

-(NSString*)getDatafromServerSecure:(NSString*)url withArray:(NSArray*)data withRequestType:(NSString*)type
{
    if ([NSThread isMainThread])
        NSLog(@"Main Thread 2");
    if(![self checkConnection])
        return @"";
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];

    NSMutableURLRequest* request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: url] ];
    [request setHTTPMethod: type ];
    [request setHTTPBody: jsonData];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"aplication/json" forHTTPHeaderField:@"Content-Type"];
	NSData* returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
    NSString* output = [[NSString alloc] initWithData: returnData encoding:NSUTF8StringEncoding];
    return output;
}


/** sends the given command with parameters to the server and returns a dictionary of values back from server */
-(void)sendServerWithString:(NSArray*)postInfo
{
    
    if ([NSThread isMainThread])
        NSLog(@"Main Thread");
    if(postInfo.count<2)
        return;

    NSString* postURL = [postInfo objectAtIndex:0];
    NSString* postString = [postInfo objectAtIndex:1];
    
    
    if(![self checkConnection])
        return;
    
    NSMutableURLRequest* request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: postURL] ]; 
    [request setHTTPMethod: REQUEST_TYPE ];

    NSData* postData = [ NSData dataWithBytes: [ postString UTF8String ] length: [ postString length ] ];
    [request setHTTPBody: postData ];
    
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"aplication/json" forHTTPHeaderField:@"Content-Type"];
	
	NSData* returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];

    // returned data -> nsstring + alloc
    NSString* output = [[NSString alloc] initWithData: returnData encoding:NSUTF8StringEncoding];
	//NSLog(@"[SendServer] %@", output);
    
    if([delegate respondsToSelector:@selector(responseRecieved:)])
    {
        [delegate responseRecieved:output];
        //delegate=nil;
    }else
    {
       // NSLog(@"No AppData Response");
    }
}
@end


