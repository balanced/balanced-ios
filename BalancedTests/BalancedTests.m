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
    BPCard *card = [[BPCard alloc] initWithNumber:@"4242424242424242" expirationMonth:8 expirationYear:2025];
    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP6E3EVlPOsagSdcBNUXWBDQ"];
    [balanced tokenizeCard:card onSuccess:^(NSDictionary *responseParams) {
        response = responseParams;
        dispatch_semaphore_signal(semaphore);
    } onError:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }

    STAssertNotNil(response, @"Response should not be nil");
    STAssertTrue([[response valueForKey:@"status"] isEqualToString:@"201"],
                    [NSString stringWithFormat:@"Status should be 201 but was %@", [response valueForKey:@"status"]]);
    STAssertNotNil([[response valueForKey:@"data"] valueForKey:@"uri"], @"Card URI should not be nil");
}

- (void)testTokenizeCardBad
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSDictionary *response;
    BPCard *card = [[BPCard alloc] initWithNumber:@"424242424242424" expirationMonth:8 expirationYear:2025];
    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP6E3EVlPOsagSdcBNUXWBDQ"];
    [balanced tokenizeCard:card onSuccess:^(NSDictionary *responseParams) {
        response = responseParams;
        dispatch_semaphore_signal(semaphore);
    } onError:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }

    STAssertNotNil(response, @"Response should not be nil");
    STAssertTrue([[response valueForKey:@"status"] isEqualToString:@"400"], [NSString stringWithFormat:@"Status should be 400 but was %@", [response valueForKey:@"status"]]);
    STAssertNil([[response valueForKey:@"data"] valueForKey:@"uri"], @"Card URI should not be nil");
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
    BPCard *card = [[BPCard alloc] initWithNumber:@"4242424242424242" expirationMonth:8 expirationYear:2025 optionalFields:optionalFields];
    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP6E3EVlPOsagSdcBNUXWBDQ"];
    [balanced tokenizeCard:card onSuccess:^(NSDictionary *responseParams) {
        response = responseParams;
        dispatch_semaphore_signal(semaphore);
    } onError:^(NSError *error) {
        tokenizeError = error;
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    STAssertNil(tokenizeError, @"response should not have error");
    STAssertNotNil(response, @"Response should not be nil");
    STAssertTrue([[response valueForKey:@"status"] isEqualToString:@"201"], @"Status should be 201");
    STAssertNotNil([[response valueForKey:@"data"] valueForKey:@"uri"], @"Card URI should not be nil");
    STAssertNotNil([[response valueForKey:@"data"] valueForKey:@"name"], @"Name should not be nil");
    STAssertTrue([[[response valueForKey:@"data"] valueForKey:@"name"] isEqualToString:[optionalFields objectForKey:@"name"]], @"Name should be %@", [optionalFields objectForKey:@"name"]);
    //TODO: according to API docs, street_address is required when optional fields are also submitted
}


// Tokenize bank accounts

- (void)testTokenizeBankAccount
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP6E3EVlPOsagSdcBNUXWBDQ"];
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" accountNumber:@"111111111111" accountType:BPBankAccountTypeChecking name:@"Johann Bernoulli"];
    __block NSDictionary *response;
    __block NSError *tokenizeError;
    [balanced tokenizeBankAccount:ba onSuccess:^(NSDictionary *responseParams) {
        response = responseParams;
        dispatch_semaphore_signal(semaphore);
    } onError:^(NSError *error) {
        tokenizeError = error;
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    STAssertNil(tokenizeError, @"response should not have error");
    STAssertNotNil(response, @"Response should not be nil");
    STAssertTrue([[response valueForKey:@"status"] isEqualToString:@"201"], @"Status should be 201");
    STAssertNotNil([[response valueForKey:@"data"] valueForKey:@"uri"], @"Bank account URI should not be nil");
}

- (void)testTokenizeBankAccountWithOptionalFields
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSDictionary *response;
    __block NSError *tokenizeError;
    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP6E3EVlPOsagSdcBNUXWBDQ"];
    NSDictionary *optionalFields = @{};
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" accountNumber:@"111111111111" accountType:BPBankAccountTypeChecking name:@"Johann Bernoulli" optionalFields:optionalFields];
    [balanced tokenizeBankAccount:ba onSuccess:^(NSDictionary *responseParams) {
        response = responseParams;
        dispatch_semaphore_signal(semaphore);
    } onError:^(NSError *error) {
        tokenizeError = error;
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    STAssertNil(tokenizeError, @"response should not have error");
    STAssertNotNil(response, @"Response should not be nil");
    STAssertTrue([[response valueForKey:@"status"] isEqualToString:@"201"], @"Status should be 201");
    STAssertNotNil([[response valueForKey:@"data"] valueForKey:@"uri"], @"Bank account URI should not be nil");
    STAssertNotNil(response, @"Response should not be nil");
}

@end
