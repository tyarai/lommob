//
//  AppDelegate.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 16/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "AppDelegate.h"
#import "Tools.h"
#include "Constants.h"
#import "FCModel.h"
#import "RNCachingURLProtocol.h"
#import "AppData.h"
#import "Sightings.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Initialise database
    [Tools copyDatabaseIfNeeded:DATABASE_NAME];
    NSString* databasePath = [Tools getDatabasePath:DATABASE_NAME];
    [FCModel openDatabaseAtPath:databasePath withSchemaBuilder:^(FMDatabase *db, int *schemaVersion) {
        NSLog(@"openDatabaseAtPath %@", databasePath);
        
        
        void (^failedAt)(int statement) = ^(int statement){
            int lastErrorCode = db.lastErrorCode;
            NSString *lastErrorMessage = db.lastErrorMessage;
            [db rollback];
            NSAssert3(0, @"Migration statement %d failed, code %d: %@", statement, lastErrorCode, lastErrorMessage);
        };
        
        if (*schemaVersion < 1) {
            if (! [db executeUpdate:
                   @"CREATE TABLE Sightings ("
                   @"    _id           INTEGER PRIMARY KEY AUTOINCREMENT,"
                   @"    _nid          INTEGER NOT NULL,"
                   @"    _uuid         TEXT NOT NULL UNIQUE,"
                   @"    _speciesName  TEXT NOT NULL,"
                   @"    _speciesNid   INTEGER NOT NULL,"
                   @"    _speciesCount INTEGER,"
                   @"    _placeName    TEXT NOT NULL,"
                   @"    _placeLatitude TEXT,"
                   @"    _placeLongitude TEXT,"
                   @"    _photoFileNames TEXT NOT NULL,"
                   @"    _title        TEXT ,"
                   @"    _createdTime  REAL NOT NULL,"
                   @"    _modifiedTime REAL"
                   @");"
                   ]) failedAt(1);
            
            if (! [db executeUpdate:@"CREATE INDEX IF NOT EXISTS _speciesName ON Sightings (_speciesName);"]) failedAt(2);
            
            *schemaVersion = 1;
        }
        
        
        /*
         * Ampina ilay field _uid (uid drupal ito) 
         */
        if (*schemaVersion < 2) {
             if (! [db executeUpdate:@"ALTER TABLE Sightings ADD COLUMN _uid INTEGER NOT NULL DEFAULT '0'"]) failedAt(3);
             *schemaVersion = 2;
        }
        /*
         * Ampina ilay field _isLocal sy _isSynced ny table Sightings
         */
        if (*schemaVersion < 3) {
            if (! [db executeUpdate:@"ALTER TABLE Sightings ADD COLUMN _isLocal INTEGER NOT NULL DEFAULT 'NULL'"]) failedAt(4);
             if (! [db executeUpdate:@"ALTER TABLE Sightings ADD COLUMN _isSynced INTEGER DEFAULT '0'"]) failedAt(4);
            *schemaVersion = 3;
        }
        
        /*
         * Ampina ilay field _date (sighting date)
         */
        if (*schemaVersion < 4) {
            if (! [db executeUpdate:@"ALTER TABLE Sightings ADD COLUMN _date REAL NOT NULL DEFAULT '0'"]) failedAt(5);
            *schemaVersion = 4;
        }
        
        
        /*
         * Ampina ilay field _isLocal table LemurLifeListTable
         */
        if (*schemaVersion < 5) {
            if (! [db executeUpdate:@"ALTER TABLE LemurLifeListTable ADD COLUMN _isLocal INTEGER NOT NULL DEFAULT 'NULL'"]) failedAt(4);
            *schemaVersion = 5;
        }
        
        /*
         * Ampina ilay field _isLocal table LemurLifeListTable
         */
        if (*schemaVersion < 6) {
            if (! [db executeUpdate:@"ALTER TABLE LemurLifeListTable ADD COLUMN _uid INTEGER NOT NULL DEFAULT 'NULL'"]) failedAt(5);
            *schemaVersion = 6;
        }
        /*
         * Ampina ilay field _isSynced table LemurLifeListTable
         */
        if (*schemaVersion < 7) {
            if (! [db executeUpdate:@"ALTER TABLE LemurLifeListTable ADD COLUMN _isSynced INTEGER NOT NULL DEFAULT '0'"]) failedAt(6);
            *schemaVersion = 7;
        }
        
        /*
         * Ampina ilay field _deleted ny Sightings
         */
        if (*schemaVersion < 8) {
            if (! [db executeUpdate:@"ALTER TABLE Sightings ADD COLUMN _deleted INTEGER NOT NULL DEFAULT '0'"]) failedAt(7);
            *schemaVersion = 8;
        }
        
        /*
         * Ampina ilay field place_name_reference_nid ny Sightings
         */
        if (*schemaVersion < 9) {
            if (! [db executeUpdate:@"ALTER TABLE Sightings ADD COLUMN _place_name_reference_nid INTEGER NOT NULL DEFAULT '0'"]) failedAt(8);
            *schemaVersion = 9;
        }
        
        /*
         * Ampina ilay field place_name_reference_nid ny Sightings
         */
        if (*schemaVersion < 10) {
            if (! [db executeUpdate:@"ALTER TABLE Sightings ADD COLUMN _hasPhotoChanged INTEGER NOT NULL DEFAULT '0'"]) failedAt(9);
            *schemaVersion = 10;
        }
      
    }];
    
    //Initialise cache image
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    
    //Initialise application navigation bar
    [[UINavigationBar appearance] setOpaque:YES];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    
    
    self._currentToken  = [Tools getStringUserPreferenceWithKey:KEY_TOKEN];
    self._sessionName   = [Tools getStringUserPreferenceWithKey:KEY_SESSION_NAME];
    self._sessid        = [Tools getStringUserPreferenceWithKey:KEY_SESSID];
    self._uid           = [[Tools getStringUserPreferenceWithKey:KEY_UID] integerValue];
    self._userName      = [Tools getStringUserPreferenceWithKey:KEY_USERNAME];
    self._userMail      = [Tools getStringUserPreferenceWithKey:KEY_USERMAIL];
    
    
    
    self.isSyncing       = NO;
    self.serialSyncQueue = dispatch_queue_create("lom_sync_with_server", DISPATCH_QUEUE_SERIAL);
    
    [self.window setTintColor:ORANGE_COLOR]; // TintColor for the whole app
    
    
    [self syncSettings]; // mampidina ny settings  avy any @ server
    [self checkChangedNodesFromServer]; // mampidina data vaovao (species,family,map,photo,places)
    
    return YES;
}

