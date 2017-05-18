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
#define EXTINCT_LEMURS_MENU_SEGUE @"thirdSegue"
#define BIOS_MENU_SEGUE @"forthSegue"
#define SPECIES_MENU_SEGUE @"fifthSegue"
#define FAMILIES_MENU_SEGUE @"sixthSegue"
#define WATCHING_SITE_MENU_SEGUE @"seventhSegue"
#define WATCHING_LIST_MENU_SEGUE @"eigthSegue"
#define POSTS_MENU_SEGUE @"ninethSegue"
#define ABOUT_MENU_SEGUE @"tenthSegue"
#define SETTINGS_MENU_SEGUE @"eleventhSegue"



@interface MainVC : AMSlideMenuMainViewController {
    BOOL leftMenuIsOpen;
    BOOL isMoving;
}

+ (id)sharedMainVC;

@end
