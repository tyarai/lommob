//
//  Species.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 25/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "FCModel.h"
#import "Photographs.h"
#import "Families.h"
#import "Maps.h"

@interface Species : FCModel

@property (nonatomic) int64_t _species_id;
@property (nonatomic, strong) NSString* _profile_photograph_id;
@property (nonatomic, strong) NSString* _family_id;
@property (nonatomic, strong) NSString* _title;
@property (nonatomic, strong) NSString* _english;
@property (nonatomic, strong) NSString* _other_english;
@property (nonatomic, strong) NSString* _french;
@property (nonatomic, strong) NSString* _german;
@property (nonatomic, strong) NSString* _malagasy;
@property (nonatomic, strong) NSString* _identification;
@property (nonatomic, strong) NSString* _natural_history;
@property (nonatomic, strong) NSString* _geographic_range;
@property (nonatomic, strong) NSString* _conservation_status;
@property (nonatomic, strong) NSString* _where_to_see_it;
@property (nonatomic, strong) NSString* _map;
@property (nonatomic, strong) NSString* _specie_photograph;
@property (nonatomic, strong) NSString* _favorite;

- (Photographs*) getSpecieProfilePhotograph;
- (Families*) getSpecieFamily;
- (Maps*) getSpecieMap;

- (NSArray*) getSpeciePhotographs;

+ (NSArray*) getSpeciesLike:(NSString*) strValue;

+ (NSArray*) getSpeciesByFamily:(NSString*) family_id;

+ (Species*) getSpeciesBySpeciesNID:(NSInteger) species_nid;

@end
