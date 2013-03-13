//
//  BPCard.h
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
//  Copyright (c) 2013 Unfiniti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BPCard : NSObject {
@private
    NSUInteger expirationMonth;
    NSUInteger expirationYear;
    NSString *securityCode;
    NSString *number;
    
}

- (BPCard *)initWithNumber:(NSString *)cardNumber
       withExperationMonth:(NSString *)expMonth
        withExperationYear:(NSString *)expYear
          withSecurityCode:(NSString *)code;
- (NSString *)number;
- (NSString *)expirationMonth;
- (NSString *)expirationYear;
- (NSString *)type;
- (BOOL)valid;
- (BOOL)numberValid;
- (BOOL)securityCodeValid;
- (BOOL)expired;

@property (nonatomic, strong) NSMutableArray *errors;

@end
