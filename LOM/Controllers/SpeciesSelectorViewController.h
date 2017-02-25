//
//  SpeciesSelectorViewController.h
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 30/11/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "BaseViewController.h"
#import "Species.h"
#import "SpeciesSelectorTableViewCell.h"
#import "Publication.h"

@protocol SpeciesSelectorDelegate <NSObject>

-(void) cancelSpeciesSelector;
-(void) doneSpeciesSelector:(Species*) selectedSpecies;

@end

@interface SpeciesSelectorViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>{
    NSIndexPath * lastIndexPath;
}
@property (strong,nonatomic) id<SpeciesSelectorDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray<Species*> *species;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
//@property (strong,nonatomic) Species * selectedSpecies;
//@property (strong,nonatomic) Publication * publication;

- (IBAction)doneTapped:(id)sender;

- (IBAction)cancelTapped:(id)sender;

@end
