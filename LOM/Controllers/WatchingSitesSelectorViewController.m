//
//  WatchingSitesSelectorViewController.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 16/05/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import "WatchingSitesSelectorViewController.h"
#import "WatchingSitesSelectorTableViewCell.h"
#import "Tools.h"
#import "LemursWatchingSites.h"
#import "Constants.h"
#import "WatchingSiteMap.h"
@interface WatchingSitesSelectorViewController ()

@end

@implementation WatchingSitesSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view.tintColor = ORANGE_COLOR;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 125;
    
    self.bottomToolBar.tintColor = ORANGE_COLOR;
    self.bottomToolBar.backgroundColor = [UIColor blackColor];
    
    
    self.txtSearch.delegate = self;
    self.myNavigationItem.title = NSLocalizedString(@"choose_site",@"");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WatchingSitesSelectorTableViewCell * cell = (WatchingSitesSelectorTableViewCell*) [Tools getCell:tableView identifier:@"siteSelectorCell"];
    
    
    LemursWatchingSites * currentSite  = (LemursWatchingSites*) [self.sites objectAtIndex:indexPath.row];
    
    [cell displaySite:currentSite];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     Ni-selectionner site hafa ilay user teto fa tsy voatery hoe ito ny final satria
     mety ho nanao CANCEL izy avy eo. Any @ DONE mihitsy izay vao ovana ny appDelegateCurrentSite
     
     */
    lastIndexPath = indexPath;
    appDelegate.appDelegateTemporarySite = self.sites[indexPath.row];
    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //WatchingSiteMap * siteMap = (WatchingSiteMap*)[storyboard instantiateViewControllerWithIdentifier:@"siteMapVC"];
    
    //if(siteMap){
      //  siteMap.delegate = self;
        
    //}
    [self performSegueWithIdentifier:@"showSiteMap" sender:self];
    
    [tableView reloadData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sites count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - ToolBar

- (IBAction)canceltapped:(id)sender {
    [self.delegate cancelSiteSelector];
}

- (IBAction)doneTapped:(id)sender {
    AppDelegate * appDelagate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelagate.appDelegateCurrentSite       = [self.sites objectAtIndex:lastIndexPath.row];
    
    [self.delegate doneSiteSelector:appDelagate.appDelegateCurrentSite];
}

#pragma  mark - NavigationBar

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
    
    self.layoutCOnstraints.constant = 20;
    
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [self.searchView setNeedsUpdateConstraints];
                         [self.searchView layoutIfNeeded];
                         
                         [self.tableView setNeedsUpdateConstraints];
                         [self.tableView layoutIfNeeded];
                         
                         //[self.searchButton setImage:[UIImage imageNamed:@"ico_find_on"] forState:UIControlStateNormal];
                         [self.view layoutIfNeeded];
                         
                         isSearchShown = YES;
                         
                         [self.txtSearch becomeFirstResponder];
                     }];
    
}


- (void) hideSearch{
    
    self.layoutCOnstraints.constant = -33;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [self.searchView setNeedsUpdateConstraints];
                         [self.searchView layoutIfNeeded];
                         
                         [self.tableView setNeedsUpdateConstraints];
                         [self.tableView layoutIfNeeded];
                         
                         //[self.searchButton setImage:[UIImage imageNamed:@"ico_find_off"] forState:UIControlStateNormal];
                         
                         isSearchShown = NO;
                         [self.view layoutIfNeeded];
                         
                         [self.txtSearch resignFirstResponder];
                         
                         [self.view endEditing:YES];
                     }];
    
}

#pragma mark - UITextFieldDelegate

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
        _sites = [LemursWatchingSites allInstances];
        
        [self.tableView reloadData];
        
    }else{
        _sites= [LemursWatchingSites getSitesLike:searchStr];
        
        [self.tableView reloadData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"showSiteMap"]){
        WatchingSiteMap* mapVC = (WatchingSiteMap*)[segue destinationViewController];
        if(mapVC){
            mapVC.delegate = self;
        }
    }
}


-(void)dismissSiteMapViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
