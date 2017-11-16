//
//  CDCountry.h
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/7/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CDCountry : NSManagedObject

@property (nonatomic, retain) NSString * countryName;
@property (nonatomic, retain) NSString * countryCode;

@end

