//
//  LemurLifeListNode.h
//  LOM
//
//  Created by Ranto Andrianavonison on 7/25/16.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "LemurLifeList.h"

@interface LemurLifeListNode : JSONModel

@property (nonatomic, strong) LemurLifeList * node;

@end

@protocol LemurLifeListNode
@end

