//
//  Menus.m
//  LOM
//
//  Created by Ranto Andrianavonison on 14/02/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "Menus.h"

@implementation Menus

+ (Menus*) getMenuContentByMenuName:(NSString*) name {
    return  [Menus firstInstanceWhere:@"_menu_name = ?", name];
   // return [Menus instanceWithPrimaryKey:@1];    //return nil;
    //NSArray *args = @[@"introduction"];
   //Menus*menu =[Menus instanceWithPrimaryKey:@1];    //return nil;
    //firstInstanceWhere:@"name = ? ORDER BY id LIMIT 1", @"Bob"];
   //NSArray * menus =  [Menus  allInstances];
   // return nil;
}


@end
