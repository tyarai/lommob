//
//  LemursWatchingSites.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 25/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "FCModel.h"

@interface LemursWatchingSites : FCModel

@property (nonatomic) int64_t _site_id;
@property (nonatomic, strong) NSString* _title;
@property (nonatomic, strong) NSString* _body;

+ (NSArray*) getLemursWatchingSitesLike:(NSString*) strValue;
+ (NSArray*) allSitesOrderedByTitle:(NSString*)direction;
+ (NSArray*) getSitesLike:(NSString*) strValue ;
+ (LemursWatchingSites*) getLemursWatchingSitesByNID:(NSInteger) nid;
@end
