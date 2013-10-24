//
//  ViewController.m
//  BalancedExample
//
//  Created by Ben on 7/8/13.
//  Copyright (c) 2013 Balanced. All rights reserved.
//

#import "ViewController.h"
#import "Balanced.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cardNumberDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:tfCardNumber];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tap];
}

- (void)submitCardInfo {
    __block NSDictionary *response;

    NSMutableDictionary *optionalFields = [[NSMutableDictionary alloc] init];

    if ([[tfCVV text] length] >= 3) {
        [optionalFields setObject:[tfCVV text] forKey:BPCardOptionalParamSecurityCodeKey];
    }

    if ([[tfName text] length] > 0) {
        [optionalFields setObject:[tfName text] forKey:BPCardOptionalParamSecurityCodeKey];
    }

    BPCard *card = [[BPCard alloc] initWithNumber:[tfCardNumber text]
                                  expirationMonth:[[tfExpMonth text] integerValue]
                                   expirationYear:[[tfExpYear text] integerValue]
                                   optionalFields:optionalFields];
    
    if (card.valid) {
        Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP2BTDSHT7BYTjxlhdWtXWNN"];
        [balanced tokenizeCard:card onSuccess:^(NSDictionary *responseParams) {
            response = responseParams;
            [tvResponseView setText:[response description]];
            NSLog(@"%@", response);
            
            [self setActivityIndicatorEnabled:NO];
            [self setResetButton];
            tvResponseView.alpha = 0.0;
            [UIView animateWithDuration:0.5 animations:^{
                [tvResponseView setHidden:NO];
                tvResponseView.alpha = 1.0;
            }];
        } onError:^(NSError *error) {
            [tvResponseView setText:[response description]];
            NSLog(@"%@", [error description]);
            
            [self setActivityIndicatorEnabled:NO];
            [self setResetButton];
        }];
    }
    else {
        NSString *errorMessage = @"";
        for (NSString *error in card.errors) {
            errorMessage = [errorMessage stringByAppendingFormat:@"%@\n", error];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
                                                        message:errorMessage
                                                       delegate: nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"%@", card.errors);
        
        [self setActivityIndicatorEnabled:NO];
        [self setSubmitButton];
    }
}

- (void)cardNumberDidChange {
    if ([[tfCardNumber text] length] >= 12) {
        BPCard *card = [[BPCard alloc] initWithNumber:[tfCardNumber text] expirationMonth:8 expirationYear:2025];

        if (card.type != previousCardType) {
            [UIView animateWithDuration:0.75 animations:^{
                [cardImage setAlpha:0.0];
            }];
            
            if (card.type != BPCardTypeUnknown) {
                UIImage *image = nil;
                
                switch (card.type) {
                    case BPCardTypeVisa:
                        image = [UIImage imageNamed:@"visa"];
                        break;
                    case BPCardTypeMastercard:
                        image = [UIImage imageNamed:@"mastercard"];
                        break;
                    case BPCardTypeAmericanExpress:
                        image = [UIImage imageNamed:@"amex"];
                        break;
                    case BPCardTypeDiscover:
                        image = [UIImage imageNamed:@"discover"];
                        break;
                    default:
                        image = nil;
                        break;
                }
                
                [cardImage setImage:image];
                
                [UIView animateWithDuration:0.25 animations:^{
                    [cardImage setAlpha:1.0];
                }];
            }
            else {
                [UIView animateWithDuration:0.25 animations:^{
                    [cardImage setAlpha:0.0];
                }];
            }
            
            previousCardType = card.type;
        }
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            [cardImage setAlpha:0.0];
        }];
        
        previousCardType = -1;
    }
}

- (IBAction)performOperation:(id)sender {
    [self.view endEditing:YES];
    
    if ([btnPerformOperation.titleLabel.text isEqualToString:@"Submit"]) {
        [self setActivityIndicatorEnabled:YES];
        [self submitCardInfo];
    }
    else {
        [self resetForm];
        [self setSubmitButton];
    }
}

- (void)resetForm {
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            [(UITextField*)view setText:@""];
        }
    }
    [tvResponseView setHidden:YES];
    [tvResponseView setAlpha:0.0];
    [cardImage setImage:nil];
}

- (void)setSubmitButton {
    [btnPerformOperation setBackgroundColor:[UIColor colorWithRed:0.425 green:0.425 blue:0.425 alpha:1.000]];
    [btnPerformOperation setTitle:@"Submit" forState:UIControlStateNormal];
}

- (void)setResetButton {
    [btnPerformOperation setBackgroundColor:[UIColor colorWithRed:0.560 green:0.425 blue:0.425 alpha:1.000]];
    [btnPerformOperation setTitle:@"Reset" forState:UIControlStateNormal];
}

- (void)setActivityIndicatorEnabled:(BOOL)enabled {
    if (enabled) {
        [btnPerformOperation setHidden:YES];
        [loadingIndicator startAnimating];
        [loadingIndicator setHidden:NO];
    }
    else {
        [btnPerformOperation setHidden:NO];
        [loadingIndicator startAnimating];
        [loadingIndicator setHidden:NO];
    }
}
@end
