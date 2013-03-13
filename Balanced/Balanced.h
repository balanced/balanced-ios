//
//  Balanced.h
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
//  Copyright (c) 2013 Unfiniti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPCard.h"
#import "BPBankAccount.h"
#import "BPMarketplace.h"

@interface Balanced : NSObject

+ (NSDictionary *)tokenizeCard:(BPCard *)card forMarketplace:(BPMarketplace *)marketplace error:(NSError **)error;
+ (NSDictionary *)addBankAccount:(BPCard *)card toAccount:(NSString *)accountURI error:(NSError *)error;

+ (NSString *)queryStringFromParameters:(NSDictionary *)params;
+ (int)getTimezoneOffset;
+ (NSString *)getMACAddress;
+ (NSString *)getIPAddress;
+ (NSString *)userAgentString;

@end
