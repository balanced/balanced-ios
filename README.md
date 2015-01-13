![balancedlogo](https://www.balancedpayments.com/images/homepage_logo-01.png)

[![Build Status](https://travis-ci.org/balanced/balanced-ios.png)](https://travis-ci.org/balanced/balanced-ios)

iOS library for tokenizing credit card and bank accounts with Balanced Payments.

Current version : 1.0.1

**v1.x requires Balanced API 1.1. Use [v0.x](https://github.com/balanced/balanced-ios/tree/rev0) for Balanced API 1.0.**

Please refer to the following documentation sections for field documentation:
* [Create a Card](https://docs.balancedpayments.com/1.1/api/cards/#create-a-card-direct)
* [Create a BankAccount](https://docs.balancedpayments.com/1.1/api/bank-accounts/#create-a-bank-account-direct)

It's also recommended to review the [best practices](https://docs.balancedpayments.com/1.1/overview/best-practices/) section of the [Balanced documentation](https://docs.balancedpayments.com).

## Requirements

- ARC
- CoreTelephony.framework

## Installation

- [Download the pre-built library](https://github.com/balanced/balanced-ios/releases/1.0.1).
- Add balanced.a to your project and to Build Phases -> Link Binary With Libraries.
- Add CoreTelephony.framework to Build Phases -> Link Binary With Libraries.

#### Headers

##### includes folder
The includes folder is automatically included in the project's header search path.

- Copy the include folder to your project (or include/balanced to your existing include folder). Drag the folder to your project to add the references.

If you copy the files to a location other than includes you'll probably need to add the path to User Header Search Paths in your project settings.

##### Direct copy
You can copy the headers directly into your project and add them as direct references.
- Drag the contents of include/balanced to your project (select copy if needed)

## Usage

```objectivec
#import "Balanced.h" - Tokenizing methods
#import "BPBankAccount.h" - Bank Accounts
#import "BPCard.h" - Cards
```

#### Create a marketplace object

Instantiate a balanced instance. Balanced instances do not need a marketplace URI since Balanced API 1.1 no longer requires authenticated tokenization. For you this means you'll get back a response containing a card href and other attributes. Send the href to your server. 

```objectivec
Balanced *balanced = [[Balanced alloc] init];
```

#### Create a card

Please refer to the [official Balanced documentation](https://docs.balancedpayments.com/1.1/api/cards/#create-a-card-direct) for field documentation.

##### With only required fields

```objectivec
Balanced *balanced = [[Balanced alloc] init];
[balanced createCardWithNumber:@"4242424242424242"
               expirationMonth:8
                expirationYear:2025
                     onSuccess:^(NSDictionary *response) {
                     }
                       onError:^(NSError *error) {
                       }];
```

##### With optional fields

Use an NSDictionary for additional card fields you wish to specify.

```objectivec
NSDictionary *optionalFields = @{
                                 BPCardOptionalParamSecurityCodeKey:@"123",
                                 BPCardOptionalParamNameKey:@"Johann Bernoulli",
                                 BPCardOptionalParamStreetAddressKey:@"123 Main Street",
                                 BPCardOptionalParamPostalCodeKey:@"11111"
                                };
Balanced *balanced = [[Balanced alloc] init];
[balanced createCardWithNumber:@"4242424242424242"
               expirationMonth:8
                expirationYear:2025
                     onSuccess:^(NSDictionary *response) {
                     }
                       onError:^(NSError *error) {
                       }
                optionalFields:optionalFields];
```

##### Example response

```javascript
{
    "cards": [
        {
            "href": "/cards/CC2sx82S4zn4ECxbOloIRDxS",
            "id": "CC2sx82S4zn4ECxbOloIRDxS",
            "links": {}
        }
    ],
    "links": {},
    "status_code": 201
}
```


#### Create a bank account object

##### With only required fields

```objectivec
Balanced *balanced = [[Balanced alloc] init];
[balanced createBankAccountWithRoutingNumber:@"053101273"
                               accountNumber:@"111111111111"
                                 accountType:BPBankAccountTypeChecking
                                        name:@"Johann Bernoulli"
                                   onSuccess:^(NSDictionary *responseParams) {
                                   }
                                     onError:^(NSError *error) {
                                     }];
```

##### With optional fields

Use an NSDictionary for additional card fields you wish to specify.

```objectivec
NSDictionary *optionalFields = @{ BPCardOptionalParamMetaKey:@"Test" };
Balanced *balanced = [[Balanced alloc] init];
[balanced createBankAccountWithRoutingNumber:@"053101273"
                               accountNumber:@"111111111111"
                                 accountType:BPBankAccountTypeChecking
                                        name:@"Johann Bernoulli"
                                   onSuccess:^(NSDictionary *responseParams) {
                                   }
                                     onError:^(NSError *error) {
                                     }
                              optionalFields:optionalFields];
```

##### Example response

```javascript
{
    "bank_accounts": [
        {
            "href": "/bank_accounts/BA7uJx0yPIqAZXxpiKq5LY2y",
            "id": "BA7uJx0yPIqAZXxpiKq5LY2y",
            "links": {}
        }
    ],
    "links": {},
    "status_code": 201
}
```

## Contributing


#### Tests

Please include tests with all new code. Also, all existing tests must pass before new code can be merged.
