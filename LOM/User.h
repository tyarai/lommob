//
//  User.h
//  LemursOfMadagascar
//
//  Created by Andrianavonison Ranto Tiaray on 10/27/15.
//  Copyright © 2015 ConservationInternational. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface User : JSONModel

@property (nonatomic) NSInteger uid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* mail;
@property (nonatomic, strong) NSString* theme;
@property (nonatomic, strong) NSString* signature;
@property (nonatomic, strong) NSString* signature_format;
@property (nonatomic, strong) NSString* created;
@property (nonatomic, strong) NSString* access;
@property (nonatomic, strong) NSString* login;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* timezone;
@property (nonatomic, strong) NSString* language;
@property (nonatomic, strong) NSString* picture;
@property (nonatomic, strong) NSString* data;
@property (nonatomic, strong) NSString* uuid;

@end
