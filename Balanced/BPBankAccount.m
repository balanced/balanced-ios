//
//  BPBankAccount.m
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
//

#import "BPBankAccount.h"

@implementation BPBankAccount
@synthesize errors;

- (id)initWithRoutingNumber:(NSString *)routingNum andAccountNumber:(NSString *)acctNum andAccountType:(NSString *)acctType andName:(NSString *)acctName {
    return [self initWithRoutingNumber:routingNum andAccountNumber:acctNum andAccountType:acctType andName:acctName andOptionalFields:NULL];
}
- (id)initWithRoutingNumber:(NSString *)routingNum andAccountNumber:(NSString *)acctNum andAccountType:(NSString *)acctType andName:(NSString *)acctName andOptionalFields:(NSDictionary *)optParams {
    self = [super init];
    if (self) {
        routingNumber = [routingNum stringByReplacingOccurrencesOfString:@"\\D"
                                                       withString:@""
                                                          options:NSRegularExpressionSearch
                                                            range:NSMakeRange(0, routingNum.length)];
        accountNumber = [acctNum stringByReplacingOccurrencesOfString:@"\\D"
                                                               withString:@""
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, acctNum.length)];
        accountType = [acctType lowercaseString];
        name = acctName;
        optionalFields = optParams;
        self.errors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)routingNumberValid {
    if (routingNumber == nil) { return false; }
    if (routingNumber.length != 9) { return false; }
    
    NSMutableArray *digits = [[NSMutableArray alloc] initWithCapacity:routingNumber.length];
    for (int i = 0; i < routingNumber.length; i++) {
        [digits addObject:[NSNumber numberWithInt:[[routingNumber substringWithRange:NSMakeRange(i, 1)] intValue]]];
    }
    
    return (7 * ([digits[0] intValue] + [digits[3] intValue] + [digits[6] intValue]) +
            3 * ([digits[1] intValue] + [digits[4] intValue] + [digits[7] intValue]) +
            9 * ([digits[2] intValue] + [digits[5] intValue])
            ) % 10;
}

- (BOOL)accountTypeValid {
    return [accountType isEqualToString:@"checking"] ||
            [accountType isEqualToString:@"savings"];
}

- (BOOL)nameValid {
    return name.length > 0;
}

- (BOOL)valid {
    BOOL valid = true;
    
    if (![self routingNumberValid]) {
        [errors addObject:@"Routing number is not valid"];
        valid = false;
    }
    
    if (![self accountTypeValid]) {
        [errors addObject:@"Account type must be \"checking\" or \"savings\""];
        valid = false;
    }
    
    if (![self nameValid]) {
        [errors addObject:@"Account name should not be blank"];
        valid = false;
    }
    if (errors.count > 0) {
        NSLog(@"%@", errors);
    }
    
    return valid;
}

- (NSString *)routingNumber {
    return routingNumber;
}
- (NSString *)accountNumber {
    return accountNumber;
}
- (NSString *)accountType {
    return accountType;
}
- (NSString *)name {
    return name;
}

- (NSDictionary *)optionalFields {
    return optionalFields;
}

@end
