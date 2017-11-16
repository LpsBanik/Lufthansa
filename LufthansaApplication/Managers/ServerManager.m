//
//  ServerManager.m
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/4/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "Country.h"
#import "City.h"
#import "Airport.h"
#import "AccessToken.h"

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager* sessionManager;
@property (strong, nonatomic) AccessToken* accessToken;

@end

@implementation ServerManager

static NSString* base_URL = @"https://api.lufthansa.com/v1/";
static NSString* client_ID = @"2gj9ctjatg5kgvfhtfnz4kf4";
static NSString* client_Secret = @"Uw8fjkmtQt";
static NSString* grant_Type = @"client_credentials";

+(ServerManager *) sharedManager {
    
    static ServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL* url = [NSURL URLWithString: base_URL];
        
        self.sessionManager = [[AFHTTPSessionManager manager] initWithBaseURL:url];
        
        if ([[AFNetworkReachabilityManager sharedManager] isReachable]){
             [self getAccessTokenFromServer];
        }
    }
    return self;
}

-(void) getAccessTokenFromServer {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            client_ID,      @"client_id",
                            client_Secret,  @"client_secret",
                            grant_Type,     @"grant_type", nil];
   
        [self.sessionManager POST:@"oauth/token"
                   parameters:params
                     progress:^(NSProgress * _Nonnull uploadProgress) {}
                      success:^(NSURLSessionDataTask * task, NSDictionary* responseObject) {
                          
                          AccessToken* accessToken =[[AccessToken alloc]initWithServerResponse:responseObject];
                          self.accessToken = accessToken;
                          
                      }
                      failure:^(NSURLSessionDataTask* task, NSError* error) {
                          
                          NSHTTPURLResponse* response = error.userInfo[AFNetworkingOperationFailingURLRequestErrorKey];
                          NSLog(@"%@%ld",error , (long)response.statusCode);
                      }];
   
    }

-(void) getCountriesWithOffset:(NSInteger) offset
                      language:(NSString *) lang
                         limit:(NSInteger) limit
                     onSuccess:(void(^)(NSArray *)) success
                     onFailure:(void(^)(NSError *error , NSInteger )) failure {
    
    if(self.accessToken == nil && [[AFNetworkReachabilityManager sharedManager]isReachable])
        [self getAccessTokenFromServer];
    
    NSLog(@"MY TOKEN = %@",self.accessToken.access_token);
   
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.sessionManager.requestSerializer
                                setValue:@"application/json"
                      forHTTPHeaderField:@"Accept:"];
    [self.sessionManager.requestSerializer
                                setValue:[NSString stringWithFormat:@"Bearer %@",self.accessToken.access_token]
                      forHTTPHeaderField:@"Authorization"];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    lang,       @"lang",
                                                    @(limit),   @"limit",
                                                    @(offset),  @"offset", nil];
    
    [self.sessionManager GET:@"references/countries/"
                  parameters:params
                    progress:^(NSProgress * _Nonnull downloadProgress) {}
                     success:^(NSURLSessionTask* task, NSDictionary* responseObject) {
                        
                        // NSLog(@"JSON: %@", responseObject);
                         
                         NSArray* dictsArray = [[[responseObject objectForKey:@"CountryResource"]
                                                                 objectForKey:@"Countries"]
                                                                 objectForKey:@"Country"];
                         
                         NSMutableArray* objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dict in dictsArray) {
                             Country* country = [[Country alloc] initWithServerResponse:dict];
                             [objectsArray addObject:country];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }

                     } failure:^(NSURLSessionDataTask* operation, NSError*  error) {
                         NSHTTPURLResponse* response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                         
                         if (failure) {
                             failure(error, response.statusCode);
                         }
                     }];
}

-(void) getCitiesWithOffset:(NSInteger) offset
                   language:(NSString *) lang
                      limit:(NSInteger) limit
                  onSuccess:(void(^)(NSArray *)) success
                  onFailure:(void(^)(NSError *error , NSInteger)) failure {
   
    if(self.accessToken == nil && [[AFNetworkReachabilityManager sharedManager]isReachable])
        [self getAccessTokenFromServer];
    
        NSLog(@"MY TOKEN = %@",self.accessToken.access_token);
        
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.sessionManager.requestSerializer
                                setValue:@"application/json"
                      forHTTPHeaderField:@"Accept:"];
    
    [self.sessionManager.requestSerializer
                                setValue:[NSString stringWithFormat:@"Bearer %@",self.accessToken.access_token]
                      forHTTPHeaderField:@"Authorization"];

    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                             lang,       @"lang",
                             @(limit),   @"limit",
                             @(offset),  @"offset", nil];
    
    [self.sessionManager GET:@"references/cities/"
                  parameters:params
                    progress:^(NSProgress * _Nonnull downloadProgress) {}
                     success:^(NSURLSessionDataTask* task,NSDictionary* responseObject) {
                         
                         NSArray* dictsArray = [[[responseObject objectForKey:@"CityResource"]
                                                                 objectForKey:@"Cities"]
                                                                 objectForKey:@"City"];
                         
                         NSMutableArray* objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dict in dictsArray) {
                             City* city = [[City alloc] initWithServerResponse:dict];
                             [objectsArray addObject:city];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                         
                     } failure:^(NSURLSessionDataTask* operation , NSError*  error) {
                         NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                         
                         if (failure) {
                             failure(error, response.statusCode);
                         }
                     }];
}

