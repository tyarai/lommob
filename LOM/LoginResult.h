//
//  LoginResult.h
//  LemursOfMadagascar
//
//  Created by Andrianavonison Ranto Tiaray on 10/27/15.
//  Copyright © 2015 ConservationInternational. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "JSONModel.h"

@interface LoginResult : JSONModel

@property (nonatomic, strong) NSString* sessid;
@property (nonatomic, strong) NSString* session_name;
@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) User* user;


@end
