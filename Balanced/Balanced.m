//
//  Balanced.m
//  Balanced iOS
//
//  Created by Ben Mills on 3/9/13.
//

#import "Balanced.h"
#import "BPUtilities.h"

#define API_URL @"api.balancedpayments.com"
#define API_VERSION @"1.1"


#if CL
@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end
#endif

@interface Balanced()
@property (nonatomic, strong) NSString *marketplaceURI;
@end


@implementation Balanced

- (id)init {
    return self = [super init];
}

- (void)createCardWithNumber:(NSString *)number
             expirationMonth:(NSUInteger)expMonth
              expirationYear:(NSUInteger)expYear
                   onSuccess:(BalancedTokenizeResponseBlock)successBlock
                     onError:(BalancedErrorBlock)errorBlock
{

    [self createCardWithNumber:number
                 expirationMonth:expMonth
                  expirationYear:expYear
                       onSuccess:successBlock
                         onError:errorBlock
                  optionalFields:nil];
}

- (void)createCardWithNumber:(NSString *)number
             expirationMonth:(NSUInteger)expMonth
              expirationYear:(NSUInteger)expYear
                   onSuccess:(BalancedTokenizeResponseBlock)successBlock
                     onError:(BalancedErrorBlock)errorBlock
              optionalFields:(NSDictionary *)optionalFields
{
    BPCard *card = [[BPCard alloc] initWithNumber:number expirationMonth:expMonth expirationYear:expYear optionalFields:optionalFields];
    
    if (card.valid) {
        NSMutableDictionary *payload = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        card.number, @"number",
                                        [NSString stringWithFormat:@"%i",(int)card.expirationMonth], @"expiration_month",
                                        [NSString stringWithFormat:@"%i", (int)card.expirationYear], @"expiration_year",
                                        [BPUtilities capabilities], @"meta",
                                        nil];

        if (optionalFields != NULL && [optionalFields count] > 0) {
            [payload addEntriesFromDictionary:optionalFields];
        }

        [self createFundingInstrument:payload type:BPFundingInstrumentTypeCard onSuccess:successBlock onError:errorBlock];
    }
    else {
        errorBlock([NSError errorWithDomain:@"Balanced" code:400 userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:card.errors, @"errors", nil]]);
    }
}

- (void)createBankAccountWithRoutingNumber:(NSString *)routingNumber
                             accountNumber:(NSString *)accountNumber
                               accountType:(BPBankAccountType)accountType
                                      name:(NSString *)name
                                 onSuccess:(BalancedTokenizeResponseBlock)successBlock
                                   onError:(BalancedErrorBlock)errorBlock
{
    [self createBankAccountWithRoutingNumber:routingNumber
                               accountNumber:accountNumber
                                 accountType:accountType
                                        name:name
                                   onSuccess:successBlock
                                     onError:errorBlock
                              optionalFields:nil];
}

- (void)createBankAccountWithRoutingNumber:(NSString *)routingNumber
                             accountNumber:(NSString *)accountNumber
                               accountType:(BPBankAccountType)accountType
                                      name:(NSString *)name
                                 onSuccess:(BalancedTokenizeResponseBlock)successBlock
                                   onError:(BalancedErrorBlock)errorBlock
                            optionalFields:(NSDictionary *)optionalFields
{
    BPBankAccount *bankAccount = [[BPBankAccount alloc] initWithRoutingNumber:routingNumber
                                                                accountNumber:accountNumber
                                                                  accountType:accountType
                                                                         name:name
                                                               optionalFields:optionalFields];
    if (bankAccount.valid) {
        NSString *accountTypeString;
        switch (bankAccount.accountType) {
            case BPBankAccountTypeChecking:
                accountTypeString = @"checking";
                break;
            case BPBankAccountTypeSavings:
                accountTypeString = @"savings";
            default:
                break;
        }
        
        NSMutableDictionary *payload = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        bankAccount.routingNumber, @"routing_number",
                                        bankAccount.accountNumber, @"account_number",
                                        accountTypeString, @"type",
                                        bankAccount.name, @"name",
                                        nil];

        if (optionalFields != NULL && [optionalFields count] > 0) {
            [payload addEntriesFromDictionary:optionalFields];
        }

        [self createFundingInstrument:payload type:BPFundingInstrumentTypeBankAccount onSuccess:successBlock onError:errorBlock];
    }
    else {
        errorBlock([NSError errorWithDomain:@"Balanced" code:400 userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:bankAccount.errors, @"errors", nil]]);
    }
}

- (void)createFundingInstrument:(NSDictionary *)payload
                           type:(BPFundingInstrumentType)type
                      onSuccess:(BalancedTokenizeResponseBlock)successBlock
                        onError:(BalancedErrorBlock)errorBlock {
#if CL
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:API_URL];
#endif
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/%@", API_URL, type == BPFundingInstrumentTypeCard ? @"cards" : @"bank_accounts"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    __block NSHTTPURLResponse *response;
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSString stringWithFormat:@"application/json;revision=%@", API_VERSION], @"Accept",
                             @"application/json", @"Content-Type",
                             [BPUtilities userAgentString], @"User-Agent", nil];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
    NSError *error;
    NSData *payloadData = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody:payloadData];
    
    __block NSError *tokenizeError;
    __block NSData *responseData;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&tokenizeError];
        if (tokenizeError == nil) {
            NSMutableDictionary *tokenResponse = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&tokenizeError];
            [tokenResponse setObject:[NSString stringWithFormat:@"%i", (int)[response statusCode]] forKey:@"status_code"];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (tokenizeError == nil) {
                    successBlock(tokenResponse);
                }
                else {
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
