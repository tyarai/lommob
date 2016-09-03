//
//  LemurLifeListResult.h
//  LOM
//
//  Created by Ranto Andrianavonison on 7/25/16.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "LemurLifeListNode.h"

@interface LemurLifeListResult : JSONModel
@property  NSString<Optional>* current_page;
@property  NSString<Optional>* item_per_page;
@property  NSString<Optional>* total_records;
@property  NSString<Optional>* total_page;

@property (nonatomic, strong) NSArray<LemurLifeListNode> * nodes;
//@property (nonatomic, strong) NSDictionary<id,NSArray<LemurLifeListNode>*> * rows;
@end
