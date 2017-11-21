//
//  Comment.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 06/11/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import "Comment.h"
#import "Tools.h"

@implementation Comment

+ (id) getCommentByUUID:(NSString*) _uuid {
    NSString * queryArgument = [NSString new];
    queryArgument = [NSString stringWithFormat:@" _uuid = '%@' AND _status = '1' ", _uuid];
    return [Comment firstInstanceWhere: queryArgument];
}

+ (id) getCommentByCID:(NSInteger) _cid{
    NSString * queryArgument = [NSString new];
    queryArgument = [NSString stringWithFormat:@" _cid = '%lu' AND _status = '1'  ", (long)_cid];
    return [Comment firstInstanceWhere: queryArgument];
}

+ (id) getCommentsByNID:(NSInteger) _nid
                    new:(int) new{
    
    NSString * queryArgument = [NSString new];
    queryArgument = [NSString stringWithFormat:@" _nid = '%lu' AND _status = '1' AND _new = '%i' ", (long)_nid,new];
    return [Comment instancesWhere: queryArgument];
}

+ (id) getCommentsByNID:(NSInteger) _nid{
    if(_nid != 0){
        
        NSString * queryArgument = [NSString new];
        queryArgument = [NSString stringWithFormat:@" _nid = '%lu' AND _status = '1' ORDER BY _cid ASC", (long)_nid];
        return [Comment instancesWhere: queryArgument];
    }
    return nil;
}


+ (id) getCommentsByUUID:(NSString*) _sighting_uuid{
    if(![Tools isNullOrEmptyString:_sighting_uuid]){
        NSString * queryArgument = [NSString new];
        queryArgument = [NSString stringWithFormat:@" _sighting_uuid = '%@' AND _status = '1' ORDER BY _cid ASC", _sighting_uuid];
        return [Comment instancesWhere: queryArgument];
    }
    return nil;
}


/*
  Averina new=0 daholo ny sighting rehefa avy jerena indray mandeha
 */
+ (void) resetNewValue:(NSInteger) _nid{
    if(_nid){
        NSString *query = [NSString stringWithFormat:@" UPDATE $T SET _new = '0' WHERE _nid = '%li' ",(long)_nid];
        [self executeUpdateQuery:query];
    }
}
/*
    Alaina izay comment tsy mbola synced an'ilay user
 */
+ (NSArray*) getNotSyncedComments:(NSInteger)uid{
    if(uid > 0){
        return [Comment instancesWhere:[NSString stringWithFormat:@" (_synced ='0' OR _deleted ='1' ) AND _locked = '0' AND _uid  =  '%lu' ",(long)uid]];
    }
    return nil;
}

/*
 Alaina izay comment tsy mbola synced ho an'ity sighting ity an'ilay user
 */
+ (NSArray*) getNotSyncedCommentsBySightingUUID:(NSString*)uuid{
    
    if(! [Tools isNullOrEmptyString:uuid]){
        
        return [Comment instancesWhere:[NSString stringWithFormat:@" (_synced ='0' OR _deleted ='1' ) AND _locked = '0' AND _sighting_uuid  =  '%@' ",uuid]];
    }
    return nil;
}



@end
