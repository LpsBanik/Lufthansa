//
//  Airport.h
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/7/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Airport : NSObject

@property (strong , nonatomic) NSString *airportName;
@property (strong , nonatomic) NSString *airportCode;
@property (strong , nonatomic) NSString *countryCode;
@property (strong , nonatomic) NSString *cityCode;
@property (assign , nonatomic) double latitude;
@property (assign , nonatomic) double longitude;

-(id) initWithServerResponse:(NSDictionary *)responseObject;

@end
