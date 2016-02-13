//
//  Photographs.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 25/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "FCModel.h"

@interface Photographs : FCModel

@property (nonatomic) int64_t _nid;
@property (nonatomic, strong) NSString* _title;
@property (nonatomic, strong) NSString* _photograph;

@end
