//
//  UserConnected.h
//  LOM
//
//  Created by Ranto Andrianavonison on 9/3/16.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "User.h"

@interface UserConnectedResult : JSONModel
@property (nonatomic, strong) NSString* sessid;
@property (nonatomic, strong) NSString* session_name;
@property (nonatomic, strong) User* user;

@end
