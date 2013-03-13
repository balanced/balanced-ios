//
//  BPMarketplace_Test.m
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/12/13.
//  Copyright (c) 2013 Unfiniti. All rights reserved.
//

#import "BPMarketplaceTests.h"
#import "BPMarketplace.h"

@implementation BPMarketplaceTests

- (void)testMarketplaceURI {
    NSString *uri = @"/v1/marketplaces/TEST-MP2autgNHAZxRWZs76RriOze";
    BPMarketplace *mp = [[BPMarketplace alloc] initWithURI:uri];
    STAssertTrue([[mp uri] isEqualToString:uri], @"Balanced marketplace URI cannot be nil");
}

@end