/*
    mampidina ny avy any @ server
        1- Mampidina settings
 */
-(void) syncSettings{
    //--- Loading user settings --------//
    if(self._uid != 0){
        AppData * appData = [AppData getInstance];
        
        [appData getUserSettingsWithUserUID:self._uid completeBlock:^(id json, JSONModelError *err) {
            if(err == nil){
                
                NSDictionary* tmpDict = (NSDictionary*) json;
                for(id key in tmpDict){
                   
                    NSString *title = [key valueForKey:@"title"];
                    NSString * value = [key valueForKey:@"value"];
                    [Tools setUserPreferenceWithKey:title andStringValue:value];
                    
                }
      
            }else{
                NSLog(@"%@", [err description]);
            }
        }];
    }

}


-(void) checkChangedNodesFromServer{
    
    AppData * appData           = [AppData getInstance];
    AppDelegate * appDelegate   = [Tools getAppDelegate];
    
    NSString * lastSyncDate     = [NSString stringWithFormat:@"%@",[Tools getStringUserPreferenceWithKey:LAST_SYNC_DATE]];
    
    NSString *updateSyncDate    = [NSString stringWithFormat:@"%@",[Tools getStringUserPreferenceWithKey:UPDATE_SYNC_DATE]];

    updateSyncDate = [Tools isNullOrEmptyString:updateSyncDate] ? lastSyncDate : updateSyncDate;
    
    
    
    [appData getChangedNodesForSessionId:appDelegate._sessid
                                fromDate: updateSyncDate
                           andCompletion:^(id json, JSONModelError *err) {
               
           if (err) {
               [Tools showError:err onViewController:nil];
               NSLog(@"%@",err.description);
           }else{
               
               NSError *error = nil;
               NSString * updateText = @"";
               
               NSDictionary *changedNodesJSONDictionary = (NSDictionary*)json;
               
               if (error){
                   NSLog(@"Error parse : %@", error.debugDescription);
               }
               else{
                   
                   long newUpdateSyncDate = 0;
                   
                   if(changedNodesJSONDictionary != nil){
                       
                       NSArray * speciesDictionary = [changedNodesJSONDictionary valueForKey:@"species"];
                       NSArray * mapsDictionary    = [changedNodesJSONDictionary valueForKey:@"maps"];
                       NSArray * photoDictionary   = [changedNodesJSONDictionary valueForKey:@"photographs"];
                       NSArray * placesDictionary  = [changedNodesJSONDictionary valueForKey:@"best_places"];
                       NSArray * familyDictionary  = [changedNodesJSONDictionary valueForKey:@"families"];
                       
                       newUpdateSyncDate = [[changedNodesJSONDictionary valueForKey:@"serverLastSyncDate"] longValue];
                       
                       NSInteger species = [speciesDictionary count];
                       NSInteger map     = [mapsDictionary count];
                       NSInteger photo   = [photoDictionary count];
                       NSInteger place   = [placesDictionary count];
                       NSInteger family  = [familyDictionary count];
                       //NSInteger authors = [authorsDictionary count];
                       
                       [Tools setUserPreferenceWithKey:SPECIES_UPDATE_COUNT andStringValue:[NSString stringWithFormat:@"%li",species]];
                       
                       [Tools setUserPreferenceWithKey:MAP_UPDATE_COUNT andStringValue:[NSString stringWithFormat:@"%li",map]];
                       
                       [Tools setUserPreferenceWithKey:PHOTO_UPDATE_COUNT andStringValue:[NSString stringWithFormat:@"%li",photo]];
                       
                       [Tools setUserPreferenceWithKey:PLACE_UPDATE_COUNT andStringValue:[NSString stringWithFormat:@"%li",place]];
                       
                       [Tools setUserPreferenceWithKey:FAMILY_UPDATE_COUNT andStringValue:[NSString stringWithFormat:@"%li",family]];
                       
                       if(species != 0 || map != 0 || photo != 0 || place !=0 || family != 0 ){
                       
                           [appData updateLocalDatabaseWith:changedNodesJSONDictionary];
                           
                           //updateText = [NSString stringWithFormat:@"(%lu) species (%lu) families updates (%lu) maps (%lu) sites (%lu) photographs ",(long)species,family,map,place,photo];
                           updateText = [NSString stringWithFormat:@"See last update"];
                       }
                   }
                   
                   [Tools setUserPreferenceWithKey:UPDATE_TEXT andStringValue:updateText];
                   [Tools setUserPreferenceWithKey:UPDATE_SYNC_DATE andStringValue: [NSString stringWithFormat:@"%li", newUpdateSyncDate]];
               }
               
           }
               
   }];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //[Sightings unlockSightings:[self _uid]];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [Sightings unlockSightings:[self _uid]];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self syncSettings]; // mampidina ny settings avy any @ server
    [self checkChangedNodesFromServer]; // mampidina data vaovao (species,family,map,photo,places)
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [Sightings unlockSightings:[self _uid]];
}

@end
