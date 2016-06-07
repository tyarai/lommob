//
//  Node.h
//  LOM
//
//  Created by Madiapps-Kerty on 03/06/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Publication.h"

@interface Node : JSONModel

@property (nonatomic, strong) Publication* node;

@end

@protocol Node
@end