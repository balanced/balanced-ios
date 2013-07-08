![balancedlogo](https://www.balancedpayments.com/images/homepage_logo-01.png)

[![Build Status](https://travis-ci.org/balanced/balanced-ios.png)](https://travis-ci.org/balanced/balanced-ios)

iOS library for working with Balanced Payments.
Current version : 0.4

## Requirements

- ARC
- CoreTelephony.framework

## Installation

- Download the framework from LINK HERE.
- Add balanced.a to your project and to Build Phases -> Link Binary With Libraries.
- Add CoreTelephony.framework to Build Phases -> Link Binary With Libraries.

#### Headers

##### includes folder
The includes folder is automatically included in the project's header search path.

- Copy the include folder to your project (or include/balanced to your existing include folder). Drag the folder to your project to add the references.

If you copy the files to a location other than includes you'll probably need to add the path to User Header Search Paths in your project settings.

##### Direct copy
You can copy the headers directly into your proejct and add them as direct references.
- Drag the contents of include/balanced to your project (select copy if needed)

## Usage

    #import "Balanced.h" - Tokenizing methods
    #import "BPBankAccount.h" - Bank Accounts
    #import "BPCard.h" - Cards

#### Create a marketplace object

Instantiate a balanced instance with your marketplace URI.

    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP6E3EVlPOsagSdcBNUXWBDQ"];

#### Create a card object

##### With only required fields

    BPCard *card = [[BPCard alloc] initWithNumber:@"4242424242424242" expirationMonth:8 expirationYear:2025 securityCode:@"123"];

##### With optional fields

Use an NSDictionary for additional card fields you wish to specify.

    NSDictionary *optionalFields = @{
                                     BPCardOptionalParamNameKey:@"Johann Bernoulli",
                                     BPCardOptionalParamStreetAddressKey:@"123 Main Street",
                                     BPCardOptionalParamPostalCodeKey:@"11111"
                                     };
    BPCard *card = [[BPCard alloc] initWithNumber:@"4242424242424242" expirationMonth:8 expirationYear:2025 securityCode:@"123" optionalFields:optionalFields];

#### Tokenize a card

    BPCard *card = [[BPCard alloc] initWithNumber:@"4242424242424242" expirationMonth:8 expirationYear:2025 securityCode:@"123"];
    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP6E3EVlPOsagSdcBNUXWBDQ"];
    [balanced tokenizeCard:card onSuccess:^(NSDictionary *responseParams) {
      // success
    } onError:^(NSError *error) {
      // failure
    }];

#### Create a bank account object

##### With only required fields

    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" accountNumber:@"111111111111" accountType:BPBankAccountTypeChecking name:@"Johann Bernoulli"];

##### With optional fields

Use an NSDictionary for additional card fields you wish to specify.

    NSDictionary *optionalFields = @{BPCardOptionalParamMetaKey:@"Test"};
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" accountNumber:@"111111111111" accountType:BPBankAccountTypeChecking name:@"Johann Bernoulli" optionalFields:optionalFields];


## Contributing


#### Tests

Please include tests with all new code. Also, all existing tests must pass before new code can be merged.
