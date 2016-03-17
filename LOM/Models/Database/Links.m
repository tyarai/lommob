//
//  Links.m
//  LOM
//
//  Created by Ranto Andrianavonison on 17/03/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "Links.h"

@implementation Links
+ (NSArray*) getLinkByName:(NSString*) name {
    return [Links  instancesWhere:[NSString stringWithFormat:@" _linkname = '%@' ",name]];
    //return [Links  instancesWhere:@" _linkname = 'extinctlemurs' "];
    
   }

@end
