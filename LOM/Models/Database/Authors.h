//
//  Authors.h
//  LOM
//
//  Created by Ranto Andrianavonison on 15/03/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "FCModel.h"

@interface Authors : FCModel
@property (nonatomic) int64_t _id;
@property (nonatomic, strong) NSString* _name;
@property (nonatomic, strong) NSString* _details;
@property (nonatomic, strong) NSString* _photo  ;


@end
