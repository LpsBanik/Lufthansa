//
//  AccessToken.h
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/5/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessToken : NSObject

@property (strong, nonatomic) NSString* access_token;
@property (strong, nonatomic) NSString* token_type;
@property (assign, nonatomic) NSInteger expires_in;

- (id) initWithServerResponse : (NSDictionary *) responseObject;

@end


/*
 Response Structure Definition
 access_token	Your new access token
 token_type	We only use bearer tokens
 expires_in	The number of seconds until this token expires
 */