//
//  BPMarketplace.m
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/12/13.
//  Copyright (c) 2013 Unfiniti. All rights reserved.
//

#import "BPMarketplace.h"

@implementation BPMarketplace
@synthesize uri;

- (id)initWithURI:(NSString *)_uri {
    self = [super init];
    if (self) {
        self.uri = _uri;
    }
    return self;
}

@end
