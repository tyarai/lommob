//
//  SpeciesSelectorViewController.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 30/11/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "SpeciesSelectorViewController.h"
#import "SpeciesSelectorTableViewCell.h"
#import "SightingDataTableViewController.h"
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
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 125;
      
    //UIView* backgroundView = [self.bottomToolBar view
    //[backgroundView setBackgroundColor:[UIColor blackColor]];
    self.bottomToolBar.tintColor = ORANGE_COLOR;
    self.bottomToolBar.backgroundColor = [UIColor blackColor];
    
    self.txtSearch.delegate = self;
    self.myNavigationItem.title = NSLocalizedString(@"choose_species",@"");
}

-(void) viewWillAppear{
    //[super viewWillAppear];
    [self.bottomToolBar setBackgroundColor:[UIColor blackColor]];
    isSearchShown = NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        //return@"Species list";
    }
    return nil;
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
    /*  
        Ni-selectionner species hafa ilay user teto fa tsy voatery hoe ito ny final satria
        mety ho nanao CANCEL izy avy eo. Any @ DONE mihitsy izay vao ovana ny appDelegateCurrentSpecies
    
     */
    lastIndexPath = indexPath;
    
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

    AppDelegate * appDelagate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelagate.appDelegateCurrentSpecies       = [self.species objectAtIndex:lastIndexPath.row];
    
    [self.delegate doneSpeciesSelector:appDelagate.appDelegateCurrentSpecies];
}

- (IBAction)cancelTapped:(id)sender {
    //SightingDataTableViewController * delegate = (SightingDataTableViewController*)self.delegate;
    //delegate.publication = self.publication;
    [self.delegate cancelSpeciesSelector];
}
- (IBAction)searchButtonTapped:(id)sender {
    if (isSearchShown)
    {
        [self hideSearch];
    }else
    {
        [self showSearch];
    }

}

- (void) showSearch{
    
    self.constraintTopSpaceSearch.constant = 40;
    
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [self.viewSearch setNeedsUpdateConstraints];
                         [self.viewSearch layoutIfNeeded];
                         
                         [self.tableView setNeedsUpdateConstraints];
                         [self.tableView layoutIfNeeded];
                         
                         //[self.searchButton setImage:[UIImage imageNamed:@"ico_find_on"] forState:UIControlStateNormal];
                         [self.view layoutIfNeeded];
                         
                         isSearchShown = YES;
                         
                         [self.txtSearch becomeFirstResponder];
                     }];
    
}


- (void) hideSearch{
    
    self.constraintTopSpaceSearch.constant = 0;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [self.viewSearch setNeedsUpdateConstraints];
                         [self.viewSearch layoutIfNeeded];
                         
                         [self.tableView setNeedsUpdateConstraints];
                         [self.tableView layoutIfNeeded];
                         
                         //[self.searchButton setImage:[UIImage imageNamed:@"ico_find_off"] forState:UIControlStateNormal];
                         
                         isSearchShown = NO;
                         [self.view layoutIfNeeded];
                         
                         [self.txtSearch resignFirstResponder];
                         
                         [self.view endEditing:YES];
                     }];
    
}


#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * searchStr = [self.txtSearch.text stringByReplacingCharactersInRange:range withString:string];
    
    [self performSearch:searchStr];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    [self performSearch:nil];
    
    [self.txtSearch resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString* strSearch = self.txtSearch.text;
    
    [self performSearch:strSearch];
    
    [self hideSearch];
    
    return YES;
}

- (void) performSearch:(NSString*) searchStr{
    
    if ([Tools isNullOrEmptyString:searchStr]) {
        _species = [Species allInstances];
        
        [self.tableView reloadData];
        
    }else{
        _species= [Species getSpeciesLike:searchStr];
        
        [self.tableView reloadData];
    }
}





@end
