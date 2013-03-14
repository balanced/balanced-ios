//
//  BPUtilities.h
//  Balanced
//
//  Created by Ben Mills on 3/14/13.
//

#import <Foundation/Foundation.h>

@interface BPUtilities : NSObject

+ (NSString *)queryStringFromParameters:(NSDictionary *)params;
+ (int)getTimezoneOffset;
+ (NSString *)getMACAddress;
+ (NSString *)getIPAddress;
+ (NSString *)userAgentString;

@end
