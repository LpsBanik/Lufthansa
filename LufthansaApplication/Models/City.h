//
//  City.h
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/7/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface City : NSObject

@property (strong , nonatomic) NSString *cityName;
@property (strong , nonatomic) NSString *cityCode;

-(id) initWithServerResponse:(NSDictionary *)responseObject;

@end

