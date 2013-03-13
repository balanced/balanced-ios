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
}

@end
