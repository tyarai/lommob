//
//  UITableViewCell+Stretch.h
//  LOM
//
//  Created by Ranto Andrianavonison on 20/10/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Stretch)

-(UITableViewCell*) stretchCell:(UITableViewCell*) cell
                          width:(NSUInteger) width
                         height:(NSUInteger) height;

@end
