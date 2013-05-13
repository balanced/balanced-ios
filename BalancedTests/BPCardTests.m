//
//  BPCardTests.m
//  BalancedTests
//
//  Created by Ben Mills on 3/10/13.
//

#import "BPCardTests.h"
#import "BPCard.h"

@implementation BPCardTests

// Test card creation

- (void)testCreateCard {
    NSString *cardNumber = @"4242424242424242";
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber expirationMonth:8 expirationYear:2025 securityCode:@"123"];
    STAssertTrue([card.number isEqualToString:cardNumber], @"Card number should equal %@", cardNumber);
}

- (void)testCreateCardWithOptionalFields {
    NSString *name = @"Johann Bernoulli";
    NSString *phoneNumber = @"111-222-3333";
    NSString *cardNumber = @"4242424242424242";
    NSDictionary *optionalFields = [[NSDictionary alloc] initWithObjectsAndKeys:name, @"name", phoneNumber, @"phone_number", nil];
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber expirationMonth:8 expirationYear:2025 securityCode:@"123" optionalFields:optionalFields];
    STAssertTrue([card.number isEqualToString:cardNumber], @"Card number should equal %@", cardNumber);
    STAssertTrue([[[card optionalFields] valueForKey:@"name"] isEqualToString:name], @"Name should be %@", name);
    STAssertTrue([[[card optionalFields] valueForKey:@"phone_number"] isEqualToString:phoneNumber], @"Phone number should be %@", phoneNumber);
}

// Test card types

- (void)testVisaCardType {
    NSString *cardNumber = @"41111111111111111";
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber expirationMonth:8 expirationYear:2025 securityCode:@"123"];
    STAssertTrue(card.type==BPCardTypeVisa, @"Card type should be %@ but was ", cardNumber, card.type);
}

- (void)testMastercardCardType {
    NSString *cardNumber = @"5105105105105100";
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber expirationMonth:8 expirationYear:2025 securityCode:@"123"];
    STAssertTrue(card.type==BPCardTypeMastercard, @"Card type should be %@ but was %@", @"Mastercard", card.type);
}

- (void)testAmericanExpressCardType {
    NSString *cardNumber = @"341111111111111";
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber expirationMonth:8 expirationYear:2025 securityCode:@"1234"];
    STAssertTrue(card.type==BPCardTypeAmericanExpress, @"Card type should be %@ but was %@", @"American Express", card.type);
}

- (void)testDiscoverCardType {
    NSString *cardNumber = @"6011111111111117";
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber expirationMonth:8 expirationYear:2025 securityCode:@"123"];
    STAssertTrue(card.type==BPCardTypeDiscover, @"Card type should be %@ but was %@", @"Discover Card", card.type);
}


// Test card numbers

- (void)testValidCardNumbers {
    NSArray *cardNumbers = [[NSArray alloc] initWithObjects:
                            @"4111111111111111",
                            @"4444444444444448",
                            @"4222222222222220",
                            @"4532418643138442",
                            @"4716314539050650",
                            @"4485498805067453",
                            @"4929679978342120",
                            @"4400544701105053",
                            @"5105105105105100",
                            @"5549904348586207",
                            @"5151601696648220",
                            @"5421885505663975",
                            @"5377756349885534",
                            @"5346784314486086",
                            @"6011373997942482",
                            @"6011640053409402",
                            @"6011978682866778",
                            @"6011391946659189",
                            @"6011358300105877",
                            @"341111111111111",
                            @"340893849936650",
                            @"372036201733247",
                            @"378431622693837",
                            @"346313453954711",
                            @"341677236686203", nil];
    for (NSString *number in cardNumbers) {
        BPCard *card = [[BPCard alloc] initWithNumber:number expirationMonth:8 expirationYear:2025 securityCode:@"123"];
        STAssertTrue(card.numberValid, @"%@ should be a valid card number", number);
    }
}


// Test security code

- (void)testValidAmexSecurityCode {
    BPCard *card = [[BPCard alloc] initWithNumber:@"341111111111111" expirationMonth:8 expirationYear:2025 securityCode:@"1234"];
    STAssertTrue(card.securityCodeValid, @"American Express security code 1234 should be valid");
}

- (void)testInvalidAmexSecurityCode {
    BPCard *card = [[BPCard alloc] initWithNumber:@"341111111111111" expirationMonth:8 expirationYear:2025 securityCode:@"123"];
    STAssertFalse(card.securityCodeValid, @"American Express security code 123 should be invalid");
}

- (void)testSecurityCode {
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" expirationMonth:8 expirationYear:2025 securityCode:@"123"];
    STAssertTrue(card.securityCodeValid, @"Security code should be valid");
}

