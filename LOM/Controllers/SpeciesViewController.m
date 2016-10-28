//
//  SpeciesViewController.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "SpeciesViewController.h"
#import "Species.h"
#import "SpecyCollectionViewCell.h"
#import "Tools.h"
#import "SpeciesDetailsViewController.h"
#import "Constants.h"

@interface SpeciesViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionSpecies;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopSpaceSearch;

@end

@implementation SpeciesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * title = NSLocalizedString(@"species_title",@"");
    self.navigationItem.title = title;
    self.navigationItem.titleView = nil;
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];
    
    
    
    [self showData];
}
-(void)viewDidAppear:(BOOL)animated{
    [self.collectionSpecies reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showData{
    
    __speciesArray = [Species allInstances];
    
    self.collectionSpecies.delegate = self;
    self.collectionSpecies.dataSource = self;
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pushDetailSpecies"]) {
        
        SpeciesDetailsViewController* speciesDetailsViewController = (SpeciesDetailsViewController*) [segue destinationViewController];
        
        speciesDetailsViewController.specy = _selectedSpecy;
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
                         
                         [self.collectionSpecies setNeedsUpdateConstraints];
                         [self.collectionSpecies layoutIfNeeded];
                         
                         [self.btnSearch setImage:[UIImage imageNamed:@"ico_find_on"] forState:UIControlStateNormal];
                         [self.view layoutIfNeeded];
                         
                         isSearchShown = YES;
                         
                         [self.txtSearch becomeFirstResponder];
                     }];
    
}


- (void) hideSearch{
    
    self.constraintTopSpaceSearch.constant = -43;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [self.viewSearch setNeedsUpdateConstraints];
                         [self.viewSearch layoutIfNeeded];
                         
                         [self.collectionSpecies setNeedsUpdateConstraints];
                         [self.collectionSpecies layoutIfNeeded];
                         
                         [self.btnSearch setImage:[UIImage imageNamed:@"ico_find_off"] forState:UIControlStateNormal];
                         
                         isSearchShown = NO;
                         [self.view layoutIfNeeded];
                         
                         [self.txtSearch resignFirstResponder];
                         
                         [self.view endEditing:YES];
                     }];
    
}

#pragma mark UICollectionViewDataSource Implements

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return __speciesArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SpecyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpecyCollectionViewCell" forIndexPath:indexPath];
    
    Species* currentSpecy = [__speciesArray objectAtIndex:indexPath.row];
    
    [cell displaySpecy:currentSpecy];
    
    return cell;
    
}

#pragma mark UICollectionViewDelegate Implements

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedSpecy = [__speciesArray objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"pushDetailSpecies" sender:self];
    
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
        __speciesArray = [Species allInstances];
        
        [self.collectionSpecies reloadData];
        
    }else{
        __speciesArray = [Species getSpeciesLike:searchStr];
        
        [self.collectionSpecies reloadData];
    }
}

@end
