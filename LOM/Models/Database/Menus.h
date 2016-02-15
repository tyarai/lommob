//
//  Menus.h
//  LOM
//
//  Created by Ranto Andrianavonison on 14/02/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "FCModel.h"

@interface Menus : FCModel
@property (nonatomic) int64_t _nid;
@property (nonatomic, strong) NSString* _menu_name;
@property (nonatomic, strong) NSString* _menu_content;


+ (Menus*) getMenuContentByMenuName:(NSString*) name;
@end
