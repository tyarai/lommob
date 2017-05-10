//
//  Publication.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 02/01/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "Publication.h"
#import "Sightings.h"

@implementation Publication

-(NSString*) getSightingImageFullPathName{
    if(self.isLocal || !self.isSynced){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *ImagePath = [documentsDirectory stringByAppendingPathComponent:self.field_photo.src];
        return ImagePath;
    }else{
        NSString * fullURLPath = self.field_photo.src;
        return fullURLPath;
    }
}

-(void) updateDeletedByNID:(NSInteger) value nid:(NSInteger)nid {
    
    if(nid != 0){
        NSString * query = nil;
        query = [NSString stringWithFormat:@"UPDATE $T SET  _deleted = '%li', _isSynced = '0'  WHERE _nid = '%li' ", (long)value, (long)nid];
        [Sightings executeUpdateQuery:query];
    }

}

-(void) updateDeletedByUUID:(NSInteger) value nid:(NSString*)uuid {
    
    if(uuid  != nil){
        NSString * query = nil;
        query = [NSString stringWithFormat:@"UPDATE $T SET  _deleted = '%li', _isSynced = '0'  WHERE _uuid = '%@' ", (long)value, uuid];
        [Sightings executeUpdateQuery:query];
    }
    
}




@end
