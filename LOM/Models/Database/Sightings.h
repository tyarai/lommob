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

@property (nonatomic) int64_t _id;
@property (nonatomic) int64_t _nid;
@property (nonatomic, strong) NSString* _uuid;
@property (nonatomic, strong) NSString* _speciesName;
@property (nonatomic) int64_t _speciesNid;
@property (nonatomic) NSInteger _speciesCount;
@property (nonatomic, strong) NSString* _placeName;
@property (nonatomic, strong) NSString* _placeLatitude;
@property (nonatomic, strong) NSString* _placeLongitude;
@property (nonatomic, strong) NSString* _photoFileNames;
@property (nonatomic, strong) NSString* _title;
@property (nonatomic) double _createdTime;
@property (nonatomic) double _modifiedTime;

+ (id) getSightingsByUUID:(NSString*) _uuid;
+ (NSArray*) getSightingsLike:(NSString*) strValue;
+ (NSArray*) getAllSightings;
+ (void) emptySightingsTable;

@end
