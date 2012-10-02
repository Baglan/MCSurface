//
//  MCRecycleBin.h
//  MCSurface
//
//  Created by Baglan Dosmagambetov on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCRecycleBin : NSObject

- (id)dequeueObjectForKey:(id)key;
- (void)recycleObject:(id)obj withKey:(id)key;

@end
