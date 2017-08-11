//
//  WatchingSiteMap.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 10/08/2017.
//  Copyright © 2017 Kerty KAMARY. All rights reserved.
//

#import "WatchingSiteMap.h"
#import "Maps.h"
#import "Tools.h"

@interface WatchingSiteMap ()

@end

@implementation WatchingSiteMap

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{

    AppDelegate* appDelegate = [Tools getAppDelegate];
    
    if(appDelegate.appDelegateTemporarySite!= nil){
        
        NSInteger map_id = (NSInteger)appDelegate.appDelegateTemporarySite._map_id;
        
        Maps * map = [Maps getMapByNID:map_id];
        
        if(map){
            
            NSString *imageFileName = map._file_name;
            UIImage * image        = [UIImage imageNamed:imageFileName];
            if(image){
                self.mapImageView.image = image;
            }
            NSString * title = map._title;;
            if([Tools isNullOrEmptyString:title]){
                title = appDelegate.appDelegateTemporarySite._title;
            }
            self.siteName.text = title;
        }
    }
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
- (IBAction)closeTapped:(id)sender {
    [self.delegate dismissSiteMapViewController];
}

@end
