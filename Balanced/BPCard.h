//
//  BPCard.h
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
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
 andExperationMonth:(NSString *)expMonth
  andExperationYear:(NSString *)expYear
    andSecurityCode:(NSString *)code;

- (id)initWithNumber:(NSString *)cardNumber
 andExperationMonth:(NSString *)expMonth
  andExperationYear:(NSString *)expYear
    andSecurityCode:(NSString *)code
  andOptionalFields:(NSDictionary *)optParams;

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
