//
//  CitiesViewController.m
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/3/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import "CitiesViewController.h"
#import "BaseDataManager.h"
#import "City.h"
#import "CDCity.h"
#import "ServerManager.h"

@interface CitiesViewController ()

@end

@implementation CitiesViewController

@synthesize fetchedResultsController = _fetchedResultsController;


static NSInteger citiesInRequest = 100;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateCities];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    //редактируем свое имя
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDCity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    // Установить количество записей для одной загрузки.
    [fetchRequest setFetchBatchSize:50];
    
    // Edit the sort key as appropriate.
    //отредактировать сортировку по ключу countryCode, и ставим ДА, если по возрастанию.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cityCode" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Master"]; //имя файла кэша, куда кэшируется всякие рузультаты запросов, имя файла на жестком диске для кордаты. Ускоряет запрос. Когда мы делаем 1 и тот же запрос. Если Хотим разную сортировку, или группировать по разным принципам или менять сущность, то ставим нил или игнорить, или удалять. У него есть метод класса, короче посмотреть урок 44 на 37 минуте
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDatasource

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object {
    
    cell.textLabel.text = [[object valueForKey:@"cityName"] description];
}

//количество рядов будет равно количеству объектов, которые к нам пришли
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.fetchedResultsController.fetchedObjects count ] ;
}

//проверяю, если есть ячейка, чтобы переиспользовать, берем ее, если нету, создаем.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"citiesCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    City* city = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = city.cityName;
    
    if ( indexPath.row == [self.fetchedResultsController.fetchedObjects count] - 1)
    {
        [self updateCities];
    }
    
    return cell;
}

-(void) updateCities {
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]){
        return;
    }
    
    if(!self.update){
        [[BaseDataManager sharedManager] removeAllObjectsInEntityForName:@"CDCity"];
        
    }
    
    [[BaseDataManager sharedManager]
     insertCitiesWithOffset:[self.fetchedResultsController.fetchedObjects  count]
     count:(citiesInRequest)
     language:@"en"
     onSuccess:^{}
     onFailure:^(NSError *error, NSInteger statuscode) {}];
    
    self.update = YES;
}

@end
