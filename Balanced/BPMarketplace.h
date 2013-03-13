//
//  BPMarketplace.h
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/12/13.
//  Copyright (c) 2013 Unfiniti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BPMarketplace : NSObject

- (id)initWithURI:(NSString *)_uri;

@property (nonatomic, strong) NSString *uri;

@end
