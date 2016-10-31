//
//  Sightings.m
//  LOM
//
//  Created by Ranto Andrianavonison on 9/20/16.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "Sightings.h"

@implementation Sightings

+ (id) getSightingsByUUID:(NSString*) _uuid {
    NSString * queryArgument = [NSString new];
    queryArgument = [NSString stringWithFormat:@" _uuid = '%@' ", _uuid];
    return [Sightings firstInstanceWhere: queryArgument];
}

+ (id) getSightingsByNID:(NSInteger) _nid{
    NSString * queryArgument = [NSString new];
    queryArgument = [NSString stringWithFormat:@" _nid = '%lu' ", (long)_nid];
    return [Sightings firstInstanceWhere: queryArgument];
}

+ (id) getSightingsBySpeciesID:(NSInteger) _speciesID{
    NSString * queryArgument = [NSString new];
    queryArgument = [NSString stringWithFormat:@" _speciesNid = '%lu' ", (long)_speciesID];
    return [Sightings instancesWhere:queryArgument];
}

+ (NSArray*) getAllSightings{
    return [self instancesOrderedBy:@" _id DESC"];
}

+ (NSArray*) getNotSyncedSightings{
    return [Sightings instancesWhere:[NSString stringWithFormat:@" _isLocal = '1' AND _isSynced ='0'"]];

}


+ (NSArray*) getSightingsLike:(NSString*) strValue withUID:(NSInteger) uid {
    return [Sightings instancesWhere:[NSString stringWithFormat:@" ( _title LIKE '%%%@%%' OR _speciesName LIKE '%%%@%%' OR _placeName LIKE '%%%@%%') ", strValue,strValue,strValue]];
}

+ (void) emptySightingsTable{
    [self executeUpdateQuery:@"DELETE FROM $T"];
}



@end
