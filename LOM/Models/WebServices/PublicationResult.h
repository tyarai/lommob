//
//  PublicationResult.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Node.h"

@interface PublicationResult : JSONModel

@property (nonatomic, strong) NSArray<Node>* nodes;

@end
