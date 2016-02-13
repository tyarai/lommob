//
//  Publication.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Photo.h"

@interface Publication : JSONModel

@property (nonatomic, strong) NSString<Optional>* title;
@property (nonatomic, strong) NSString<Optional>* field_associated_species;
@property (nonatomic, strong) NSString<Optional>* body;
@property (nonatomic, strong) Photo<Optional>* field_photo;
@property (nonatomic, strong) NSString<Optional>* created;
@property (nonatomic, strong) NSString<Optional>* name;

@end

@protocol Publication
@end
