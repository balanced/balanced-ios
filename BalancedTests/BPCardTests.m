//
//  BPCard_Test.m
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/10/13.
//  Copyright (c) 2013 Unfiniti. All rights reserved.
//

#import "BPCardTests.h"
#import "BPCard.h"

@implementation BPCardTests

// Test card creation

- (void)testCreateCard {
    NSString *cardNumber = @"4242424242424242";
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"123"];
    STAssertTrue([[card number] isEqualToString:cardNumber], @"Card number should equal %@", cardNumber);
}

// Test card types

- (void)testVisaCardType {
    NSString *cardNumber = @"41111111111111111";
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"123"];
    STAssertTrue([[card type] isEqualToString:@"VISA"], @"Card type should be %@ but was ", cardNumber, [card type]);
}

- (void)testMastercardCardType {
    NSString *cardNumber = @"5105105105105100";
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"123"];
    STAssertTrue([[card type] isEqualToString:@"Mastercard"], @"Card type should be %@ but was %@", @"Mastercard", [card type]);
}

- (void)testAmericanExpressCardType {
    NSString *cardNumber = @"341111111111111";
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"1234"];
    STAssertTrue([[card type] isEqualToString:@"American Express"], @"Card type should be %@ but was %@", @"American Express", [card type]);
}

- (void)testDiscoverCardType {
    NSString *cardNumber = @"6011111111111117";
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"123"];
    STAssertTrue([[card type] isEqualToString:@"Discover Card"], @"Card type should be %@ but was %@", @"Discover Card", [card type]);
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
        BPCard *card = [[BPCard alloc] initWithNumber:number withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"123"];
        STAssertTrue([card numberValid], @"%@ should be a valid card number", number);
    }
}


// Test security code

- (void)testValidAmexSecutiryCode {
    BPCard *card = [[BPCard alloc] initWithNumber:@"341111111111111" withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"1234"];
    STAssertTrue([card securityCodeValid], @"American Express security code 1234 should be valid");
}

- (void)testInvalidAmexSecutiryCode {
    BPCard *card = [[BPCard alloc] initWithNumber:@"341111111111111" withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"123"];
    STAssertFalse([card securityCodeValid], @"American Express security code 123 should be invalid");
}

- (void)testSecutiryCode {
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"123"];
    STAssertTrue([card securityCodeValid], @"Security code should be valid");
}

- (void)testInvalidSecutiryCodeShort {
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"12"];
    STAssertFalse([card securityCodeValid], @"Security code should be 3 digits");
}

- (void)testInvalidSecutiryCodeLong {
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"1234"];
    STAssertFalse([card securityCodeValid], @"Security code should be 3 digits");
}


// Test expiration

- (void)testNonExpiredCard {
    BPCard *card = [[BPCard alloc] initWithNumber:@"411111111111111112" withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"123"];
    STAssertFalse([card expired], @"Card should not be expired");
}

- (void)testNonExpiredCardExpiresThisYear {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
    BPCard *card = [[BPCard alloc] initWithNumber:@"411111111111111112" withExperationMonth:@"8" withExperationYear:[NSString stringWithFormat:@"%d", [components year]] withSecurityCode:@"123"];
    STAssertFalse([card expired], @"Card should not be expired");
}

- (void)testExpiredCardExpiredMonth {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    BPCard *card = [[BPCard alloc] initWithNumber:@"411111111111111112" withExperationMonth:[NSString stringWithFormat:@"%d", [components month] - 1] withExperationYear:[NSString stringWithFormat:@"%d", [components year]] withSecurityCode:@"123"];
    STAssertTrue([card expired], @"Card should be expired");
}

- (void)testExpiredCardExpiredYear {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
    BPCard *card = [[BPCard alloc] initWithNumber:@"411111111111111112" withExperationMonth:@"8" withExperationYear:[NSString stringWithFormat:@"%d", [components year] - 1] withSecurityCode:@"123"];
    STAssertTrue([card expired], @"Card should be expired");
}


// Valid test validate

- (void)testValidWithInvalidCardNumber {
    BPCard *card = [[BPCard alloc] initWithNumber:@"411111111111111112" withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"123"];
    STAssertFalse([card valid], @"Card should not be valid");
    STAssertTrue([[card errors] count] == 1, @"Card error count should be 1");
    STAssertTrue([[card errors] containsObject:@"Card number is not valid"], @"Card errors should contain \"Card number is not valid\"" );
}

- (void)testValidWithVaidCardNumberAndInvalidSecurityCode {
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"1234"];
    STAssertFalse([card valid], @"Card should not be valid");
    STAssertTrue([[card errors] count] == 1, @"Card error count should be 1 but was %ld", [[card errors] count]);
    STAssertTrue([[card errors] containsObject:@"Security code is not valid"], @"Card errors should contain \"Security code is not valid\"" );
}

- (void)testValidWithVaidCardNumberAndExpired {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" withExperationMonth:@"8" withExperationYear:[NSString stringWithFormat:@"%d", [components year] - 1] withSecurityCode:@"123"];
    STAssertFalse([card valid], @"Card should not be valid");
    STAssertTrue([[card errors] count] == 1, @"Card error count should be 1 but was %ld", [[card errors] count]);
    STAssertTrue([[card errors] containsObject:@"Card is expired"], @"Card errors should contain \"Card is expired\"" );
}

- (void)testValidWithNothingValid {
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111111" withExperationMonth:@"13" withExperationYear:@"1900" withSecurityCode:@"1234"];
    STAssertFalse([card valid], @"Card should not be valid");
    STAssertTrue([[card errors] count] > 1, @"Card error count should be > 2");
}

// Test getters

- (void)testGetCardNumber {
    NSString *cardNumber = @"4111111111111111111";
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"123"];
    STAssertTrue([[card number] isKindOfClass:[NSString class]], @"number should return a NSString");
    STAssertTrue([[card number] isEqualToString:cardNumber], @"Card number should be %@", cardNumber);
}

- (void)testGetExpirationMonth {
    NSString *expirationMonth = @"8";
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111111" withExperationMonth:expirationMonth withExperationYear:@"2025" withSecurityCode:@"123"];
    STAssertTrue([[card expirationMonth] isKindOfClass:[NSString class]], @"expirationMonth should return a NSString");
    STAssertTrue([[card expirationMonth] isEqualToString:expirationMonth], @"Expiration month should be %@", expirationMonth);
}

- (void)testGetExpirationYear {
    NSString *expirationYear = @"2025";
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111111" withExperationMonth:@"8" withExperationYear:expirationYear withSecurityCode:@"123"];
    STAssertTrue([[card expirationYear] isKindOfClass:[NSString class]], @"expirationMonth should return a NSString");
    STAssertTrue([[card expirationYear] isEqualToString:expirationYear], @"Expiration month should be %@", expirationYear);
}

@end
