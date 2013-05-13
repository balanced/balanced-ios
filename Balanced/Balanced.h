//
//  Balanced.h
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
//

#import <Foundation/Foundation.h>
#import "BPCard.h"
#import "BPBankAccount.h"

__unused static NSString *BalancedResponseBrandKey = @"brand";
__unused static NSString *BalancedResponseCardTypeKey = @"card_type";
__unused static NSString *BalancedResponseHashKey = @"hash";
__unused static NSString *BalancedResponseIdKey = @"id";
__unused static NSString *BalancedResponseIsValidKey = @"is_valid";
__unused static NSString *BalancedResponseUriKey = @"uri";

typedef void (^BalancedTokenizeResponseBlock)(NSDictionary *responseParams);
typedef void (^BalancedErrorBlock)(NSError *error);

@interface Balanced : NSObject
- (id) initWithMarketplaceURI:(NSString *)uri;
- (void) tokenizeCard:(BPCard *)card onSuccess:(BalancedTokenizeResponseBlock)successBlock onError:(BalancedErrorBlock)errorBlock;
- (void) tokenizeBankAccount:(BPBankAccount *)bankAccount onSuccess:(BalancedTokenizeResponseBlock)successBlock onError:(BalancedErrorBlock)errorBlock;
@end
