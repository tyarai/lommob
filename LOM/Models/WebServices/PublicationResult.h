//
//  PublicationResult.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PublicationNode.h"

@interface PublicationResult : JSONModel

@property  NSString<Optional>* current_page;
@property  NSString<Optional>* item_per_page;
@property  NSString<Optional>* total_records;
@property  NSString<Optional>* total_page;
@property  long                serverLastSyncDate;

@property (nonatomic, strong) NSArray<PublicationNode>* nodes;


@end
