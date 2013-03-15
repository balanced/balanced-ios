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

- (void)testTokenizeCard {
    NSError *error;
    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP2autgNHAZxRWZs76RriOze"];
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" andExperationMonth:@"8" andExperationYear:@"2025" andSecurityCode:@"123"];
    NSDictionary *response = [balanced tokenizeCard:card error:&error];
    
    if (error != NULL) { STFail(@"Response should not have an error"); }
    
    STAssertNotNil(response, @"Response should not be nil");
    STAssertNotNil([response valueForKey:@"uri"], @"Card URI should not be nil");
}

- (void)testTokenizeCardWithCardOptionalFields {
    NSError *error;
    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP2autgNHAZxRWZs76RriOze"];
    NSString *name = @"Johann Bernoulli";
    NSString *cardNumber = @"4242424242424242";
    NSDictionary *optionalFields = [[NSDictionary alloc] initWithObjectsAndKeys:name, @"name", nil];
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber andExperationMonth:@"8" andExperationYear:@"2025" andSecurityCode:@"123" andOptionalFields:optionalFields];
    NSDictionary *response = [balanced tokenizeCard:card error:&error];
    
    if (error != NULL) { STFail(@"Response should not have an error"); }

    STAssertNotNil(response, @"Response should not be nil");
    STAssertNotNil([response valueForKey:@"uri"], @"Card URI should not be nil");
    STAssertNotNil([response valueForKey:@"name"], @"Name should not be nil");
    STAssertTrue([[response valueForKey:@"name"] isEqualToString:name], @"Name should be %@", name);
}


// Tokenize bank accounts

- (void)testTokenizeBankAccount {
    NSError *error;
    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP2autgNHAZxRWZs76RriOze"];
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:@"checking" andName:@"Johann Bernoulli"];
    NSDictionary *response = [balanced tokenizeBankAccount:ba error:&error];
    
    if (error != NULL) { STFail(@"Response should not have an error"); }
    
    STAssertNotNil(response, @"Response should not be nil");
    STAssertNotNil([response valueForKey:@"uri"], @"Bank account URI should not be nil");
}

- (void)testTokenizeBankAccountWithOptionalFields {
    NSError *error;
    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP2autgNHAZxRWZs76RriOze"];
    NSDictionary *optionalFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"Testing", @"meta", nil];
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:@"checking" andName:@"Johann Bernoulli" andOptionalFields:optionalFields];
    NSDictionary *response = [balanced tokenizeBankAccount:ba error:&error];
    
    if (error != NULL) { STFail(@"Response should not have an error"); }
    
    STAssertNotNil(response, @"Response should not be nil");
}

@end
