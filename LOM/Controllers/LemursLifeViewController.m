//
//  LemursLifeViewController.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 07/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "LemursLifeViewController.h"
#import "LemurLifeListTableViewCell.h"
#import "Tools.h"
#import "AppData.h"
#import "PublicationResult.h"
#import "PopupLoginViewController.h"

@interface LemursLifeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewLifeList;

@end

@implementation LemursLifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) showLoginPopup{
    NSString* indentifier=@"PopupLoginViewController";
    PopupLoginViewController* controller = (PopupLoginViewController*) [Tools getViewControllerFromStoryBoardWithIdentifier:indentifier];
    controller.delegate = self;
    controller.preferredContentSize = CGSizeMake(300, 200);
    popoverController = [[WYPopoverController alloc] initWithContentViewController:controller];
    popoverController.delegate = self;
    [popoverController presentPopoverFromRect:self.view.bounds inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:NO options:WYPopoverAnimationOptionScale];
}


- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([Tools isNullOrEmptyString:[Tools getAppDelegate].currentToken]) {
        
        [self showLoginPopup ];
        
    }else{
        
        [self initActivityScreen:@"Please wait ..."];
        
        AppData* appData = [AppData getInstance];
        [appData getMyLemurLifeListForCompletion:^(id json, JSONModelError *err) {
            
            if (err) {
                [Tools showSimpleAlertWithTitle:@"LOM" andMessage:err.debugDescription];
            }else{
                
                NSDictionary* tmpDict = (NSDictionary*) json;
                NSError* error;
                PublicationResult* result = [[PublicationResult alloc] initWithDictionary:tmpDict error:&error];
                
                if (error)
                {
                    NSLog(@"Error parse : %@", error.debugDescription);
                }
                else
                {
                    _lemurLifeList = result.nodes;
                    
                    
                    self.tableViewLifeList.delegate = self;
                    self.tableViewLifeList.dataSource = self;
                    
                    [self.tableViewLifeList reloadData];
                    
                }
                
            }
            
            [self removeActivityScreen];
            
        }];
        
    }

}


-(void)initActivityScreen:(NSString*)messageActivity
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (activityScreen != nil)
        {
            [activityScreen removeFromSuperview];
            activityScreen = nil;
        }
        activityScreen =[[MTCSimpleActivityView alloc]initWithFrame:[Tools generateFrame:CGRectMake(0, 0, [Tools getScreenWidth], [Tools getScreenHeight])] withTextActivity:messageActivity];
        
        [[Tools getAppDelegate].window addSubview:activityScreen];
    });
}

-(void)removeActivityScreen
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (activityScreen != nil)
        {
            [activityScreen removeFromSuperview];
            activityScreen = nil;
        }
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark UITableviewDataSource Implements

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _lemurLifeList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LemurLifeListTableViewCell* cell = (LemurLifeListTableViewCell*) [Tools getCell:tableView identifier:@"lemurLifeListTableViewCell"];
    
    Publication* publication = (Publication*) [_lemurLifeList objectAtIndex:indexPath.row];
    
    [cell displayLemurLife:publication];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark WYPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller{
    popoverController.delegate = nil;
    popoverController = nil;
}


@end
