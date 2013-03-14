![balancedlogo](https://www.balancedpayments.com/images/homepage_logo-01.png)


balanced-ios. iOS library for working with Balanced Payments.

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

A marketplace card object is required for adding cards.

    BPMarketplace *mp = [[BPMarketplace alloc] initWithURI:@"/v1/marketplaces/TEST-MP2autgNHAZxRWZs76RriOze"];

#### Create a card object

    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"123"];

#### Tokenize a card

    BPMarketplace *mp = [[BPMarketplace alloc] initWithURI:@"/v1/marketplaces/TEST-MP2autgNHAZxRWZs76RriOze"];
    NSError *error;
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" withExperationMonth:@"8" withExperationYear:@"2025" withSecurityCode:@"123"];
    NSDictionary *response = [Balanced tokenizeCard:card forMarketplace:mp error:&error];
    
    if (!error) {
        NSLog(@"%@", response);
    }
    else {
        NSLog(@"%@", [error description]);
    }


## Contributing

#### Requirements
The balanced-ios project builds a static iOS framework. The ability to create and build such frameworks has disappeared from recent Xcode 4 versions. To restore this functionality, which is required for working on balanced-ios, do the following:

    git clone git@github.com:kstenerud/iOS-Universal-Framework.git
    cd iOS-Universal-Framework/Real\ Framework
    ./install.sh

Specify the path to your version of Xcode. Answer yes to all prompts. Relaunch Xcode. This adds back the necessary Xcode templates.

#### Tests

Please include tests with all new code. Also, all existing tests must pass before new code can be merged.
