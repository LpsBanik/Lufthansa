//
//  BaseDataManager.m
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/3/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import "BaseDataManager.h"
#import "CDCity.h"
#import "City.h"
#import "CDAirport.h"
#import "Airport.h"
#import "Country.h"
#import "CDCountry.h"
#import "ServerManager.h"

@implementation BaseDataManager

//создаем метод класса, который возвращает объект данного класса. У нас есть статический указатель на объект этого класса. Если он не существует, то устанавливаем его в кукую-то переменную и возвращаем, А если существует, то мы простоего возвращаем. ДЛя многопоточности Apple создали dispatch_once токен. Таким образом он зщащищен от разных параллельных потоков.
+(BaseDataManager *) sharedManager {
    
    static BaseDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BaseDataManager alloc] init];
    });
    
    return manager;
}

- (void) addObjects: (NSObject *)object {
    
    //проверка - если этот объект является страной, то создаем страну с соответствующими ей свойствами- entity
    if([object isKindOfClass:[Country class]]){
        
        Country* country = (Country*)object;
        CDCountry* countryCoreData =
        [NSEntityDescription
         insertNewObjectForEntityForName:@"CDCountry"
                  inManagedObjectContext:self.managedObjectContext];
        countryCoreData.countryName = country.countryName;
        countryCoreData.countryCode = country.countryCode;
        
        NSLog(@"COUNTRY = %@, CODE = %@", country.countryName, country.countryCode);
        return;
        
    }
     //проверка - если это город, то создаем город с соответствующими ему свойствами- entity
    if([object isKindOfClass:[City class]]){
        
        City* city = (City*)object;
        CDCity* cityCoreData =
        [NSEntityDescription insertNewObjectForEntityForName:@"CDCity"
                                      inManagedObjectContext:self.managedObjectContext];
        
        cityCoreData.cityName = city.cityName; // добавляет имя города на вьюшку City
        cityCoreData.cityCode = city.cityCode;
        
        NSLog(@"CITY = %@, CODE = %@", city.cityName, city.cityCode);
        
        return;
        
    }
     //проверка - если это аэропорт, то создаем его с соответствующими ему свойствами- entity
    if([object isKindOfClass:[Airport class]]){
        
        Airport* airport = (Airport*)object;
        CDAirport* airportCoreData =
        [NSEntityDescription insertNewObjectForEntityForName:@"CDAirport"
                                      inManagedObjectContext:self.managedObjectContext];
        
        airportCoreData.airportName = airport.airportName;
        airportCoreData.airportCode = airport.airportCode;
        airportCoreData.countryCode = airport.countryCode;
        airportCoreData.cityCode = airport.cityCode;
        airportCoreData.latitude = airport.latitude;
        airportCoreData.longitude = airport.longitude;
        
        NSLog(@"AIRPORTS = %@, CODE = %@, countryCode = %@, cityCode = %@, latitude =%f, longitude = %f", airport.airportName, airport.airportCode, airport.countryCode, airport.cityCode, airport.latitude, airport.longitude);
        
        return;
    }
}

-(void) insertCountriesWithOffset:(NSInteger)offset
                            count:(NSInteger)count
                         language:(NSString *)lang
                        onSuccess:(void (^)())success
                        onFailure:(void (^)(NSError *, NSInteger))failure {
    
    [[ServerManager sharedManager]
     getCountriesWithOffset:offset
     language:lang
     limit:count
     onSuccess:^(NSArray *countries) {
         
         NSMutableArray* countriesArray = [NSMutableArray array];
         [countriesArray addObjectsFromArray: countries];
         
         for(Country *obj in countriesArray) {
              NSLog(@"%@", obj.countryName);
             [self addObjects:obj];
         }
     } onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@ , code = %ld" , [error localizedDescription] ,(long)statusCode);
     }];
}

-(void) insertCitiesWithOffset:(NSInteger)offset
                         count:(NSInteger)count
                      language:(NSString *)lang
                     onSuccess:(void (^)())success
                     onFailure:(void (^)(NSError *, NSInteger))failure {
    
    [[ServerManager sharedManager]
     getCitiesWithOffset:offset
     language:lang
     limit:count
     onSuccess:^(NSArray* cities) {
         
         NSMutableArray* citiesArray = [NSMutableArray array];
         [citiesArray addObjectsFromArray: cities];
         
         for(City *obj in citiesArray) {
             NSLog(@"%@", obj.cityName);
             [self addObjects:obj];
         }
     } onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@ , code = %ld" , [error localizedDescription] ,(long)statusCode);
     }];
    
}

-(void) insertAirportsWithOffset:(NSInteger)offset
                           count:(NSInteger)count
                        language:(NSString *)lang
                       onSuccess:(void (^)())success
                       onFailure:(void (^)(NSError *, NSInteger))failure {
    
    [[ServerManager sharedManager]
    getAirportsWithOffset:offset
     language:lang
     limit:count
     onSuccess:^(NSArray* airports) {
         
         NSMutableArray * airportsArray = [NSMutableArray array];
         [airportsArray addObjectsFromArray: airports];
         
         for(Airport* obj in airportsArray) {
             NSLog(@"%@", obj.airportName);
             [self addObjects:obj];
         }
     } onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@ , code = %ld" , [error localizedDescription] ,(long)statusCode);
     }];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    // это что-то типа синглтона,который работает только в проперти, если у нас это проперти установлено не nil, то мы его возвращаем....
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    //а если не установлено, то мы его инициализируем
    //до конца приложения у нас будет существовать 1 контекст, 1 координатор и 1 обжектмодел
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LufthansaApplication" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LufthansaApplication.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    }
    
    return _persistentStoreCoordinator;
}


- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.skokhan.LufthansaApplication" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSArray*) allObjectsInEntityForName:(NSString *)entityName  {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:entityName
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

- (void) removeAllObjectsInEntityForName:(NSString *)entityName {
    
    NSArray* allObjects = [self allObjectsInEntityForName:entityName];
    if([allObjects count]==0){
        return;
    }
    
    for (id object in allObjects) {
        [self.managedObjectContext deleteObject:object];
    }
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
            abort();
        }
    }
}

@end






// The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
//if (_persistentStoreCoordinator != nil) {
//    return _persistentStoreCoordinator;
//}

//// Create the coordinator and store
//// _persistentStoreCoordinator передает данные нашего приложения в базу данных. Занимается сохранением и чтением. У него есть доступ к файлу, открывает его что-то там химичт с ним, он знает какие объекты там лежат, то есть сущности. Именно модель объясняет ему какие данные там лежат.
//_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LufthansaApplication.sqlite"]; //файл, в котором хранится наша база, нашу базу можно хранить в разных форматах, вот какие типы: NSSQLiteStoreType, NSXMLStoreType, NSBinaryStoreType, NSInMemoryStoreType
//
//NSError *error = nil;
//NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//    // Report any error we got.
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//    dict[NSUnderlyingErrorKey] = error;
//    error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//    // Replace this with code to handle the error appropriately.
//    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);