//
//  CountriesViewController.m
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/3/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import "CountriesViewController.h"
#import "BaseDataManager.h"
#import "CDCountry.h"
#import "Country.h"
#import "ServerManager.h"

@interface CountriesViewController ()

@property (assign,nonatomic) BOOL loadingBaseData;

@end

@implementation CountriesViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

static NSInteger countriesInRequest = 100;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateCountries];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSManagedObjectContext *) managedObjectContext{
    
    if(!_managedObjectContext){
        _managedObjectContext = [[BaseDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    //редактируем свое имя
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDCountry" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
//    // Set the batch size to a suitable number.
//    // Установить количество записей для одной загрузки.
//    [fetchRequest setFetchBatchSize:50];
    
    // Edit the sort key as appropriate.
    //отредактировать сортировку по ключу countryCode, и ставим ДА, если по возрастанию.
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"countryCode" ascending:YES];
    
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
    
    cell.textLabel.text = [[object valueForKey:@"countryName"] description];
}

//количество рядов будет равно количеству объектов, которые к нам пришли
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.fetchedResultsController.fetchedObjects count];
}

//проверяю, если есть ячейка, чтобы переиспользовать, берем ее, если нету, создаем.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"countryCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Country* country = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = country.countryName;
    
    if ( indexPath.row == [self.fetchedResultsController.fetchedObjects count] - 1)
    {
        [self updateCountries];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

//когда нажали на ячейку хочу передать данные в следующий контроллер.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) updateCountries {
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]){
        
       return;
    }
    
    if(!self.update){
        [[BaseDataManager sharedManager] removeAllObjectsInEntityForName:@"CDCountry"];
        
    }
    
    [[BaseDataManager sharedManager]
     insertCountriesWithOffset:[self.fetchedResultsController.fetchedObjects  count]
     count:countriesInRequest
     language:@"en"
     onSuccess:^{}
     onFailure:^(NSError *error, NSInteger statuscode) {}];
    
     self.update = YES;
}

@end
