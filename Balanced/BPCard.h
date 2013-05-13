//
//  BPCard.h
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
//

#import <Foundation/Foundation.h>

__unused static NSString const *BPCardOptionalParamNameKey = @"name";
__unused static NSString const *BPCardOptionalParamStreetAddressKey = @"street_address";
__unused static NSString const *BPCardOptionalParamPhoneNumberKey = @"phone_number";
__unused static NSString const *BPCardOptionalParamPostalCodeKey = @"postal_code";
__unused static NSString const *BPCardOptionalParamCityKey = @"city";
__unused static NSString const *BPCardOptionalParamCountryCodeKey = @"country_code";
__unused static NSString const *BPCardOptionalParamMetaKey = @"meta";
__unused static NSString const *BPCardOptionalParamStateKey = @"state";

typedef NS_ENUM(NSUInteger, BPCardType)
{
    BPCardTypeUnknown,
    BPCardTypeVisa,
    BPCardTypeMastercard,
    BPCardTypeAmericanExpress,
    BPCardTypeDiscover
};

@interface BPCard : NSObject

- (id)initWithNumber:(NSString *)cardNumber
 expirationMonth:(NSUInteger)expirationMonth
  expirationYear:(NSUInteger)expirationYear
    securityCode:(NSString *)securityCode;

- (id)initWithNumber:(NSString *)cardNumber
 expirationMonth:(NSUInteger)expirationMonth
  expirationYear:(NSUInteger)expirationYear
    securityCode:(NSString *)securityCode
  optionalFields:(NSDictionary *)optionalFields;

@property (nonatomic, assign, readonly, getter=getType) BPCardType type;
@property (nonatomic, assign, readonly, getter=getValid) BOOL valid;
@property (nonatomic, assign, readonly, getter=getNumberValid) BOOL numberValid;
@property (nonatomic, assign, readonly, getter=getSecurityCodeValid) BOOL securityCodeValid;
@property (nonatomic, assign, readonly, getter=getExpired) BOOL expired;
@property (nonatomic, assign) NSUInteger expirationMonth;
@property (nonatomic, assign) NSUInteger expirationYear;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSDictionary *optionalFields;
@property (nonatomic, strong) NSString *securityCode;
@property (nonatomic, strong) NSMutableArray *errors;

@end
