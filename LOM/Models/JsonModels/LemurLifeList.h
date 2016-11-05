//
//  LemurLifeList.h
//  LOM
//
//  Created by Ranto Andrianavonison on 7/25/16.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Photo.h"

@interface LemurLifeList : JSONModel

@property (nonatomic, strong) NSString<Optional>* title;
@property (nonatomic, strong) NSString<Optional>* species;
@property (nonatomic, strong) NSString<Optional>* body;
@property (nonatomic, strong) NSString<Optional>* where_see;
@property (nonatomic, strong) NSString<Optional>* see_first_time;
//@property (nonatomic, strong) NSString<Optional>* see_first_time;
@property (nonatomic, strong) Photo<Optional>* lemur_photo;
@property (nonatomic, strong) NSString<Optional>* created;
@property (nonatomic, strong) NSString<Optional>* name;
@property (nonatomic) int64_t nid;
@property (nonatomic,strong) NSString<Optional>* uuid;
@property (nonatomic) int64_t species_nid;
@property (nonatomic) int64_t uid;
@property (nonatomic) int64_t isLocal;


-(NSString*) getLemurLifeListImageFullPathName;


@end
