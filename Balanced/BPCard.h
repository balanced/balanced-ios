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
    NSDictionary *optionalFields;
}

- (id)initWithNumber:(NSString *)cardNumber
 withExperationMonth:(NSString *)expMonth
  withExperationYear:(NSString *)expYear
    withSecurityCode:(NSString *)code;

- (id)initWithNumber:(NSString *)cardNumber
 withExperationMonth:(NSString *)expMonth
  withExperationYear:(NSString *)expYear
    withSecurityCode:(NSString *)code
  withOptionalFields:(NSDictionary *)optParams;

- (NSString *)number;
- (NSString *)expirationMonth;
- (NSString *)expirationYear;
- (NSString *)type;
- (NSDictionary *)optionalFields;
- (BOOL)valid;
- (BOOL)numberValid;
- (BOOL)securityCodeValid;
- (BOOL)expired;

@property (nonatomic, strong) NSMutableArray *errors;

@end
