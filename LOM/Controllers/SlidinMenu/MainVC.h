//
//  MainVC.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 25/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "AMSlideMenuMainViewController.h"

#define INTRODUCTION_MENU_SEGUE @"firstSegue"
#define ORIGINOFLEMURS_MENU_SEGUE @"secondSegue"
#define BIOS_MENU_SEGUE @"thirdSegue"
#define SPECIES_MENU_SEGUE @"forthSegue"
#define FAMILIES_MENU_SEGUE @"fifthSegue"
#define WATCHINGSITE_MENU_SEGUE @"sixthhSegue"
#define WATCHINGLIST_MENU_SEGUE @"seventhSegue"
#define POSTS_MENU_SEGUE @"eigthSegue"
#define ABOUT_MENU_SEGUE @"ninethSegue"



@interface MainVC : AMSlideMenuMainViewController {
    BOOL leftMenuIsOpen;
    BOOL isMoving;
}

+ (id)sharedMainVC;

@end
