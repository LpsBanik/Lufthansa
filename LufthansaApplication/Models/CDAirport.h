//
//  CDAirport.h
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/7/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import <CoreData/CoreData.h>

@interface CDAirport : NSManagedObject

@property (nullable, nonatomic, retain) NSString* cityCode;
@property (nullable, nonatomic, retain) NSString* countryCode;
@property (nullable, nonatomic, retain) NSString* airportName;
@property (nullable, nonatomic, retain) NSString* airportCode;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end

