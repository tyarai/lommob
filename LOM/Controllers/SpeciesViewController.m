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
#import "LoginResult.h"


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
    
    NSArray * allSpecies = [Species allSpeciesOrderedByTitle:@""];
    
    NSString * _title = [NSString stringWithFormat:@"%lu %@ %@",(unsigned long)[allSpecies count],title,@" and counting"];
    
    self.navigationItem.title = _title;
    self.navigationItem.titleView = nil;
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];
    
    ongoingLogin = NO;
    
    [self showData];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self.collectionSpecies reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [self checkUserSession];
}

#pragma mark PopupLogin

- (void) cancel{
    [popoverController dismissPopoverAnimated:YES];
}


-(void) checkUserSession{
    if([Tools isNullOrEmptyString:appDelegate._currentToken] && !ongoingLogin){
        [self showLoginPopup];
    }/*else{
        [self performSelector:@selector(presentMain) withObject:nil afterDelay:3.0f];
    }*/
}

-(void) showLoginPopup{
    
    NSString* indentifier=@"PopupLoginViewController";
    
    ongoingLogin = YES;
    
    loginViewController = (PopupLoginViewController*) [Tools getViewControllerFromStoryBoardWithIdentifier:indentifier];
    loginViewController.delegate = self;
    
    [self presentViewController:loginViewController animated:YES completion:nil];
    
}

- (void) validWithUserName:(NSString*) userName password:(NSString*) password andRememberMe:(BOOL) rememberMe
{
    
    //[popoverController dismissPopoverAnimated:YES];
    
    [self showActivityScreen];
    
    [appData loginWithUserName:userName andPassword:password forCompletion:^(id json, JSONModelError *err) {
        
        [self removeActivityScreen];
        
        if (err)
        {
            [Tools showError:err onViewController:loginViewController];
        }
        else
        {
            NSError* error;
            NSDictionary* tmpDict = (NSDictionary*) json;
            LoginResult* loginResult = [[LoginResult alloc] initWithDictionary:tmpDict error:&error];
            
            if (error)
            {
                NSLog(@"Error parse : %@", error.debugDescription);
            }
            else
            {
                if (![Tools isNullOrEmptyString:loginResult.sessid]
                    &&![Tools isNullOrEmptyString:loginResult.session_name]
                    &&![Tools isNullOrEmptyString:loginResult.token]
                    && loginResult.user != nil) {
                    
                    
                    [Tools     saveSessId:loginResult.sessid
                              sessionName:loginResult.session_name
                                 andToken:loginResult.token
                                      uid:loginResult.user.uid
                                 userName:loginResult.user.name
                                 userMail:loginResult.user.mail
                     ];

                    
                    appDelegate._currentToken   = loginResult.token;
                    appDelegate._curentUser     = loginResult.user;
                    appDelegate._sessid         = loginResult.sessid;
                    appDelegate._sessionName    = loginResult.session_name;
                    appDelegate._uid            = loginResult.user.uid;
                    appDelegate._userName       = loginResult.user.name;
                    appDelegate._userMail       = loginResult.user.mail;
                    
                    [appDelegate syncSettings]; // Asaina mi-load settings avy any @ serveur avy hatrany eto
                    
                    [self dismissViewControllerAnimated:NO completion:nil];
                    
                    ongoingLogin = NO; // VIta ny login
                    
                    //[self performSelectorOnMainThread:@selector(presentMain) withObject:nil waitUntilDone:NO];
                    
                }
            }
        }
        
    }];
    
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
