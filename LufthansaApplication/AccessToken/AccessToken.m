//
//  AccessToken.m
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/5/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import "AccessToken.h"

@implementation AccessToken

- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        self.access_token = [responseObject objectForKey: @"access_token"];
        self.token_type = [responseObject objectForKey: @"token_type"]	;
        self.expires_in = [[responseObject objectForKey:@"expires_in"] integerValue] ;
    }
    return self;
}

@end
