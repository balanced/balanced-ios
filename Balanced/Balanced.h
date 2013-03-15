//
//  Balanced.h
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
//

#import <Foundation/Foundation.h>
#import "BPCard.h"
#import "BPBankAccount.h"

@interface Balanced : NSObject {
@private
    NSString *marketplaceURI;
}

- (id)initWithMarketplaceURI:(NSString *)uri;

- (NSDictionary *)tokenizeCard:(BPCard *)card error:(NSError **)error;
- (NSDictionary *)tokenizeBankAccount:(BPBankAccount *)bankAccount error:(NSError **)error;

@end
