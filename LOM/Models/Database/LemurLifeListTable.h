//
//  LemurLifeList.h
//  LOM
//
//  Created by Ranto Andrianavonison on 9/8/16.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "FCModel.h"

@interface LemurLifeListTable : FCModel

@property (nonatomic) int64_t _id;
@property (nonatomic) int64_t _nid;
@property (nonatomic) int64_t _isLocal;
@property (nonatomic, strong) NSString* _uuid;
@property (nonatomic) int64_t _species_id;
@property (nonatomic, strong) NSString* _title;
@property (nonatomic, strong) NSString* _species;
@property (nonatomic, strong) NSString* _where_see_it;
@property (nonatomic) int64_t _when_see_it;
@property (nonatomic, strong) NSString* _photo_name;

+ (id) getLemurLifeListByUUID:(NSString*) _uuid ;
+ (id) getLemurLifeListBySpeciesID:(NSInteger) _speciesID ;

+ (NSArray*) getLemurLifeListLike:(NSString*) strValue ;
+ (NSArray*) getAllLemurLifeLists;
+(void) emptyLemurLifeListTable;

@end
