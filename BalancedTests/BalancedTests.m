//
//  Balanced_Test.m
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
//  Copyright (c) 2013 Unfiniti. All rights reserved.
//

#import "BalancedTests.h"
#import "Balanced.h"
#import "BPCard.h"
#import "BPMarketplace.h"

@implementation BalancedTests

- (void)testGetTimezoneOffset {
    STAssertTrue([Balanced getTimezoneOffset] >= -12 && [Balanced getTimezoneOffset] <= 14, @"Timezone offset should be within acceptable range");
}

- (void)testGetMACAddress {
    STAssertNotNil([Balanced getMACAddress], @"MAC address should not be nil");
}

- (void)testGetIPAddress {
    STAssertNotNil([Balanced getIPAddress], @"IP address should not be nil");
}

- (void)testUserAgentString {
    STAssertNotNil([Balanced userAgentString], @"User-Agent should not be nil");
}

- (void)testTokenizeCard {
    BPMarketplace *mp = [[BPMarketplace alloc] initWithURI:@"/v1/marketplaces/TEST-MP2autgNHAZxRWZs76RriOze"];
    NSError *error;
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"123"];
    NSDictionary *response = [Balanced tokenizeCard:card forMarketplace:mp error:&error];
    
    if (error != NULL) { STFail(@"Response should not have an error"); }
    
    STAssertNotNil(response, @"Response should not be nil");
    STAssertNotNil([response valueForKey:@"uri"], @"Card URI should not be nil");
}

@end