-(void) getAirportsWithOffset:(NSInteger) offset
                     language:(NSString *) lang
                        limit:(NSInteger) limit
                    onSuccess:(void(^)(NSArray *)) success
                    onFailure:(void(^)(NSError *error , NSInteger)) failure {
    
    if(self.accessToken == nil && [[AFNetworkReachabilityManager sharedManager]isReachable]){}
        
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            lang,       @"lang",
                            @(limit),   @"limit",
                            @(offset),  @"offset", nil];
    
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.sessionManager.requestSerializer
                                setValue:@"application/json"
                      forHTTPHeaderField:@"Accept:"];
    [self.sessionManager.requestSerializer
                                setValue:[NSString stringWithFormat:@"Bearer %@",self.accessToken.access_token]
                      forHTTPHeaderField:@"Authorization"];

    [self.sessionManager GET:@"references/airports/"
                  parameters:params
                    progress:^(NSProgress * _Nonnull downloadProgress) {}
                     success:^(NSURLSessionDataTask*  task, NSDictionary* responseObject) {
                         
                         NSArray* dictsArray = [[[responseObject objectForKey:@"AirportResource"]
                                                                 objectForKey:@"Airports"]
                                                                 objectForKey:@"Airport"];
                         
                         NSMutableArray* objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dict in dictsArray) {
                             Airport* airport = [[Airport alloc] initWithServerResponse:dict];
                             [objectsArray addObject:airport];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                         
                     } failure:^(NSURLSessionDataTask *  operstion, NSError * _Nonnull error) {
                         NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                         
                         if (failure) {
                             failure(error, response.statusCode);
                         }
                     }];
}

-(void) getNearestAirportsWithCoordinatesLatitude:(double)latitude
                                        longitude:(double)longitude
                                         language:(NSString *)lang
                                        onSuccess:(void (^)(NSArray *))success
                                        onFailure:(void (^)(NSError *, NSInteger))failure {
   
    if(self.accessToken == nil && [[AFNetworkReachabilityManager sharedManager]isReachable]) {}
        
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            lang,          @"lang",
                            @(latitude),   @"latitude",
                            @(longitude),  @"longitude", nil];

    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.sessionManager.requestSerializer
                                setValue:@"application/json"
                      forHTTPHeaderField:@"Accept:"];
    
    [self.sessionManager.requestSerializer
                                setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken.access_token]
                      forHTTPHeaderField:@"Authorization"];
    
    NSString* coordinateURL = [NSString stringWithFormat:@"references/airports/nearest/%f,%f", latitude, longitude];
    
    [self.sessionManager GET: coordinateURL
                  parameters:params
                    progress:^(NSProgress * _Nonnull downloadProgress) {}
                     success:^(NSURLSessionTask *  task, NSDictionary* responseObject) {
                         
                         NSArray* dictsArray = [[[responseObject objectForKey:@"NearestAirportResource"]
                                                                 objectForKey:@"Airports" ]
                                                                 objectForKey:@"Airport"];
                         
                         NSMutableArray* objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dict in dictsArray) {
                             Airport* airport = [[Airport alloc] initWithServerResponse:dict];
                             [objectsArray addObject:airport];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                         
                     } failure:^(NSURLSessionDataTask*  operation, NSError*  error) {
                         NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                         
                         if (failure) {
                             failure(error, response.statusCode);
                         }
                     }];
}

@end


/*
 https://developer.lufthansa.com/docs/read/api_basics/Getting_Started
 Access to our services is controlled via tokens (Oauth 2.0). To get a token you must call our token end-point and supply your client key and client secret. Tokens remain valid for a limited time.
 
 Request URI
 POST https://api.lufthansa.com/v1/oauth/token
 Content-Type: application/x-www-form-urlencoded
 POST Parameter	Value
 client_id	Your client application key
 client_secret	Your client secret
 grant_type	"client_credentials"
 Request Example
 curl "https://api.lufthansa.com/v1/oauth/token" -X POST -d "client_id=28fu8yg7tx35qkqnc6jg96fy" -d "client_secret=6jc9Zj9PE2" -d "grant_type=client_credentials"
 Response Structure Definition
 access_token	Your new access token
 token_type	We only use bearer tokens
 expires_in	The number of seconds until this token expires
 Response Example
 {"access_token":"d8bmzggu72dy69tzkffe6vaa","token_type":"bearer","expires_in":21600}
 Note that we respond with token_type "bearer" (lower case b) yet when you send us a token it must be named "Bearer" (upper case B). This is a known issue that we are working to resolve.
 
 */
