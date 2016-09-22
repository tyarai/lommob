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
@property (nonatomic, strong) NSString<Optional>* created;
@property (nonatomic, strong) NSString<Optional>* author_name;
@property (nonatomic)         int64_t speciesNid;
@property (nonatomic, strong) NSString<Optional>* uuid;
@property (nonatomic, strong) NSString<Optional>* place_name;
@property (nonatomic, strong) NSString<Optional>* latitude;
@property (nonatomic, strong) NSString<Optional>* longitude;
@property (nonatomic) NSInteger count; // Species count


@end

@protocol Publication
@end
