//
//  AppDelegate.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 16/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Species.h"
#import "Publication.h"
#import "Sightings.h"
#import "LemursWatchingSites.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property  BOOL isSyncing;
@property  dispatch_queue_t serialSyncQueue;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *_currentToken;
@property (strong, nonatomic) NSString *_sessionName;
@property (strong, nonatomic) NSString *_sessid;
@property                     NSInteger _uid;
@property (strong, nonatomic) NSString *_userName;
@property (strong, nonatomic) NSString *_userMail;
@property (strong, nonatomic) NSString *_sightingNewTitle;
@property (strong, nonatomic) NSDate *_sightingNewDate;
@property  int _sightingNumber;


@property (strong, nonatomic) User *_curentUser;
@property BOOL showActivity;

@property (strong,nonatomic) Species * currentSpecies;


@property (strong,nonatomic) Species     * appDelegateCurrentSpecies;
@property (strong,nonatomic) Publication * appDelegateCurrentPublication;
@property (strong,nonatomic) Sightings   * appDelegateCurrentSighting;
@property (strong,nonatomic) LemursWatchingSites * appDelegateCurrentSite;
@property (strong,nonatomic) LemursWatchingSites * appDelegateTemporarySite;

-(void) syncSettings;
@end

