//
//  SpeciesSelectorViewController.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 30/11/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "SpeciesSelectorViewController.h"
#import "SpeciesSelectorTableViewCell.h"
#import "Tools.h"
#import "Constants.h"


@interface SpeciesSelectorViewController ()

@end

@implementation SpeciesSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view.tintColor = ORANGE_COLOR;
    self.toolBar.backgroundColor = [UIColor blackColor];
    self.selectedSpecies = nil;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 125;
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.species count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    lastIndexPath = indexPath;
    self.selectedSpecies = [self.species objectAtIndex:indexPath.row];
    [tableView reloadData];
}





-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SpeciesSelectorTableViewCell * cell = (SpeciesSelectorTableViewCell*) [Tools getCell:tableView identifier:@"speciesSelectorCell"];
    
    
    Species * currentSpecies  = (Species*) [self.species objectAtIndex:indexPath.row];
    
    [cell displaySpecies:currentSpecies];
    
    if ([indexPath compare:lastIndexPath] == NSOrderedSame)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneTapped:(id)sender {
    [self.delegate doneSpeciesSelector:self.selectedSpecies];
}

- (IBAction)cancelTapped:(id)sender {
    [self.delegate cancelSpeciesSelector];
}
@end
