//
//  Families.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 25/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCModel.h"

@interface Families : FCModel

@property (nonatomic) int64_t _nid;
@property (nonatomic, strong) NSString* _family;
@property (nonatomic, strong) NSString* _family_description;
@property (nonatomic, strong) NSString* _illustration;

- (NSArray*) getIllustrations;
+ (id) getFamilyByNID:(NSInteger) _nid;

@end
