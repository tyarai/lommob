//
//  FileResult.h
//  LOM
//
//  Created by Ranto Andrianavonison on 13/10/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FileResult : JSONModel
@property  NSInteger fid;
@property (nonatomic, strong) NSString* uri;


@end
