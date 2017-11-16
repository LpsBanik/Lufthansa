//
//  Airport.m
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/7/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import "Airport.h"

@implementation Airport

// переопределяем инит для наших аттрибутов
-(id) initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    if (self) {
        self.airportCode = [responseObject
                            objectForKey:@"AirportCode"];
        
        self.airportName = [[[responseObject
                              objectForKey:@"Names"] // для полных имен аэропортов
                             objectForKey:@"Name"]   // для полного имени аэропорта
                            objectForKey:@"$"];
        
        self.cityCode = [responseObject
                         objectForKey:@"CityCode"];
        
        self.countryCode = [responseObject
                            objectForKey:@"CountryCode"];
        
        self.latitude = [[[[responseObject
                            objectForKey:@"Position"]
                           objectForKey:@"Coordinate"]
                          objectForKey:@"Latitude"]doubleValue]; // Decimal latitude.
        
        self.longitude = [[[[responseObject
                             objectForKey:@"Position"]
                            objectForKey:@"Coordinate"]
                           objectForKey:@"Longitude"]doubleValue]; // Decimal longitude.
    }
    return self;
}

@end

/*
 "CityCode": "AIY",
 "CountryCode": "US",
 "LocationType": "Airport",
 "Names": {
 "Name": {
 "@LanguageCode": "en",
 "$": "Atlantic City - International"
 }
 },
 "UtcOffset": -4,
 "TimeZoneId": "America\/New_York"
 }, {
 "AirportCode": "ADA",
 "Position": {
 "Coordinate": {
 "Latitude": 36.98361111,
 "Longitude": 35.28083333
 }
 },
 */


/*
 Request URI
 https://api.lufthansa.com/v1/references/airports/?lang=EN&limit=50&offset=0&LHoperated=0
 Request HeadersSelect content
 Accept: application/json
 Authorization: Bearer ck5hdn9tv5tzhcvuys3w9f54  Access Token:
 X-Originating-Ip: 86.57.133.212
 Response StatusSelect content
 200 OK
 Response HeadersSelect content
 Content-Type: application/json; charset=UTF-8
 Date: Thu, 02 Nov 2017 15:39:49 GMT
 Server: Apache
 X-Mashery-Message-Id: 0b11b0d0-a462-46c1-9624-7aa9ae5b6c62
 X-Mashery-Responder: prod-j-worker-eu-west-1c-64.mashery.com
 Content-Length: 13878
 Connection: keep-alive
 
 */