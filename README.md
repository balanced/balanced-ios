![balancedlogo](https://www.balancedpayments.com/images/homepage_logo-01.png)

[![Build Status](https://travis-ci.org/balanced/balanced-ios.png)](https://travis-ci.org/balanced/balanced-ios)

iOS library for tokenizing credit card and bank accounts with Balanced Payments.
Current version : 0.4

Please refer to [creating a new bank account](https://docs.balancedpayments.com/current/api#creating-a-new-bank-account) for field documentation.

It's also recommended to review the [best practices](https://docs.balancedpayments.com/current/#best-practices documentation) section of the [Balanced documentation](https://docs.balancedpayments.com/current).

## Requirements

- ARC
- CoreTelephony.framework

## Installation

- [Download the pre-built library](https://github.com/balanced/balanced-ios/releases/0.4).
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

```objectivec
#import "Balanced.h" - Tokenizing methods
#import "BPBankAccount.h" - Bank Accounts
#import "BPCard.h" - Cards
```

#### Create a marketplace object

Instantiate a balanced instance with your marketplace URI.

```objectivec
Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP6E3EVlPOsagSdcBNUXWBDQ"];
```

#### Create a card object

##### With only required fields

```objectivec
BPCard *card = [[BPCard alloc] initWithNumber:@"4242424242424242" expirationMonth:8 expirationYear:2025];
```

##### With optional fields

Please refer to the [official Balanced documentation](https://docs.balancedpayments.com/current/api#creating-a-new-bank-account) for field documentation

Use an NSDictionary for additional card fields you wish to specify.

```objectivec
NSDictionary *optionalFields = @{
                                 BPCardOptionalParamSecurityCodeKey:@"123",
                                 BPCardOptionalParamNameKey:@"Johann Bernoulli",
                                 BPCardOptionalParamStreetAddressKey:@"123 Main Street",
                                 BPCardOptionalParamPostalCodeKey:@"11111"
                                };
BPCard *card = [[BPCard alloc] initWithNumber:@"4242424242424242"
                              expirationMonth:8
                               expirationYear:2025
                               optionalFields:optionalFields];
```

#### Tokenize a card

```objectivec
BPCard *card = [[BPCard alloc] initWithNumber:@"4242424242424242" expirationMonth:8 expirationYear:2025];
Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP6E3EVlPOsagSdcBNUXWBDQ"];
[balanced tokenizeCard:card onSuccess:^(NSDictionary *responseParams) {
    // success
} onError:^(NSError *error) {
    // failure
}];
```

##### Example response

```
{
    data =     {
        "_type" = card;
        "_uris" =         {
        };
        account = "<null>";
        brand = Visa;
        "card_type" = visa;
        "country_code" = "<null>";
        "created_at" = "2013-10-24T21:45:57.306483Z";
        customer = "<null>";
        "expiration_month" = 8;
        "expiration_year" = 2014;
        hash = 8ead77c90a606701ae7614bb9a2ce802e34bdb706e1eeb4ec01a1eda8875d001;
        id = CC5bm6UZ2zbTgxPOYRZjsvbi;
        "is_valid" = 1;
        "is_verified" = 1;
        "last_four" = 1111;
        meta =         {
        };
        name = "<null>";
        "postal_code" = "<null>";
        "postal_code_check" = unknown;
        "security_code_check" = passed;
        "street_address" = "<null>";
        uri = "/v1/marketplaces/TEST-MP1AiLUNRhKX28DrJDbd9LX1/cards/CC5bm6UZ2zbTgxPOYRZjsvbi";
    };
    status = 201;
}
```


#### Create a bank account object

##### With only required fields

```objectivec
BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273"
                                                   accountNumber:@"111111111111"
                                                     accountType:BPBankAccountTypeChecking
                                                            name:@"Johann Bernoulli"];
```

##### With optional fields

Use an NSDictionary for additional card fields you wish to specify.

```objectivec
NSDictionary *optionalFields = @{ BPCardOptionalParamMetaKey:@"Test" };
BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273"
                                                   accountNumber:@"111111111111"
                                                     accountType:BPBankAccountTypeChecking
                                                            name:@"Johann Bernoulli"
                                                  optionalFields:optionalFields];
```

## Contributing


#### Tests

Please include tests with all new code. Also, all existing tests must pass before new code can be merged.
