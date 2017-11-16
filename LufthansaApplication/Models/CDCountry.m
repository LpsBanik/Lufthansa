//
//  CDCountry.m
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/7/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import "CDCountry.h"

@implementation CDCountry

@dynamic countryName;
@dynamic countryCode;


@end



/*
 ...
 "Names": {
 "Name": {
 "$": "Andorra"
 }
 }
 ....
 */




/*
 Request URI
 https://api.lufthansa.com/v1/references/countries/?lang=EN&limit=50&offset=0
 Request HeadersSelect content
 Accept: application/json
 Authorization: Bearer ck5hdn9tv5tzhcvuys3w9f54 Access Token:
 X-Originating-Ip: 86.57.133.212
 Response StatusSelect content
 200 OK
 Response HeadersSelect content
 Content-Type: application/json; charset=UTF-8
 Date: Thu, 02 Nov 2017 15:38:02 GMT
 Server: Apache
 X-Mashery-Message-Id: 88fba12d-f914-4a21-b136-4540fd8dc766
 X-Mashery-Responder: prod-j-worker-eu-west-1c-58.mashery.com
 Content-Length: 5305
 Connection: keep-alive
 
 
 */

