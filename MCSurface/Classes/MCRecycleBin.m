//
//  MCRecycleBin.m
//  MCSurface
//
//  Created by Baglan Dosmagambetov on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MCRecycleBin.h"

@implementation MCRecycleBin {
    NSMutableSet *_bin;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _bin = [NSMutableSet set];
    }
    return self;
}

- (id)dequeueObjectForKey:(id)key
{
    id objectForKey = nil;
    
    // Find an object for this key
    NSSet *objectsForKey = [_bin objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        NSDictionary *objectContainer = (NSDictionary *)obj;
        if ([[objectContainer objectForKey:@"key"] isEqual:key]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    // If there is such an object, remove it from the _bin and return
    NSDictionary *objectContainer = (NSDictionary *)[objectsForKey anyObject];
    if (objectContainer != nil) {
        objectForKey = [objectContainer objectForKey:@"object"];
        [_bin removeObject:objectContainer];
    }
    
    return objectForKey;
}

- (void)recycleObject:(id)obj withKey:(id)key
{
    if (key != nil) {
        [_bin addObject:[NSDictionary dictionaryWithObjectsAndKeys:obj, @"object", key, @"key", nil]];
    }
}

@end
