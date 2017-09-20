//
//  Sightings.m
//  LOM
//
//  Created by Ranto Andrianavonison on 9/20/16.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "Sightings.h"
#import "Tools.h"

@implementation Sightings

+ (id) getSightingsByUUID:(NSString*) _uuid {
    NSString * queryArgument = [NSString new];
    queryArgument = [NSString stringWithFormat:@" _uuid = '%@' AND _deleted = '0' ", _uuid];
    return [Sightings firstInstanceWhere: queryArgument];
}

+ (id) getSightingsByNID:(NSInteger) _nid{
    NSString * queryArgument = [NSString new];
    queryArgument = [NSString stringWithFormat:@" _nid = '%lu' AND _deleted = '0'  ", (long)_nid];
    return [Sightings firstInstanceWhere: queryArgument];
}

+ (id) getSightingsBySpeciesID:(NSInteger) _speciesID{
    NSString * queryArgument = [NSString new];
    queryArgument = [NSString stringWithFormat:@" _speciesNid = '%lu' AND _deleted = '0' ", (long)_speciesID];
    return [Sightings instancesWhere:queryArgument];
}

+ (NSArray*) getAllSightings{
    return [self instancesOrderedBy:@" _id DESC AND _deleted = '0'"];
}

+ (NSArray*) getNotSyncedSightings{
    //return [Sightings instancesWhere:[NSString stringWithFormat:@" _isLocal = '1' AND _isSynced ='0'"]];
    return [Sightings instancesWhere:[NSString stringWithFormat:@" _isSynced ='0' OR _deleted ='1' "]];

}


+ (NSArray*) getSightingsLike:(NSString*) strValue withUID:(NSInteger) uid {
    return [Sightings instancesWhere:[NSString stringWithFormat:@" ( _title LIKE '%%%@%%' OR _speciesName LIKE '%%%@%%' OR _placeName LIKE '%%%@%%' ) AND _uid = '%li' AND _deleted = '0' ", strValue,strValue,strValue,uid]]; // <<<---- Mbola ampina AND _deleted = '0' ny condition ato
}


+ (void) emptySightingsTable{
    [self executeUpdateQuery:@"DELETE FROM $T"];
}


+ (NSInteger) observationSumBySpeciesNID:(NSInteger) speciesNID{
    if(speciesNID > 0){
        
        NSString * query = [NSString stringWithFormat:@" SELECT SUM(_speciesCount) total FROM $T WHERE _speciesNid = '%li' ",
                            speciesNID];
        
        NSArray * results = [Sightings resultDictionariesFromQuery:query];
        NSDictionary* dic = [results objectAtIndex:0]; // iray ihany ny zavatra retourner-na
        
        id object = [dic valueForKey:@"total"];
        @try{
            NSInteger value = [object integerValue];
            return  value;
        }
        @catch(NSException * e){
            return 0;
        }
        
    }
    return 0;
}


+ (NSArray*) getLemurLifeLists:(NSInteger)_uid search:(NSString*)like{
    if(_uid >0 && [Tools isNullOrEmptyString:like]){
        NSString * query = [NSString stringWithFormat:@" SELECT _speciesNid,_speciesName,totalObserved,totalSightings FROM(    SELECT _speciesNid,_speciesName,SUM(_speciesCount) totalObserved,count(_speciesNid) totalSightings FROM $T WHERE _uid = '%li' AND _deleted ='0' GROUP BY _speciesNid ORDER BY _speciesName ASC)aa ",(long)_uid];
        
        NSArray * results = [Sightings resultDictionariesFromQuery:query];
        
        return results;
    }
    
    if(_uid >0 && ![Tools isNullOrEmptyString:like]){
        NSString * query = [NSString stringWithFormat:@" SELECT _speciesNid,_speciesName,totalObserved,totalSightings FROM(    SELECT _speciesNid,_speciesName,SUM(_speciesCount) totalObserved,count(_speciesNid) totalSightings FROM $T WHERE _uid = '%li' AND ( _speciesName LIKE '%%%@%%' OR _placeName LIKE '%%%@%%' ) AND  _deleted ='0' GROUP BY _speciesNid ORDER BY _speciesName ASC)aa ",(long)_uid,like,like];
        
        NSArray * results = [Sightings resultDictionariesFromQuery:query];
        
        return results;
    }
    
    
    
    return nil;
}






+ (NSArray*) getSightingsByUID:(NSInteger) uid{
    if(uid > 0){
        NSString *queryArgument = [NSString stringWithFormat:@"  _uid = '%lu' AND _deleted = '0' order by _modifiedTime DESC ", (long)uid];
        return [Sightings instancesWhere:queryArgument];
    }
    return nil;
}






@end
