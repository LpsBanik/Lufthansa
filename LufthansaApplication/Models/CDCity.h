//
//  CDCity.h
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/7/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import <CoreData/CoreData.h>

@interface CDCity: NSManagedObject

@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSString *cityCode;

@end


