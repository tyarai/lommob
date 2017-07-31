//
//  Maps.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 25/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "Maps.h"

@implementation Maps


+ (id) getMapByNID:(NSInteger) _nid{
    NSString * queryArgument = [NSString new];
    queryArgument = [NSString stringWithFormat:@" _nid = '%lu' ", (long)_nid];
    return [Maps firstInstanceWhere: queryArgument];
}

- (void) updateMapsWith:(NSInteger)_nid
                  title:(NSString*)_title
               fileName:(NSString*)_filename{


 NSString * query = [NSString stringWithFormat:@"UPDATE $T SET _title = '%@' , _file_name = '%@'  WHERE _nid = '%li' ", _title,_filename,(long)_nid];
    
    [Maps executeUpdateQuery:query];
}

@end
