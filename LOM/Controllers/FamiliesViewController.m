//
//  FamiliesViewController.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "FamiliesViewController.h"
#import "FamilyTableViewCell.h"
#import "Tools.h"
#import "Families.h"
#import "FamiliesDetailsViewController.h"

@interface FamiliesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewFamilies;

@end

@implementation FamiliesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"families_title",@"");
    _families = [Families allInstances];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pushDetailFamily"]) {
        
        FamiliesDetailsViewController* familiesDetailsViewController = (FamiliesDetailsViewController*) [segue destinationViewController];
        
        familiesDetailsViewController.families = _selectedFamily;
    }
}


#pragma UITableView Datasource & Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _families.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FamilyTableViewCell* cell = (FamilyTableViewCell*) [Tools getCell:tableView identifier:@"familyTableViewCell"];
    
    Families* family = (Families*) [_families objectAtIndex:indexPath.row];
    
    [cell displayFamily:family];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedFamily = [_families objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"pushDetailFamily" sender:self];
}


@end
