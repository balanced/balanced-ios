![balancedlogo](https://www.balancedpayments.com/images/homepage_logo-01.png)

[![Build Status](https://travis-ci.org/balanced/balanced-ios.png)](https://travis-ci.org/balanced/balanced-ios)

iOS library for working with Balanced Payments.
Current version : 0.2.1

## Requirements

- ARC
- CoreTelephony.framework

## Installation

- Download the framework from LINK HERE.
- Add Balanced.framework to your project and to Build Phases -> Link Binary With Libraries.
- Add CoreTelephony.framework to Build Phases -> Link Binary With Libraries.

## Usage

    #import <Balanced/Balanced.h>


#### Create a marketplace object

Instantiate a balanced instance with your marketplace URI.

    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP2autgNHAZxRWZs76RriOze"];

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
    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP2BTDSHT7BYTjxlhdWtXWNN"];
    [balanced tokenizeCard:card onSuccess:^(NSDictionary *responseParams) {

    } onError:^(NSError *error) {

    }];

#### Create a bank account object

##### With only required fields

    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" accountNumber:@"111111111111" accountType:BPBankAccountTypeChecking name:@"Johann Bernoulli"];

##### With optional fields

Use an NSDictionary for additional card fields you wish to specify.

	NSDictionary *optionalFields = @{BPCardOptionalParamMetaKey:@"Test"};
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" accountNumber:@"111111111111" accountType:BPBankAccountTypeChecking name:@"Johann Bernoulli" optionalFields:optionalFields];


## Contributing

#### Requirements

The balanced-ios project builds a static iOS framework. The ability to create and build such frameworks has disappeared from recent Xcode 4 versions. To restore this functionality, which is required for working on balanced-ios, do the following:

    git clone git@github.com:kstenerud/iOS-Universal-Framework.git
    cd iOS-Universal-Framework/Real\ Framework
    ./install.sh

Specify the path to your version of Xcode. Answer yes to all prompts. Relaunch Xcode. This adds back the necessary Xcode templates.

#### Tests

Please include tests with all new code. Also, all existing tests must pass before new code can be merged.
