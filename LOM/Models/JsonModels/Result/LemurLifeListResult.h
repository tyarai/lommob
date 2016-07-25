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
@property (nonatomic, strong) NSArray<LemurLifeListNode> * nodes;
@end
