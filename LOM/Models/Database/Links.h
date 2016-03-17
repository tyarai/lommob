//
//  Links.h
//  LOM
//
//  Created by Ranto Andrianavonison on 17/03/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "FCModel.h"

@interface Links : FCModel
@property (nonatomic) int64_t _id;
@property (nonatomic, strong) NSString* _linkname;
@property (nonatomic, strong) NSString* _linkurl;
@property (nonatomic, strong) NSString* _linktitle;
+ (NSArray*) getLinkByName:(NSString*) name ;
@end