- (void)testInvalidSecurityCodeShort {
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" expirationMonth:8 expirationYear:2025 securityCode:@"12"];
    STAssertFalse(card.securityCodeValid, @"Security code should be 3 digits");
}

- (void)testInvalidSecurityCodeLong {
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" expirationMonth:8 expirationYear:2025 securityCode:@"1234"];
    STAssertFalse(card.securityCodeValid, @"Security code should be 3 digits");
}


// Test expiration

- (void)testNonExpiredCard {
    BPCard *card = [[BPCard alloc] initWithNumber:@"411111111111111112" expirationMonth:8 expirationYear:2025 securityCode:@"123"];
    STAssertFalse(card.expired, @"Card should not be expired");
}

- (void)testNonExpiredCardExpiresThisYear {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
    BPCard *card = [[BPCard alloc] initWithNumber:@"411111111111111112" expirationMonth:8 expirationYear:components.year securityCode:@"123"];
    STAssertFalse(card.expired, @"Card should not be expired");
}

- (void)testExpiredCardExpiredMonth {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    BPCard *card = [[BPCard alloc] initWithNumber:@"411111111111111112" expirationMonth:components.month-1 expirationYear:components.year securityCode:@"123"];
    STAssertTrue(card.expired, @"Card should be expired");
}

- (void)testExpiredCardExpiredYear {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
    BPCard *card = [[BPCard alloc] initWithNumber:@"411111111111111112" expirationMonth:8 expirationYear:components.year-1 securityCode:@"123"];
    STAssertTrue(card.expired, @"Card should be expired");
}


// Valid test validate

- (void)testValidWithEverythingValid {
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" expirationMonth:8 expirationYear:2025 securityCode:@"123"];
    STAssertTrue(card.valid, @"Card should be valid");
    STAssertTrue([card.errors count] == 0, @"Card error count should be 0");
}

- (void)testValidWithInvalidCardNumber {
    BPCard *card = [[BPCard alloc] initWithNumber:@"411111111111111112" expirationMonth:8 expirationYear:2025 securityCode:@"123"];
    STAssertFalse(card.valid, @"Card should not be valid");
    STAssertTrue([card.errors count] == 1, @"Card error count should be 1");
    STAssertTrue([card.errors containsObject:@"Card number is not valid"], @"Card errors should contain \"Card number is not valid\"" );
}

- (void)testValidWithVaidCardNumberAndInvalidSecurityCode {
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" expirationMonth:8 expirationYear:2025 securityCode:@"1234"];
    STAssertFalse(card.valid, @"Card should not be valid");
    STAssertTrue([card.errors count] == 1, @"Card error count should be 1 but was %ld", [card.errors count]);
    STAssertTrue([card.errors containsObject:@"Security code is not valid"], @"Card errors should contain \"Security code is not valid\"" );
}

- (void)testValidWithVaidCardNumberAndExpired {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" expirationMonth:8 expirationYear:components.year-1 securityCode:@"123"];
    STAssertFalse(card.valid, @"Card should not be valid");
    STAssertTrue([card.errors count] == 1, @"Card error count should be 1 but was %ld", [card.errors count]);
    STAssertTrue([card.errors containsObject:@"Card is expired"], @"Card errors should contain \"Card is expired\"" );
}

- (void)testValidWithNothingValid {
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111111" expirationMonth:13 expirationYear:1900 securityCode:@"1234"];
    STAssertFalse(card.valid, @"Card should not be valid");
    STAssertTrue([card.errors count] > 1, @"Card error count should be > 2");
}

// Test getters

- (void)testGetCardNumber {
    NSString *cardNumber = @"4111111111111111111";
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber expirationMonth:8 expirationYear:2025 securityCode:@"123"];
    STAssertTrue([card.number isKindOfClass:[NSString class]], @"number should return a NSString");
    STAssertTrue([card.number isEqualToString:cardNumber], @"Card number should be %@", cardNumber);
}

/*- (void)testGetExpirationMonth {
    NSString *expirationMonth = @"8";
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111111" expirationMonth:expirationMonth expirationYear:@"2025" securityCode:@"123"];
    STAssertTrue([[card expirationMonth] isKindOfClass:[NSString class]], @"expirationMonth should return a NSString");
    STAssertTrue([[card expirationMonth] isEqualToString:expirationMonth], @"Expiration month should be %@", expirationMonth);
}

- (void)testGetExpirationYear {
    NSString *expirationYear = @"2025";
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111111" expirationMonth:@"8" expirationYear:expirationYear securityCode:@"123"];
    STAssertTrue([[card expirationYear] isKindOfClass:[NSString class]], @"expirationMonth should return a NSString");
    STAssertTrue([[card expirationYear] isEqualToString:expirationYear], @"Expiration month should be %@", expirationYear);
}*/

@end
