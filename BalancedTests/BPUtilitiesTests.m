//
//  BPUtilitiesTests.m
//  BalancedTests
//
//  Created by Ben Mills on 3/14/13.
//

#import "BPUtilitiesTests.h"
#import "BPUtilities.h"

@implementation BPUtilitiesTests

- (void)testGetTimezoneOffset {
    STAssertTrue([BPUtilities getTimezoneOffset] >= -12 && [BPUtilities getTimezoneOffset] <= 14, @"Timezone offset should be within acceptable range");
}

- (void)testUserAgentString {
    STAssertNotNil([BPUtilities userAgentString], @"User-Agent should not be nil");
}

@end
