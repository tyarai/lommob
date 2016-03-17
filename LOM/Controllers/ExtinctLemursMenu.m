//
//  ExtinctLemursMenu.m
//  LOM
//
//  Created by Ranto Andrianavonison on 17/03/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "ExtinctLemursMenu.h"
#import "Links.h"
#import "ExtinctLemursCell.h"
#import "Constants.h"
#import "Reachability.h"

@implementation ExtinctLemursMenu

-(void)viewDidLoad{
    self.navigationItem.title = NSLocalizedString(@"Extinct lemurs",@"Extinct lemurs");
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:ORANGE_COLOR }];
    

    self.allLinks = [Links getLinkByName:@"extinctlemurs"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allLinks count];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Reachability *reachability = [Reachability reachabilityWithHostName:@"https://www.lemursofmadagascar.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus != NotReachable)
    {
        SFSafariViewController * vc = nil;
        Links * extinctLemursUrl = self.allLinks[indexPath.row];
        NSString * strUrl = [extinctLemursUrl _linkurl];
        NSURL * url = [NSURL URLWithString:strUrl];
        vc = [[SFSafariViewController alloc]initWithURL:url entersReaderIfAvailable:NO];
    
        if(vc != nil){
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Networking" message:@"Unable to connect to the intrnet ! Please check your network connection " preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExtinctLemursCell *cell = (ExtinctLemursCell*) [tableView dequeueReusableCellWithIdentifier:@"extinctLemursCell" forIndexPath:indexPath];
    
    Links *link = self.allLinks[indexPath.row];;
    cell.menu.text = [link _linktitle];
    return cell;
}



@end
