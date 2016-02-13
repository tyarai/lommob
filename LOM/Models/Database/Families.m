//
//  Families.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 25/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "Families.h"
#import "Illustrations.h"

@implementation Families


- (NSArray*) getIllustrations {
	
    NSMutableArray* families_illustrations = [[NSMutableArray alloc] init];
    
    NSArray* illustrations_ids = [self._illustration componentsSeparatedByString:@","];
    
    if (illustrations_ids.count > 0)
    {
        for (NSString* id_illustration in illustrations_ids) {
            
            NSString* iid_illustration_no_space = [id_illustration stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            Illustrations* illustration = [Illustrations firstInstanceWhere:[NSString stringWithFormat:@"_nid = %@", iid_illustration_no_space]];
            
            [families_illustrations addObject:illustration];
        }
    }
    
    return families_illustrations;
    
}
@end
