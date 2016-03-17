//
//  ExtinctLemurs.m
//  LOM
//
//  Created by Ranto Andrianavonison on 17/03/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "ExtinctLemurs.h"
#import "Menus.h"


@implementation ExtinctLemurs
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFSafariViewController * vc = nil;
    
    switch(indexPath.row){
        case 0:{
            Menus * extinctLemursUrl = [Menus getMenuContentByMenuName:@"extinctlemurs"];
            NSString * strUrl = [extinctLemursUrl _menu_content ];
            NSURL * url = [NSURL URLWithString:strUrl];
            vc = [[SFSafariViewController alloc]initWithURL:url entersReaderIfAvailable:NO];
            break;
        }
        default:break;
    }
    
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];

}
@end
