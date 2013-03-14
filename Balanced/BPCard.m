//
//  BPCard.m
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
//

#import "BPCard.h"

@implementation BPCard
@synthesize errors;

- (id)initWithNumber:(NSString *)cardNumber andExperationMonth:(NSString *)expMonth andExperationYear:(NSString *)expYear andSecurityCode:(NSString *)code {
    return [self initWithNumber:cardNumber andExperationMonth:expMonth andExperationYear:expYear andSecurityCode:code andOptionalFields:NULL];
}

- (id)initWithNumber:(NSString *)cardNumber andExperationMonth:(NSString *)expMonth andExperationYear:(NSString *)expYear andSecurityCode:(NSString *)code andOptionalFields:(NSDictionary *)optParams {
    self = [super init];
    if (self) {
        number = [cardNumber stringByReplacingOccurrencesOfString:@"\\D"
                                                       withString:@""
                                                          options:NSRegularExpressionSearch
                                                            range:NSMakeRange(0, cardNumber.length)];

        expirationMonth = [[expMonth stringByReplacingOccurrencesOfString:@"\\D"
                                                       withString:@""
                                                          options:NSRegularExpressionSearch
                                                            range:NSMakeRange(0, expMonth.length)] integerValue];
        
        expirationYear = [[expYear stringByReplacingOccurrencesOfString:@"\\D"
                                                       withString:@""
                                                          options:NSRegularExpressionSearch
                                                            range:NSMakeRange(0, expYear.length)] integerValue];
        
        securityCode = [code stringByReplacingOccurrencesOfString:@"\\D"
                                                       withString:@""
                                                          options:NSRegularExpressionSearch
                                                            range:NSMakeRange(0, code.length)];

        optionalFields = optParams;

        self.errors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)numberValid {
    if (number == nil) { return false; }
    if ([number length] < 12) { return false; }
    
    BOOL odd = true;
    int total = 0;
    
    for (int i = number.length - 1; i >= 0; i--) {
        int value = [[number substringWithRange:NSMakeRange(i, 1)] intValue];
        total += (odd = !odd) ? 2 * value - (value > 4 ? 9 : 0) : value;
    }

    return (total % 10) == 0;
}

- (BOOL)securityCodeValid {
    if (securityCode == nil) { return false; }
    
    NSString *cardType = [self type];
    if ([cardType isEqualToString:@"Unknown"]) { return false; }
    
    NSUInteger requiredLength = [cardType isEqualToString:@"American Express"] ? 4 : 3;
    
    return [securityCode length] == requiredLength;
}

- (BOOL)expired {
    if (expirationMonth > 12 || expirationYear < 1) { return false; }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentMonth = [components month];
    NSInteger currentYear = [components year];
    
    return currentYear > expirationYear || (currentYear == expirationYear && currentMonth >= expirationMonth);
}

- (BOOL)valid {
    BOOL valid = true;
    
    if (![self numberValid]) {
        [errors addObject:@"Card number is not valid"];
        valid = false;
    }
    
    if ([self expired]) {
        [errors addObject:@"Card is expired"];
        valid = false;
    }
    
    if (![self securityCodeValid]) {
        [errors addObject:@"Security code is not valid"];
        valid = false;
    }
    
    return valid;
}

- (NSString *)type {
    int digits = [[number substringWithRange:NSMakeRange(0, 2)] integerValue];
    
    if (digits >= 40 && digits <= 49) {
        return @"VISA";
    }
    else if (digits >= 50 && digits <= 59) {
        return @"Mastercard";
    }
    else if (digits == 60 || digits == 62 || digits == 64 || digits == 65) {
        return @"Discover Card";
    }
    else if (digits == 34 || digits == 37) {
        return @"American Express";
    }
    else {
        return @"Unknown";
    }
}

- (NSString *)number {
    return number;
}

- (NSString *)expirationMonth {
    return [NSString stringWithFormat:@"%i", expirationMonth];
}

- (NSString *)expirationYear {
    return [NSString stringWithFormat:@"%i", expirationYear];
}

- (NSDictionary *)optionalFields {
    return optionalFields;
}

@end
