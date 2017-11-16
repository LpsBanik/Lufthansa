//
//  Country.h
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/2/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Country :  NSObject
@property (retain , nonatomic) NSString *countryName;
@property (retain , nonatomic) NSString *countryCode;

- (id) initWithServerResponse : (NSDictionary *) responseObject;

@end
