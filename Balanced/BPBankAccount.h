//
//  BPBankAccount.h
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
//

#import <Foundation/Foundation.h>

@interface BPBankAccount : NSObject {
@private
    NSString *routingNumber;
    NSString *accountNumber;
    NSString *accountType;
    NSString *name;
    NSDictionary *optionalFields;
}

- (id)initWithRoutingNumber:(NSString *)routingNum andAccountNumber:(NSString *)acctNum andAccountType:(NSString *)acctType andName:(NSString *)acctName;
- (id)initWithRoutingNumber:(NSString *)routingNum andAccountNumber:(NSString *)acctNum andAccountType:(NSString *)acctType andName:(NSString *)acctName andOptionalFields:(NSDictionary *)optParams;
- (BOOL)routingNumberValid;
- (BOOL)accountTypeValid;
- (BOOL)nameValid;
- (BOOL)valid;
- (NSString *)routingNumber;
- (NSString *)accountNumber;
- (NSString *)accountType;
- (NSString *)name;
- (NSDictionary *)optionalFields;

@property (nonatomic, strong) NSMutableArray *errors;

@end
