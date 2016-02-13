//
//  MainVC.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 25/11/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "MainVC.h"
#import "Tools.h"

@interface MainVC ()

@end

static MainVC *sharedMainVC = nil;

@implementation MainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    sharedMainVC = self;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    // Do any additional setup after loading the view.
}

+ (id)sharedMainVC{
    @synchronized(self) {
        if(sharedMainVC == nil)
            sharedMainVC = [[MainVC alloc] init];
    }
    return sharedMainVC;
}



- (void)configureLeftMenuButton:(UIButton *)button{
    button.frame = CGRectMake(0, 0, 32, 32);
    [button setImage:[UIImage imageNamed:@"ico_menu"] forState:UIControlStateNormal];
}


- (CGFloat) leftMenuWidth{
    return (([Tools getScreenWidth] * 2) / 3) + 25;
}


- (BOOL)deepnessForLeftMenu{
    return NO;
}


- (NSIndexPath *)initialIndexPathForLeftMenu
{
    return [NSIndexPath indexPathForRow:1 inSection:0];
}



- (NSString*) segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath{
    NSString* identifier;
    
    switch (indexPath.row) {
        case 0:
            identifier = @"";
            break;
        case 1:
            identifier = SPECIES_MENU_SEGUE;
            break;
        case 2:
            identifier = FAMILIES_MENU_SEGUE;
            break;
        case 3 :
            identifier = WATCHINSITE_MENU_SEGUE;
            break;
        case 4 :
            identifier = WATCHINLIST_MENU_SEGUE;
            break;
        case 5:
            identifier = POSTS_MENU_SEGUE;
            break;
        case 6:
            identifier = ABOUT_MENU_SEGUE;
            break;
    }
    
    return identifier;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
