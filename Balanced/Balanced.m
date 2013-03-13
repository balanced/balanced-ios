//
//  Balanced.m
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
//  Copyright (c) 2013 Unfiniti. All rights reserved.
//

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#import "Balanced.h"

#define BALANCED_IOS_VERSION 0.1
#define API_URL @"https://js.balancedpayments.com"

@implementation Balanced

+ (NSDictionary *)tokenizeCard:(BPCard *)card forMarketplace:(BPMarketplace *)marketplace error:(NSError **)error {
    NSError *tokenizeError;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/cards", API_URL, marketplace.uri]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"application/json", @"accept",
                             @"application/x-www-form-urlencoded charset=utf-8", @"Content-Type",
                             [self userAgentString], @"User-Agent", nil];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    NSMutableDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [card number], @"card_number",
                            [card expirationMonth], @"expiration_month",
                            [card expirationYear], @"expiration_year",
                            [NSNumber numberWithInt:[self getTimezoneOffset]], @"system_timezone",
                            [[[NSLocale currentLocale] localeIdentifier] stringByReplacingOccurrencesOfString:@"_" withString:@"-"], @"language",
                            nil];
    NSString *requestBody = [self queryStringFromParameters:params];
    if ([card optionalFields] != NULL && [[card optionalFields] count] > 0) {
        requestBody = [requestBody stringByAppendingString:[self queryStringFromParameters:[card optionalFields]]];
    }
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&tokenizeError];
    
    if (tokenizeError == nil) {
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&tokenizeError];
        if (tokenizeError == nil) {
            return responseJSON;
        }
        *error = tokenizeError;
        return nil;
    }
    else {
        *error = tokenizeError;
    }
    
    return nil;
}

+ (NSDictionary *)addBankAccount:(BPCard *)card toAccount:(NSString *)accountURI error:(NSError *)error {
    return nil;
}

#pragma mark - Utility Methods

+ (NSString *)queryStringFromParameters:(NSDictionary *)params {
    __block NSString *queryString = @"";
    
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        queryString = [queryString stringByAppendingFormat:@"&%@=%@", key, obj];
    }];
    
    return queryString;
}

+ (NSString *)userAgentString {
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *model = [currentDevice model];
    NSString *systemVersion = [currentDevice systemVersion];
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSString *carrier = [[networkInfo subscriberCellularProvider] carrierName];
    
    return [NSString stringWithFormat:@"Balanced iOS %0.1f - %@ %@ %@ %@ %@ %@",
                        BALANCED_IOS_VERSION,
                        [currentDevice name],
                        model,
                        systemVersion,
                        [self getIPAddress],
                        [self getMACAddress],
                        carrier.length > 1 ? carrier : @"Wi-Fi"];
}

+ (int)getTimezoneOffset {
    return [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]] / 3600;
}

+ (NSString *)getMACAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    NSString            *errorFlag = NULL;
    size_t              length;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    // Get the size of the data available (store in len)
    else if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
        errorFlag = @"sysctl mgmtInfoBase failure";
    // Alloc memory based on above call
    else if ((msgBuffer = malloc(length)) == NULL)
        errorFlag = @"buffer allocation failure";
    // Get system information, store in buffer
    else if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
    {
        free(msgBuffer);
        errorFlag = @"sysctl msgBuffer failure";
    }
    else
    {
        // Map msgbuffer to interface message structure
        struct if_msghdr *interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
        
        // Map to link-level socket structure
        struct sockaddr_dl *socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
        
        // Copy link layer address data in socket structure to an array
        unsigned char macAddress[6];
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        
        // Read from char array into a string object, into traditional Mac address format
        NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                      macAddress[0], macAddress[1], macAddress[2], macAddress[3], macAddress[4], macAddress[5]];
        
        // Release the buffer memory
        free(msgBuffer);
        
        return macAddressString;
    }
    
    // Error...
    NSLog(@"Error: %@", errorFlag);
    
    return nil;
}

+ (NSString *)getIPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                
                if([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                }
                else {
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : nil;
}

@end
