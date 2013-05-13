//
//  Balanced.m
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
//

#import "Balanced.h"
#import "BPUtilities.h"

#define API_URL @"https://js.balancedpayments.com"

@interface Balanced()
@property (nonatomic, strong) NSString *marketplaceURI;
@end

@implementation Balanced

- (id)initWithMarketplaceURI:(NSString *)uri {
    self = [super init];
    if (self) {
        [self setMarketplaceURI:uri];
    }
    return self;
}

- (void) tokenizeCard:(BPCard *)card onSuccess:(BalancedTokenizeResponseBlock)successBlock onError:(BalancedErrorBlock)errorBlock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/cards", API_URL, self.marketplaceURI]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    __block NSURLResponse *response;
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"application/json", @"accept",
                             @"application/x-www-form-urlencoded charset=utf-8", @"Content-Type",
                             [BPUtilities userAgentString], @"User-Agent", nil];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
    NSDictionary *params = @{
                            @"card_number":card.number,
                            @"expiration_month":[NSString stringWithFormat:@"%i",card.expirationMonth],
                            @"expiration_year":[NSString stringWithFormat:@"%i",card.expirationYear],
                            @"security_code":card.securityCode,
                            @"system_timezone":[NSNumber numberWithInt:[BPUtilities getTimezoneOffset]],
                            @"language":[[[NSLocale currentLocale] localeIdentifier] stringByReplacingOccurrencesOfString:@"_" withString:@"-"]
                             };
    
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


- (void) tokenizeBankAccount:(BPBankAccount *)bankAccount onSuccess:(BalancedTokenizeResponseBlock)successBlock onError:(BalancedErrorBlock)errorBlock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/bank_accounts", API_URL, self.marketplaceURI]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    __block NSURLResponse *response;
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"application/json", @"accept",
                             @"application/x-www-form-urlencoded charset=utf-8", @"Content-Type",
                             [BPUtilities userAgentString], @"User-Agent", nil];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
    NSAssert(bankAccount.accountType!=BPBankAccountTypeUnknown, @"bank account type cannot be unkonwn");
    
    NSString *accountTypeString;
    switch (bankAccount.accountType) {
        case BPBankAccountTypeChecking:
            accountTypeString = @"Checking";
            break;
        case BPBankAccountTypeSavings:
            accountTypeString = @"Savings";
        default:
            break;
    }
    NSDictionary *params = @{
        @"routing_number":bankAccount.routingNumber,
        @"account_number":bankAccount.accountNumber,
        @"type":accountTypeString,
        @"name":bankAccount.name,
        @"system_timezone":[NSNumber numberWithInt:[BPUtilities getTimezoneOffset]],
        @"language":[[[NSLocale currentLocale] localeIdentifier] stringByReplacingOccurrencesOfString:@"_" withString:@"-"]
    };
    NSString *requestBody = [BPUtilities queryStringFromParameters:params];
    if ([bankAccount optionalFields] != NULL && [[bankAccount optionalFields] count] > 0) {
        requestBody = [requestBody stringByAppendingString:[BPUtilities queryStringFromParameters:[bankAccount optionalFields]]];
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

@end
