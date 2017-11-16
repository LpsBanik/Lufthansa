//
//  BaseDataManager.h
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/3/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface BaseDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(BaseDataManager *) sharedManager;

-(void) insertCountriesWithOffset:(NSInteger)offset
                            count:(NSInteger)count
                         language:(NSString *)lang
                        onSuccess:(void (^)())success
                        onFailure:(void (^)(NSError *, NSInteger))failure;

-(void) insertCitiesWithOffset:(NSInteger)offset
                         count:(NSInteger)count
                      language:(NSString *)lang
                     onSuccess:(void (^)())success
                     onFailure:(void (^)(NSError *, NSInteger))failure;

-(void) insertAirportsWithOffset:(NSInteger)offset
                           count:(NSInteger)count
                        language:(NSString *)lang
                       onSuccess:(void (^)())success
                       onFailure:(void (^)(NSError *, NSInteger))failure;

- (void) saveContext;
- (void) removeAllObjectsInEntityForName:(NSString *)entityName;
- (NSURL *)applicationDocumentsDirectory;

@end
