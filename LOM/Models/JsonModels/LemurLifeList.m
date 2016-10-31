//
//  LemurLifeList.m
//  LOM
//
//  Created by Ranto Andrianavonison on 7/25/16.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "LemurLifeList.h"

@implementation LemurLifeList


-(NSString*) getLemurLifeListImageFullPathName{
    if(self.isLocal){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *ImagePath = [documentsDirectory stringByAppendingPathComponent:self.lemur_photo.src];
        return ImagePath;
    }else{
        NSString * fullURLPath = self.lemur_photo.src;
        return fullURLPath;
    }
    return nil;
}


@end
