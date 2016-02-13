//
//  MainVC.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 25/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "AMSlideMenuMainViewController.h"


#define SPECIES_MENU_SEGUE @"firstSegue"
#define FAMILIES_MENU_SEGUE @"secondSegue"
#define WATCHINSITE_MENU_SEGUE @"thirdSegue"
#define WATCHINLIST_MENU_SEGUE @"fourthSegue"
#define POSTS_MENU_SEGUE @"fifthSegue"
#define ABOUT_MENU_SEGUE @"sixthSegue"


@interface MainVC : AMSlideMenuMainViewController {
    BOOL leftMenuIsOpen;
    BOOL isMoving;
}

+ (id)sharedMainVC;

@end
