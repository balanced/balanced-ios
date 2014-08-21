//
//  BalancedTests.m
//  BalancedTests
//
//  Created by Ben Mills on 3/9/13.
//

#import "BalancedTests.h"
#import "Balanced.h"
#import "BPCard.h"
#import "BPUtilities.h"

@implementation BalancedTests

- (void)testTokenizeCard
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSDictionary *response;
    Balanced *balanced = [[Balanced alloc] init];
    [balanced createCardWithNumber:@"4111111111111111"
                   expirationMonth:8
                    expirationYear:2025
                         onSuccess:^(NSDictionary *responseParams) {
                             response = responseParams;
                             dispatch_semaphore_signal(semaphore);
                         }
                           onError:^(NSError *error) {
                             dispatch_semaphore_signal(semaphore);
                         }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }

    STAssertNotNil(response, @"Response should not be nil");
    STAssertTrue([[response valueForKey:@"status_code"] isEqualToString:@"201"],
                    [NSString stringWithFormat:@"Status should be 201 but was %@", [response valueForKey:@"status_code"]]);
    STAssertNotNil([[response valueForKey:@"cards"][0] valueForKey:@"href"], @"Card href should not be nil");
}

- (void)testTokenizeCardBad
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSDictionary *response;
    Balanced *balanced = [[Balanced alloc] init];
    [balanced createCardWithNumber:@"4222222222222220"
                   expirationMonth:8
                    expirationYear:2025
                         onSuccess:^(NSDictionary *responseParams) {
                             response = responseParams;
                             dispatch_semaphore_signal(semaphore);
                         }
                           onError:^(NSError *error) {
                             dispatch_semaphore_signal(semaphore);
                         }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }

    STAssertNotNil(response, @"Response should not be nil");
    STAssertTrue([[response valueForKey:@"status_code"] isEqualToString:@"201"], [NSString stringWithFormat:@"Status should be 201 but was %@", [response valueForKey:@"status_code"]]);
    STAssertNotNil([[response valueForKey:@"cards"][0] valueForKey:@"href"], @"Card href should not be nil");
}

- (void)testTokenizeCardWithOptionalFields
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSDictionary *response;
    __block NSError *tokenizeError;
    NSDictionary *optionalFields = @{
                                     BPCardOptionalParamNameKey:@"Johann Bernoulli",
                                     BPCardOptionalParamSecurityCodeKey: @"123",
                                     BPCardOptionalParamStreetAddressKey:@"123 Main Street",
                                     BPCardOptionalParamPostalCodeKey:@"11111"
                                     };
    Balanced *balanced = [[Balanced alloc] init];
    [balanced createCardWithNumber:@"4242424242424242"
                   expirationMonth:8
                    expirationYear:2025
                         onSuccess:^(NSDictionary *responseParams) {
                             response = responseParams;
                             dispatch_semaphore_signal(semaphore);
                         }
                           onError:^(NSError *error) {
                             dispatch_semaphore_signal(semaphore);
                         }
                    optionalFields:optionalFields];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    STAssertNil(tokenizeError, @"response should not have error");
    STAssertNotNil(response, @"Response should not be nil");
    STAssertTrue([[response valueForKey:@"status_code"] isEqualToString:@"201"], @"Status should be 201");
    STAssertNotNil([[response valueForKey:@"cards"][0] valueForKey:@"href"], @"Card href should not be nil");
}


// Tokenize bank accounts

- (void)testTokenizeBankAccount
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSDictionary *response;
    __block NSError *tokenizeError;
    
    Balanced *balanced = [[Balanced alloc] init];
    [balanced createBankAccountWithRoutingNumber:@"053101273"
                                   accountNumber:@"111111111111"
                                     accountType:BPBankAccountTypeChecking
                                            name:@"Johann Bernoulli"
                                       onSuccess:^(NSDictionary *responseParams) {
                                           response = responseParams;
                                           dispatch_semaphore_signal(semaphore);
                                       }
                                         onError:^(NSError *error) {
                                             dispatch_semaphore_signal(semaphore);
                                         }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    STAssertNil(tokenizeError, @"response should not have error");
    STAssertNotNil(response, @"Response should not be nil");
    STAssertTrue([[response valueForKey:@"status_code"] isEqualToString:@"201"], @"Status should be 201");
    STAssertNotNil([[response valueForKey:@"bank_accounts"][0] valueForKey:@"href"], @"Bank account href should not be nil");
}

- (void)testTokenizeBankAccountWithOptionalFields
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSDictionary *response;
    __block NSError *tokenizeError;
    NSDictionary *optionalFields = @{};
    
    Balanced *balanced = [[Balanced alloc] init];
    [balanced createBankAccountWithRoutingNumber:@"053101273"
                                   accountNumber:@"111111111111"
                                     accountType:BPBankAccountTypeChecking
                                            name:@"Johann Bernoulli"
                                       onSuccess:^(NSDictionary *responseParams) {
                                           response = responseParams;
                                           dispatch_semaphore_signal(semaphore);
                                       }
                                         onError:^(NSError *error) {
                                             dispatch_semaphore_signal(semaphore);
                                         }
                                  optionalFields:optionalFields];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    STAssertNil(tokenizeError, @"response should not have error");
    STAssertNotNil(response, @"Response should not be nil");
    STAssertTrue([[response valueForKey:@"status_code"] isEqualToString:@"201"], @"Status should be 201");
    STAssertNotNil([[response valueForKey:@"bank_accounts"][0] valueForKey:@"href"], @"Bank account href should not be nil");
    STAssertNotNil(response, @"Response should not be nil");
}

@end
