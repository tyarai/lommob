//
//  Comment.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 06/11/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import "FCModel.h"

@interface Comment : FCModel

@property (nonatomic) int64_t _id;      // liteSQL table id
@property (nonatomic) int64_t _cid;     // drupal cid
@property (nonatomic) int64_t _nid;     // nid of the commented node (Sighting)
@property (nonatomic) int64_t _pid;     // drupal parent comment cid
@property (nonatomic) int64_t _uid;     //drupal uid
@property (nonatomic) int _synced;
@property (nonatomic) int _new;
@property (nonatomic) int _local;
@property (nonatomic) int _locked;
@property (nonatomic) int _deleted;
@property (nonatomic) double _created;
@property (nonatomic) double _modified;
@property (nonatomic) int    _status;     // 1 = shown 0 = hidden
@property (nonatomic, strong) NSString* _uuid;
@property (nonatomic, strong) NSString* _sighting_uuid; // Raha sighting tsy mbola tafiakatra tsy nahazo nid dia ity aloha no apesaina
@property (nonatomic, strong) NSString* _name;
@property (nonatomic, strong) NSString* _mail;
@property (nonatomic, strong) NSString* _language;
@property (nonatomic, strong) NSString* _commentBody;

+ (id) getCommentByUUID:(NSString*) _uuid ;
+ (id) getCommentByCID:(NSInteger) _cid;
+ (id) getCommentsByNID:(NSInteger) _nid
                    new:(int) new;
+ (id) getCommentsByNID:(NSInteger) _nid;

+ (void) resetNewValue:(NSInteger) _nid;

+ (NSArray*) getNotSyncedComments:(NSInteger)nid;
+ (NSArray*) getNotSyncedCommentsBySightingUUID:(NSString*)uuid;
+ (id) getCommentsByUUID:(NSString*) _sighting_uuid;


@end




