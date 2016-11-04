//
//  LemurLifeList.m
//  LOM
//
//  Created by Ranto Andrianavonison on 9/8/16.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "LemurLifeListTable.h"

@implementation LemurLifeListTable


+ (id) getLemurLifeListByUUID:(NSString*) _uuid {
    NSString * queryArgument = [NSString new];
    queryArgument = [NSString stringWithFormat:@" _uuid = '%@' ", _uuid];
    return [LemurLifeListTable firstInstanceWhere: queryArgument];
}


+ (id) getLemurLifeListBySpeciesID:(NSInteger) _speciesID  {
    NSString * queryArgument = [NSString new];
    queryArgument = [NSString stringWithFormat:@" _species_id = '%li' ", (long)_speciesID];
    return [LemurLifeListTable firstInstanceWhere: queryArgument];

}

+ (id) getLemurLifeListBySpeciesNID:(NSInteger) _nid {
    NSString * queryArgument = [NSString new];
    queryArgument = [NSString stringWithFormat:@" _nid = '%li' ", (long)_nid];
    return [LemurLifeListTable firstInstanceWhere: queryArgument];
    
}

+ (NSArray*) getNotSyncedLifeList{
    return [LemurLifeListTable instancesWhere:[NSString stringWithFormat:@" _isLocal = '1' AND _isSynced = '0'"]];
    
}


+ (NSArray*) getAllLemurLifeLists{
    //return [self allInstances];
    return [self instancesOrderedBy:@" _nid DESC"];
}

+(void) emptyLemurLifeListTable{
    [self executeUpdateQuery:@"DELETE FROM $T"];
}

+ (NSArray*) getLemurLifeListLike:(NSString*) strValue {
    return [LemurLifeListTable instancesWhere:[NSString stringWithFormat:@"_title LIKE '%%%@%%' OR _species LIKE '%%%@%%' OR _where_see_it LIKE '%%%@%%' ", strValue,strValue,strValue]];
}

/*
    Return ny lifeList n'ilay User _uid
 */
+ (NSArray*) getLemurLifeListsByUID:(NSInteger) _uid {
    if(_uid > 0){
        NSString * queryArgument = [NSString new];
        queryArgument = [NSString stringWithFormat:@" _uid = '%li' order by _id DESC ", (long)_uid];
        return [LemurLifeListTable instancesWhere: queryArgument];
    }
    return nil;
}


@end
