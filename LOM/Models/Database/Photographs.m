//
//  Photographs.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 25/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "Photographs.h"

@implementation Photographs

+ (id) getPhotographByNID:(NSInteger) _nid{
    NSString * queryArgument = [NSString new];
    queryArgument = [NSString stringWithFormat:@" _nid = '%lu' ", (long)_nid];
    return [Photographs firstInstanceWhere: queryArgument];
}

@end
