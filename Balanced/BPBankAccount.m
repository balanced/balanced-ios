//
//  BPBankAccount.m
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
//

#import "BPBankAccount.h"

@implementation BPBankAccount
@synthesize errors;

- (id)initWithRoutingNumber:(NSString *)routingNumber accountNumber:(NSString *)accountNumber accountType:(BPBankAccountType)accountType name:(NSString *)name {
    return [self initWithRoutingNumber:routingNumber accountNumber:accountNumber accountType:accountType name:name optionalFields:nil];
}
- (id)initWithRoutingNumber:(NSString *)routingNumber accountNumber:(NSString *)accountNumber accountType:(BPBankAccountType)accountType name:(NSString *)name optionalFields:(NSDictionary *)optionalFields {
    self = [super init];
    if (self) {
        [self setRoutingNumber:routingNumber];
        [self setAccountNumber:accountNumber];
        [self setAccountType:accountType];
        [self setName:name];
        [self setOptionalFields:optionalFields];
        [self setErrors:[NSMutableArray array]];
    }
    return self;
}

- (BOOL) getRoutingNumberValid {
    if (self.routingNumber==nil) { return false; }
    
    if (self.routingNumber.length != 9) { return false; }
    
    NSMutableArray *digits = [[NSMutableArray alloc] initWithCapacity:self.routingNumber.length];
    for (int i = 0; i < self.routingNumber.length; i++) {
        [digits addObject:[NSNumber numberWithInt:[[self.routingNumber substringWithRange:NSMakeRange(i, 1)] intValue]]];
    }
    
    return (7 * ([digits[0] intValue] + [digits[3] intValue] + [digits[6] intValue]) +
            3 * ([digits[1] intValue] + [digits[4] intValue] + [digits[7] intValue]) +
            9 * ([digits[2] intValue] + [digits[5] intValue])
            ) % 10;
}

- (BOOL) getAccountTypeValid {
    return (self.accountType==BPBankAccountTypeChecking || self.accountType==BPBankAccountTypeSavings);
}

- (BOOL) getNameValid {
    return self.name.length > 0;
}

- (BOOL) getValid {
    BOOL valid = true;
    
    if (!self.routingNumberValid) {
        [errors addObject:@"Routing number is not valid"];
        valid = false;
    }
    
    if (!self.accountTypeValid) {
        [errors addObject:@"Account type must be \"checking\" or \"savings\""];
        valid = false;
    }
    
    if (!self.nameValid) {
        [errors addObject:@"Account name should not be blank"];
        valid = false;
    }
    if (self.errors.count > 0) {
        NSLog(@"%@", errors);
    }
    
    return valid;
}

@end
