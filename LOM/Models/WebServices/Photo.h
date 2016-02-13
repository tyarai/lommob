//
//  Photo.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Photo : JSONModel

@property (nonatomic, strong) NSString<Optional>* src;
@property (nonatomic, strong) NSString<Optional>* alt;

@end
