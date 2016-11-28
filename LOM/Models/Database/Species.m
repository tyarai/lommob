//
//  Species.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 25/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "Species.h"

@implementation Species


- (Photographs*) getSpecieProfilePhotograph {
	return [Photographs firstInstanceWhere:[NSString stringWithFormat:@"_nid = %@", self._profile_photograph_id]];
}

- (Families*) getSpecieFamily {
	return [Families firstInstanceWhere:[NSString stringWithFormat:@"_nid = %@", self._family_id]];
}

- (Maps*) getSpecieMap {
	return [Maps firstInstanceWhere:[NSString stringWithFormat:@"_nid = %@", self._map]];
}

- (NSArray*) getSpeciePhotographs {
	
    NSMutableArray* species_photograph = [[NSMutableArray alloc] init];
    
    NSArray* photographs_ids = [self._specie_photograph componentsSeparatedByString:@","];
    
    if (photographs_ids.count > 0)
    {
        for (NSString* id_photo in photographs_ids) {
            
            NSString* id_photo_no_space = [id_photo stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            Photographs* photograph = [Photographs firstInstanceWhere:[NSString stringWithFormat:@"_nid = %@", id_photo_no_space]];
            
            [species_photograph addObject:photograph];
        }
    }
    
    return species_photograph;
    
}


+ (NSArray*) getSpeciesLike:(NSString*) strValue {
	return [Species instancesWhere:[NSString stringWithFormat:@"_title LIKE '%%%@%%' OR _english LIKE '%%%@%%' OR _other_english LIKE '%%%@%%' OR _french LIKE '%%%@%%' OR _german LIKE '%%%@%%' OR _malagasy LIKE '%%%@%%'", strValue, strValue, strValue, strValue, strValue, strValue]];
}

+ (NSArray*) getSpeciesByFamily:(NSString*) family_id {
	return [Species instancesWhere:[NSString stringWithFormat:@"_family_id = %@", family_id]];
}


+ (Species*) getSpeciesBySpeciesNID:(NSInteger) species_nid {
    if(species_nid != 0){
        return [Species firstInstanceWhere:[NSString stringWithFormat:@"_species_id = '%li' ", (long)species_nid]];
    }
    return nil;
}

+ (NSArray*) allSpeciesOrderedByTitle:(NSString*)direction{
    if([direction length] != 0){
        return [Species instancesOrderedBy:[NSString stringWithFormat:@" _title %@",direction]];
    }else{
        return [Species instancesOrderedBy:[NSString stringWithFormat:@" _title ASC"]];
    }
    return nil;
}



@end
