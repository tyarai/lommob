//
//  FamiliesViewController.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Families.h"

@interface FamiliesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSArray* _families;
    Families* _selectedFamily;
}

@end
