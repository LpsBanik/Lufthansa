//
//  City.m
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/7/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import "City.h"

@implementation City

// переопределяем инит для наших аттрибутов
-(id) initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    if (self) {
        
        
        self.cityCode = [responseObject
                         objectForKey:@"CityCode"]; //код для города
        self.cityName = [[[responseObject
                           objectForKey:@"Names"] // для полных имен городов
                          objectForKey:@"Name"]   // для полного имени города
                         objectForKey:@"$"];

        
    }
    return self;
}

@end


/*
 https://api.lufthansa.com/v1/references/cities/?lang=EN&limit=50&offset=0
 Request HeadersSelect content
 Accept: application/json
 Authorization: Bearer ck5hdn9tv5tzhcvuys3w9f54 Access Token:
 X-Originating-Ip: 86.57.133.212
 Response StatusSelect content
 200 OK
 Response HeadersSelect content
 Content-Type: application/json; charset=UTF-8
 Date: Thu, 02 Nov 2017 15:37:23 GMT
 Server: Apache
 X-Mashery-Message-Id: e12e5dc8-e4bf-4b65-9a3a-0accbf7ad815
 X-Mashery-Responder: prod-j-worker-eu-west-1a-56.mashery.com
 Content-Length: 8028
 Connection: keep-alive
 
 */