//
//  Settings.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 20/05/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import <JSONModel/JSONModel.h>



/*
  Ny Settings any @ Drupal dia entity zany hoe any anaty table eck_user_settings_entity no mipetraka
  Fa aty @ iPhone atao userPreferenceString
 */
@interface Settings : JSONModel

@property (nonatomic, strong) NSString<Optional>* title;
@property (nonatomic)         int64_t uid;// User uid
@property (nonatomic, strong) NSString<Optional>* value;
@property (nonatomic)         int64_t id; // Setting's id
@property (nonatomic, strong) NSString<Optional>* created; //
@property (nonatomic, strong) NSString<Optional>* changed; //

@end