/*
 {
 "CityResource": {
 "Cities": {
 "City": {
 "CityCode": "NYC",
 "CountryCode": "US",
 "Position": {
 "Coordinate": {
 "Latitude": 40.689919,
 "Longitude": -74.044937
 }
 },
 "Names": {
 "Name": [{
 "@LanguageCode": "de",
 "$": "New York"
 }, {
 "@LanguageCode": "ru",
 "$": "Нью-Йорк"
 }, {
 "@LanguageCode": "ko",
 "$": "뉴욕"
 }, {
 "@LanguageCode": "pt",
 "$": "Nova Iorque"
 }, {
 "@LanguageCode": "jp",
 "$": "ニューヨーク"
 }, {
 "@LanguageCode": "kr",
 "$": "뉴욕 - 존에프케네디 국제공항"
 }, {
 "@LanguageCode": "en",
 "$": "New York"
 }, {
 "@LanguageCode": "it",
 "$": "New York"
 }, {
 "@LanguageCode": "fr",
 "$": "New York"
 }, {
 "@LanguageCode": "es",
 "$": "Nueva York"
 }, {
 "@LanguageCode": "ka",
 "$": "紐約"
 }, {
 "@LanguageCode": "ja",
 "$": "ニューヨーク"
 }, {
 "@LanguageCode": "pl",
 "$": "Nowy Jork"
 }, {
 "@LanguageCode": "mi",
 "$": "纽约"
 }]
 },
 "Airports": {
 "AirportCode": ["EWR", "JFK", "LGA"]
 }
 }
 },
 "Meta": {
 "@Version": "1.0.0",
 "Link": [{
 "@Href": "https:\/\/api-test.lufthansa.com\/v1\/references\/cities\/NYC",
 "@Rel": "self"
 }, {
 "@Href": "https:\/\/api-test.lufthansa.com\/v1\/references\/countries\/US",
 "@Rel": "related"
 }, {
 "@Href": "https:\/\/api-test.lufthansa.com\/v1\/references\/airports\/{airportCode}",
 "@Rel": "related"
 }, {
 "@Href": "http:\/\/travelguide.lufthansa.com\/de\/de\/new-york-city\/",
 "@Rel": "alternate"
 }, {
 "@Href": "http:\/\/travelguide.lufthansa.com\/de\/en\/new-york-city\/",
 "@Rel": "alternate"
 }]
 }
 }
 }*/


//https://developer.lufthansa.com/io-docs
//https://api.lufthansa.com/v1/references/countries/?lang=en&limit=100&offset=0
/*
 GET Countries references/countries/
 {countryCode}		string
 2-letter ISO 3166-1 country code
 
 lang		string
 2 letter ISO 3166-1 language code
 
 limit		string
 Number of records returned per request. Defaults to 20, maximum is 100 (if a value bigger than 100 is given, 100 will be taken)
 
 offset		string
 Number of records skipped. Defaults to 0
 
 Accept		string
 http header: application/json or application/xml
 */

/*
 GET Cities references/cities/
 List all cities or one specific city. It is possible to request the response in a specific language.
 
 Parameter	Value	Type	Description
 {cityCode}		string
 3-letter IATA city code
 
 lang		string
 2 letter ISO 3166-1 language code
 
 limit		string
 Number of records returned per request. Defaults to 20, maximum is 100 (if a value bigger than 100 is given, 100 will be taken)
 
 offset		string
 Number of records skipped. Defaults to 0
 
 Accept		string
 http header: application/json or application/xml
 */

/*
 GET Airports references/airports/
 List all airports or one specific airport. All airports response is very large. It is possible to request the response in a specific language.
 
 Parameter	Value	Type	Description
 {airportCode}		string
 3-letter IATA airport code
 
 lang		string
 2-letter ISO 3166-1 language code
 
 limit		string
 Number of records returned per request. Defaults to 20, maximum is 100 (if a value bigger than 100 is given, 100 will be taken)
 
 offset		string
 Number of records skipped. Defaults to 0
 
 LHoperated		boolean
 Restrict the results to locations with flights operated by LH (false=0, true=1)
 
 Accept		string
 http header: application/json or application/xml
 */

/*
 GET Nearest Airports references/airports/nearest/
 List the 5 closest airports to the given latitude and longitude, irrespective of the radius of the reference point.
 
 Parameter	Value	Type	Description
 {latitude}		number
 Latitude in decimal format to at most 3 decimal places
 
 {longitude}		number
 Longitude in decimal format to at most 3 decimal places
 
 lang		string
 2 letter ISO 3166-1 language code
 
 Accept		string
 http header: application/json or application/xml
 */
