//
//  Balanced.m
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
//

#import "Balanced.h"
#import "BPUtilities.h"

#define API_URL @"https://js.balancedpayments.com"

@implementation Balanced

- (id)initWithMarketplaceURI:(NSString *)uri {
    self = [super init];
    if (self) {
        marketplaceURI = uri;
    }
    return self;
}

- (void) tokenizeCard:(BPCard *)card onSuccess:(BalancedTokenizeCardResponseBlock)successBlock onError:(BalancedErrorBlock)errorBlock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/cards", API_URL, marketplaceURI]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    __block NSURLResponse *response;
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"application/json", @"accept",
                             @"application/x-www-form-urlencoded charset=utf-8", @"Content-Type",
                             [BPUtilities userAgentString], @"User-Agent", nil];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [card number], @"card_number",
                            [card expirationMonth], @"expiration_month",
                            [card expirationYear], @"expiration_year",
                            [NSNumber numberWithInt:[BPUtilities getTimezoneOffset]], @"system_timezone",
                            [[[NSLocale currentLocale] localeIdentifier] stringByReplacingOccurrencesOfString:@"_" withString:@"-"], @"language",
                            nil];
    if(card.securityCode!=nil)
    {
        [params setValue:card.securityCode forKey:@"security_code"];
    }
    NSString *requestBody = [BPUtilities queryStringFromParameters:params];
    if ([card optionalFields] != NULL && [[card optionalFields] count] > 0) {
        requestBody = [requestBody stringByAppendingString:[BPUtilities queryStringFromParameters:[card optionalFields]]];
    }
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    
    __block NSError *tokenizeError;
    __block NSData *responseData;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&tokenizeError];
        if (tokenizeError == nil) {
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&tokenizeError];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (tokenizeError == nil) {
                    successBlock(responseJSON);
                }else
                {
                    errorBlock(tokenizeError);
                }
            }];
        }
        else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                errorBlock(tokenizeError);
            }];
        }
    }];
}


- (NSDictionary *)tokenizeBankAccount:(BPBankAccount *)bankAccount error:(NSError **)error {
    NSError *tokenizeError;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/bank_accounts", API_URL, marketplaceURI]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"application/json", @"accept",
                             @"application/x-www-form-urlencoded charset=utf-8", @"Content-Type",
                             [BPUtilities userAgentString], @"User-Agent", nil];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    NSMutableDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [bankAccount routingNumber], @"routing_number",
                                   [bankAccount accountNumber], @"account_number",
                                   [bankAccount accountType], @"type",
                                   [bankAccount name], @"name",
                                   [NSNumber numberWithInt:[BPUtilities getTimezoneOffset]], @"system_timezone",
                                   [[[NSLocale currentLocale] localeIdentifier] stringByReplacingOccurrencesOfString:@"_" withString:@"-"], @"language",
                                   nil];
    NSString *requestBody = [BPUtilities queryStringFromParameters:params];
    if ([bankAccount optionalFields] != NULL && [[bankAccount optionalFields] count] > 0) {
        requestBody = [requestBody stringByAppendingString:[BPUtilities queryStringFromParameters:[bankAccount optionalFields]]];
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

@end
