//
//  AppDelegate.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 16/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *_currentToken;
@property (strong, nonatomic) NSString *_sessionName;
@property (strong, nonatomic) NSString *_sessid;
@property (strong, nonatomic) User *_curentUser;


@end

