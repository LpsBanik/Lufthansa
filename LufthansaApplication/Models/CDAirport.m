//
//  CDAirport.m
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/7/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDAirport.h"

@implementation CDAirport

@dynamic airportCode; // dynamic просто говорит, что такие
@dynamic airportName; // проперти будут созданы в рантайме
@dynamic cityCode;   // гетеры и сетеры до рантайма
@dynamic countryCode; // существовать не будут.
@dynamic latitude;  // Есть свой механизм у КОРДАТЫ
@dynamic longitude; // нам это не известно, она сама за них отвечает

@end
