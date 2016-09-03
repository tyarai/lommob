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
@property (nonatomic, strong) NSString<Optional>* name;
@property (nonatomic, strong) NSString<Optional>* mail;
@property (nonatomic, strong) NSString<Optional>* theme;
@property (nonatomic, strong) NSString<Optional>* signature;
@property (nonatomic, strong) NSString<Optional>* signature_format;
@property (nonatomic, strong) NSString<Optional>* created;
@property (nonatomic, strong) NSString<Optional>* access;
@property (nonatomic, strong) NSString<Optional>* login;
@property (nonatomic, strong) NSString<Optional>* status;
@property (nonatomic, strong) NSString<Optional>* timezone;
@property (nonatomic, strong) NSString<Optional>* language;
//@property (nonatomic, strong) NSString<Optional>* picture;
//@property (nonatomic, strong) NSString<Optional>* data;
@property (nonatomic, strong) NSString<Optional>* uuid;

@end
