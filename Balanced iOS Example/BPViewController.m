//
//  BPViewController.m
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/13/13.
//  Copyright (c) 2013 Ben Mills. All rights reserved.
//

#import "BPViewController.h"
#import <Balanced/Balanced.h>

@interface BPViewController ()

@end

@implementation BPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error;
    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP2autgNHAZxRWZs76RriOze"];
    BPCard *card = [[BPCard alloc] initWithNumber:@"4111111111111111" expirationMonth:8 expirationYear:2025 securityCode:@"123"];
    NSDictionary *response = [balanced tokenizeCard:card error:&error];
    
    if (!error) {
        NSLog(@"%@", response);
    }
    else {
        NSLog(@"%@", [error description]);
    }
    
    error = NULL;
    
    balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP2autgNHAZxRWZs76RriOze"];
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:@"053101273" andAccountNumber:@"111111111111" andAccountType:@"checking" andName:@"Johann Bernoulli"];
    response = [balanced tokenizeBankAccount:ba error:&error];
    
    if (!error) {
        NSLog(@"%@", response);
    }
    else {
        NSLog(@"%@", [error description]);
    }
}

@end
