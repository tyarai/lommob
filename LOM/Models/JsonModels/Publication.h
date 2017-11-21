//
//  Publication.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Photo.h"

/**
    Publication = SightingNode
*/

@interface Publication : JSONModel


@property (nonatomic, strong) NSString<Optional>* title;
@property (nonatomic, strong) NSString<Optional>* species; //speciesName
@property (nonatomic)         int64_t uid;// User uid
@property (nonatomic, strong) NSString<Optional>* body;
@property (nonatomic)         int64_t nid; // Post's _nid
@property (nonatomic, strong) Photo<Optional>* field_photo;
@property (nonatomic, strong) NSString<Optional>* date; // sighting date
@property (nonatomic, strong) NSString<Optional>* created; // sighting creation date
@property (nonatomic, strong) NSString<Optional>* modified; // sighting last modified date
@property (nonatomic, strong) NSString<Optional>* author_name;
@property (nonatomic)         int64_t speciesNid;
@property (nonatomic, strong) NSString<Optional>* uuid;
@property (nonatomic, strong) NSString<Optional>* place_name;
@property (nonatomic) float  latitude;
@property (nonatomic) float longitude;
@property (nonatomic) float altitude;
@property (nonatomic) NSInteger count; // Species count
@property (nonatomic) int64_t isLocal;
@property (nonatomic) int64_t isSynced;
@property (nonatomic) int64_t deleted;
@property (nonatomic) int64_t place_name_reference_nid;
@property (nonatomic,strong) NSArray * comments;


-(NSString*) getSightingImageFullPathName;;
-(void) updateDeletedByNID:(NSInteger) value nid:(NSInteger)nid ;
-(void) updateDeletedByUUID:(NSInteger) value nid:(NSString*)uuid ;

@end

@protocol Publication
@end
