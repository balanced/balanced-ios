//
//  BPBankAccountTests.m
//  Balanced
//
//  Created by Ben Mills on 3/14/13.
//

#import "BPBankAccountTests.h"
#import "BPBankAccount.h"

@implementation BPBankAccountTests

// Test routing numbers

- (void)testRoutingNumber {
    NSString *routingNumber = @"053101273";
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:routingNumber andAccountNumber:@"111111111111" andAccountType:@"Checking" andName:@"Johann Bernoulli"];
    STAssertTrue([[ba routingNumber] isEqualToString:routingNumber], @"Routing number should be %@", routingNumber);
}

- (void)testValidRoutingNumbers {
    NSArray *routingNumbers = [[NSArray alloc] initWithObjects:
                                    @"053101273",
                                    @"114900685",
                                    @"113002186",
                                    @"122242607",
                                    @"267090617",
                                    @"011100106",
                                    @"081501065",
                                    @"021411089",
                                    @"107000327",
                                    @"021203501",
                                    @"065201048",
                                    @"107000233", nil];
    for (NSString *number in routingNumbers) {
        BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:number andAccountNumber:@"111111111111" andAccountType:@"Checking" andName:@"Johann Bernoulli"];
        STAssertTrue([ba routingNumberValid], @"%@ should be a valid routing number", number);
    }
}


// Test account number

- (void)testAccountNumber {
    NSString *accountNumber = @"111111111111";
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:accountNumber andAccountType:@"Checking" andName:@"Johann Bernoulli"];
    STAssertTrue([[ba accountNumber] isEqualToString:accountNumber], @"Account number should be %@", accountNumber);
}


// Test name

- (void)testName {
    NSString *name = @"Johann Bernoulli";
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:@"Checking" andName:name];
    STAssertTrue([[ba name] isEqualToString:name], @"Name should be %@", name);
}

- (void)testValidName {
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:@"Checking" andName:@"Johann Bernoulli"];
    STAssertTrue([ba nameValid], @"Name should be valid");
}


// Test account type

- (void)testValidAccountTypeCheckingUppercase {
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:@"Checking" andName:@"Johann Bernoulli"];
    STAssertTrue([ba accountTypeValid], @"Should be a valid account type");
}

- (void)testValidAccountTypeSavingsUppercase {
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:@"Savings" andName:@"Johann Bernoulli"];
    STAssertTrue([ba accountTypeValid], @"Should be a valid account type");
}

- (void)testValidAccountTypeChecking {
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:@"checking" andName:@"Johann Bernoulli"];
    STAssertTrue([ba accountTypeValid], @"Should be a valid account type");
}

- (void)testValidAccountTypeSavings {
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:@"savings" andName:@"Johann Bernoulli"];
    STAssertTrue([ba accountTypeValid], @"Should be a valid account type");
}

- (void)testInvalidAccountType {
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:@"Checkingz" andName:@"Johann Bernoulli"];
    STAssertFalse([ba accountTypeValid], @"Should not be a valid account type");
}

- (void)testAccountTypeChecking {
    NSString *accountType = @"checking";
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:accountType andName:@"Johann Bernoulli"];
    STAssertTrue([[ba accountType] isEqualToString:accountType], @"Account type should be %@", accountType);
}

- (void)testAccountTypeSavings {
    NSString *accountType = @"savings";
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:accountType andName:@"Johann Bernoulli"];
    STAssertTrue([[ba accountType] isEqualToString:accountType], @"Account type should be %@", accountType);
}


// Test valid method

- (void)testValidWithEverythingValid {
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:@"checking" andName:@"Johann Bernoulli"];
    STAssertTrue([ba valid], @"Bank account should be valid");
    STAssertTrue([[ba errors] count] == 0, @"Bank account error count should be 0");
}

- (void)testValidWithInvalidRoutingNumber {
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"810770808790897089" andAccountNumber:@"111111111111" andAccountType:@"savings" andName:@"Johann Bernoulli"];
    STAssertFalse([ba valid], @"Bank account should not be valid");
    STAssertTrue([[ba errors] count] == 1, @"Bank account error count should be 1");
    STAssertTrue([[ba errors] containsObject:@"Routing number is not valid"], @"Bank account errors should contain \"Routing number is not valid\"" );
}

- (void)testValidWithInvalidAccountType {
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:@"Checkingz" andName:@"Johann Bernoulli"];
    STAssertFalse([ba valid], @"Bank account should not be valid");
    STAssertTrue([[ba errors] count] == 1, @"Bank account error count should be 1");
    STAssertTrue([[ba errors] containsObject:@"Account type must be \"checking\" or \"savings\""], @"Bank account errors should contain 'Account type must be \"checking\" or \"savings\"'" );
}

- (void)testValidWithInvalidAccountName {
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:@"checking" andName:@""];
    STAssertFalse([ba valid], @"Bank account should not be valid");
    STAssertTrue([[ba errors] count] == 1, @"Bank account error count should be 1");
    STAssertTrue([[ba errors] containsObject:@"Account name should not be blank"], @"Bank account errors should contain \"Account name should not be blank\"");
}

- (void)testValidWithEverthingInvalid {
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"810770808790897089" andAccountNumber:@"111111111111" andAccountType:@"Checkingz" andName:@""];
    STAssertFalse([ba valid], @"Bank account should not be valid");
    STAssertTrue([[ba errors] count] == 3, @"Bank account error count should be 3");
    STAssertTrue([[ba errors] containsObject:@"Routing number is not valid"], @"Bank account errors should contain \"Routing number is not valid\"" );
    STAssertTrue([[ba errors] containsObject:@"Account type must be \"checking\" or \"savings\""], @"Bank account errors should contain 'Account type must be \"checking\" or \"savings\"'" );
    STAssertTrue([[ba errors] containsObject:@"Account name should not be blank"], @"Bank account errors should contain \"Account name should not be blank\"" );
}


// Account options

- (void)testAccountOptionalFields {
    NSDictionary *optionalFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"Testing", @"meta", nil];
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:@"savings" andName:@"Johann Bernoulli" andOptionalFields:optionalFields];
    STAssertNotNil([ba optionalFields], @"Optional fields should not be nil");
}

@end
