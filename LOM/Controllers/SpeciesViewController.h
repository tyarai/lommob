//
//  SpeciesViewController.h
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species.h"


@interface SpeciesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>{
    BOOL isSearchShown;
    
    Species* _selectedSpecy;
    
}

@property (nonatomic, strong) NSArray* _speciesArray;

@end
