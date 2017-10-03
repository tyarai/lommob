// AppData.h
// LOM
// Created by Andrianavonison Ranto Tiaray on 02/01/2016.
// Copyright © 2016 Kerty KAMARY. All rights reserved.


#import <Foundation/Foundation.h>
#import "JSONHTTPClient.h"
#import "Sightings.h"
#import "LemurLifeListTable.h"


#ifdef DEBUG
    #define SERVER @"http://192.168.2.242"
    //#define SERVER @"http://172.20.10.4"
    //#define SERVER @"https://www.lemursofmadagascar.com/html"
#else
    #define SERVER @"https://www.lemursofmadagascar.com/html"
#endif


#define LOGIN_ENDPOINT       @"/lom_endpoint/api/v1/services/user/login.json"
#define LOGOUT_ENDPOINT      @"/lom_endpoint/api/v1/services/user/logout.json"
#define REGISTER_ENDPOINT    @"/lom_endpoint/api/v1/services/user/register.json"
#define FILE_ENDPOINT        @"/lom_endpoint/api/v1/services/file.json"
#define NODE_ENDPOINT        @"/lom_endpoint/api/v1/services/node.json"
#define NODE_UPDATE_ENDPOINT @"/lom_endpoint/api/v1/services/node/"

#define ISCONNECTED_ENDPOINT @"/lom_endpoint/api/v1/services/system/connect.json"

#define ALL_PUBLICATION_ENDPOINT @"/all-publication-json"
#define MY_SIGHTINGS_ENDPOINT @"/api/v1/list/sightings" // Misy parameters isLocal
#define ALL_MY_SIGHTINGS_ENDPOINT @"/api/v1/list/all-my-sightings" // Tsy misy parameter
#define MY_SIGHTINGS_MODIFIED_FROM @"/api/v1/list/my-sightings-modified-from" // Parameter  updated date >= date & isLocal = value

#define SERVICE_MY_SIGHTINGS @"/lom_endpoint/api/v1/services/lom_sighting_services/changed_sightings" //Parameters : 'uid' and 'from_date'

#define COUNT_SIGHTINGS @"/lom_endpoint/api/v1/services/lom_sighting_services/count_sightings" //Parameters : 'uid' (mandatory) and 'from_date' (optional)

#define LIFELIST_ENDPOINT @"/api/v1/list/my-lemur-life-list-json"
#define LIFELIST_ENDPOINT_MODIFIED_FROM @"api/v1/list/my-lemur-life-list-modified-from"
#define LAST_SYNC_DATE @"last_sync_date"
#define UPDATE_TEXT @"update_text"
#define UPDATE_SYNC_DATE @"update_sync_date"

#define SERVER_IMAGE_PATH @"/sites/default/files/"

//************ SETTINGS WEB SERVICE ******************//
#define SETTINGS_EXPORT_ENDPOINT @"/lom_endpoint/api/v1/settings/lom_settings/export_settings" // Misy param user_uid

#define SETTINGS_IMPORT_ENDPOINT @"/lom_endpoint/api/v1/settings/lom_settings/import_settings" // Misy param user_uid, settings_name, settings_value

// ************* CHANGED NODES SERVICE (Species, Map, Photograph, Family, Places) *******
#define CHANGED_NODES @ "/lom_endpoint/api/v1/services/lom_node_services/changed_nodes" // Misy parama from_date



typedef void (^postsViewControllerFunctionCallback) (void);


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


-(void) getSightingsForSessionId:(NSString*) session_id
                       from_date:(NSString*) from_date
                           start:(NSString*)start
                             count:(NSString*)count
                   andCompletion:(JSONObjectBlock)completeBlock;

-(void) getSightingsForSessionId:(NSString*) session_id
                       from_date:(NSString*) from_date
                   andCompletion:(JSONObjectBlock)completeBlock;



-(void) getChangedNodesForSessionId:(NSString*) session_id
                           fromDate:(NSString*) fromDate
                      andCompletion:(JSONObjectBlock)completeBlock;

-(void) getMyLemurLifeListForSessionId:(NSString*) session_id andCompletion:(JSONObjectBlock)completeBlock;

-(void) syncWithServer:(NSArray<Sightings *>*)sightings
           sessionName:(NSString*)sessionName
             sessionID:(NSString*) sessionID
              callback:(postsViewControllerFunctionCallback)func;

-(void)   updateSightingWithNID:(NSInteger)nid
                          Title:(NSString*)title
                      placeName:(NSString*) placeName
                           date:(NSInteger)date
                          count:(NSInteger)count
                    sessionName:(NSString*)sessionName
                     sessionId :(NSString*)sessionId
                  completeBlock:(JSONObjectBlock) completeBlock;


-(void) syncLifeListWithServer:(NSArray<LemurLifeListTable *>*)sightings sessionName:(NSString*)sessionName sessionID:(NSString*) sessionID ;

-(void) CheckSession:(NSString*)sessionName
           sessionID:(NSString*)sessionID
       completeBlock:(JSONObjectBlock)completeBlock;

-(void) getUserSettingsWithUserUID:(NSInteger) user_uid
                     completeBlock:(JSONObjectBlock) completeBlock;

-(void) setUserSettingsWithUserUID:(NSInteger) user_uid
                      settingsName:(NSString*) settings_name
                     settingsValue:(NSString*) settings_value
                     completeBlock:(JSONObjectBlock) completeBlock;

-(void) updateLocalDatabaseWith:(NSDictionary*)changedNodesJSONDictionary;

-(void) getSightingsCountForUID:(NSInteger)uid
                changedFromDate:(NSString*)from_date
                      sessionID:(NSString*)session_id
                  andCompletion:(JSONObjectBlock)completeBlock;




@end
