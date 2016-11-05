//
//  Sightings.h
//  LOM
//
//  Created by Ranto Andrianavonison on 9/20/16.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "FCModel.h"

/**
  Maps Publiction from web server to Sightings
 */
 

@interface Sightings : FCModel

@property (nonatomic) int64_t _id;      // liteSGL table id
@property (nonatomic) int64_t _nid;     // drupal nid
@property (nonatomic, strong) NSString* _uuid;
@property (nonatomic, strong) NSString* _speciesName;
@property (nonatomic) int64_t _speciesNid; //drupal Species nid
@property (nonatomic) int64_t _uid; //drupal uid
@property (nonatomic) NSInteger _speciesCount;
@property (nonatomic, strong) NSString* _placeName;
@property (nonatomic, strong) NSString* _placeLatitude;
@property (nonatomic, strong) NSString* _placeLongitude;
@property (nonatomic, strong) NSString* _photoFileNames;
@property (nonatomic, strong) NSString* _title;
@property (nonatomic) double _createdTime;
@property (nonatomic) double _modifiedTime;
@property (nonatomic) double _date;
@property (nonatomic) int64_t _isLocal;
@property (nonatomic) int64_t _isSynced;

+ (id) getSightingsByUUID:(NSString*) _uuid;
+ (id) getSightingsByNID:(NSInteger) _nid;
+ (id) getSightingsBySpeciesID:(NSInteger) _speciesID;
+ (NSArray*) getLemurLifeLists:(NSInteger)_uid search:(NSString*)like;

+ (NSArray*) getSightingsLike:(NSString*) strValue withUID:(NSInteger) uid;
+ (NSArray*) getAllSightings;
+ (NSArray*) getNotSyncedSightings;
+ (void) emptySightingsTable;
+ (long) observationSumBySpeciesNID:(NSInteger) speciesNID;
+ (NSArray*) getSightingsByUID:(NSInteger) uid;

@end
