//
//  Publication.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "Publication.h"

@implementation Publication

-(NSString*) getSightingImageFullPathName{
    if(self.isLocal){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *ImagePath = [documentsDirectory stringByAppendingPathComponent:self.field_photo.src];
        return ImagePath;
    }else{
        NSString * fullURLPath = self.field_photo.src;
        NSArray * pathComponents = [fullURLPath componentsSeparatedByString:@"/"];
        NSUInteger count = [pathComponents count];
        //return [pathComponents objectAtIndex:count-1];
        return fullURLPath;
    }
}


@end
