//
//  ServerManager.h
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/4/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServerManager : NSObject


+ (ServerManager *) sharedManager;

-(void) getCountriesWithOffset:(NSInteger) offset
                      language:(NSString *) lang
                         limit:(NSInteger) limit
                     onSuccess:(void(^)(NSArray *countries)) success
                     onFailure:(void(^)(NSError *error , NSInteger statusCode)) failure;

-(void) getCitiesWithOffset:(NSInteger) offset
                   language:(NSString *) lang
                      limit:(NSInteger) limit
                  onSuccess:(void(^)(NSArray *countries)) success
                  onFailure:(void(^)(NSError *error , NSInteger statusCode)) failure;

-(void) getAirportsWithOffset:(NSInteger) offset
                     language:(NSString *) lang
                        limit:(NSInteger) limit
                    onSuccess:(void(^)(NSArray *countries)) success
                    onFailure:(void(^)(NSError *error , NSInteger statusCode)) failure;

-(void) getNearestAirportsWithCoordinatesLatitude:(double)latitude
                                        longitude:(double)longitude
                                         language:(NSString *)lang
                                        onSuccess:(void (^)(NSArray *))success
                                        onFailure:(void (^)(NSError *, NSInteger))failure;

-(void) getAccessTokenFromServer;

@end
