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


@end
