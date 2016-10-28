//
//  WatchingSiteViewController.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "WatchingSiteViewController.h"
#import "WatchingSiteTableViewCell.h"
#import "Tools.h"
#import "WatchingSiteDetailsViewController.h"

@interface WatchingSiteViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableviewWatchingSite;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopSpaceSearch;

@end

@implementation WatchingSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = nil;
    self.navigationItem.title = NSLocalizedString(@"watching_sites_title",@"");
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];
    
    __lemursWatchingSitesArray = [LemursWatchingSites allInstances];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pushWatchingSites"]) {
        
        WatchingSiteDetailsViewController* watchingSiteDetailsViewController = (WatchingSiteDetailsViewController*) [segue destinationViewController];
        
        watchingSiteDetailsViewController.lemursWatchingSites = _selectedLemursWatchingSites;
    }
}



- (IBAction)btnSearch_Touch:(id)sender {
    if (isSearchShown)
    {
        [self hideSearch];
    }else
    {
        [self showSearch];
    }
}


- (void) showSearch{
    
    self.constraintTopSpaceSearch.constant = -5;
    
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [self.viewSearch setNeedsUpdateConstraints];
                         [self.viewSearch layoutIfNeeded];
                         
                         [self.tableviewWatchingSite setNeedsUpdateConstraints];
                         [self.tableviewWatchingSite layoutIfNeeded];
                         
                         [self.btnSearch setImage:[UIImage imageNamed:@"ico_find_on"] forState:UIControlStateNormal];
                         
                         isSearchShown = YES;
                         [self.view layoutIfNeeded];
                         
                         [self.txtSearch becomeFirstResponder];
                     }];
    
}


- (void) hideSearch{
    
    self.constraintTopSpaceSearch.constant = -43;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [self.viewSearch setNeedsUpdateConstraints];
                         [self.viewSearch layoutIfNeeded];
                         
                         [self.tableviewWatchingSite setNeedsUpdateConstraints];
                         [self.tableviewWatchingSite layoutIfNeeded];
                         
                         [self.btnSearch setImage:[UIImage imageNamed:@"ico_find_off"] forState:UIControlStateNormal];
                         
                         isSearchShown = NO;
                         [self.view layoutIfNeeded];
                         
                         [self.txtSearch resignFirstResponder];
                         
                         [self.view endEditing:YES];
                     }];
    
}

#pragma mark UITableviewDataSource Implements

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return __lemursWatchingSitesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WatchingSiteTableViewCell* cell = (WatchingSiteTableViewCell*) [Tools getCell:tableView identifier:@"watchingSiteTableViewCell"];
    
    LemursWatchingSites* lemursWatchingSite = (LemursWatchingSites*) [__lemursWatchingSitesArray objectAtIndex:indexPath.row];
    
    [cell displayWatchingSite:lemursWatchingSite];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedLemursWatchingSites = [__lemursWatchingSitesArray objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"pushWatchingSites" sender:self];
}


#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    [self performSearch:searchStr];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    [self performSearch:nil];
    
    [textField resignFirstResponder];
    
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
        __lemursWatchingSitesArray = [LemursWatchingSites allInstances];
        
        [self.tableviewWatchingSite reloadData];
        
    }else{
        __lemursWatchingSitesArray = [LemursWatchingSites getLemursWatchingSitesLike:searchStr];
        
        [self.tableviewWatchingSite reloadData];
    }
}

@end
