//
//  AirportsViewController.m
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/3/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import "AirportsViewController.h"
#import "CitiesViewController.h"
#import "AirportTableViewCell.h"
#import "MapViewController.h"

#import "BaseDataManager.h"
#import "ServerManager.h"

#import "Airport.h"
#import "CDAirport.h"


@interface AirportsViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@end

@implementation AirportsViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

static NSInteger airportsInRequest = 100;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateAirports];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSManagedObjectContext *) managedObjectContext {
    
    if(!_managedObjectContext){
        _managedObjectContext = [[BaseDataManager sharedManager] managedObjectContext];
    }
    
    return _managedObjectContext;
    
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    //редактируем свое имя
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDAirport" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    // Установить количество записей для одной загрузки.
    [fetchRequest setFetchBatchSize:50];
    
    // Edit the sort key as appropriate.
    //отредактировать сортировку по ключу countryCode, и ставим ДА, если по возрастанию.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"airportCode" ascending:YES];
    
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

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object {
    
    cell.textLabel.text = [[object valueForKey:@"airportName"] description];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.fetchedResultsController.fetchedObjects count ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"airportsCell";

    AirportTableViewCell* cell = (AirportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[AirportTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Airport* airport = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.airportNameLabel.text = airport.airportName;
    cell.countryCodeLabel.text = airport.countryCode;
    cell.cityCodeLabel.text = airport.cityCode;
    cell.textLabel.text = @"";
    
    if ( indexPath.row == [self.fetchedResultsController.fetchedObjects count] - 1)
    {
        [self updateAirports];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"selectAirport"]){
        
        NSIndexPath* path = [self.tableView indexPathForSelectedRow];
        CDAirport* airport = [self.fetchedResultsController objectAtIndexPath:path];
        
        if([segue.destinationViewController respondsToSelector:@selector(selectAirport:)]) {
            
            [segue.destinationViewController performSelector:@selector(selectAirport:)
                                                 withObject : airport ];
        }
    }
}

-(void)updateAirports {
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]){
        return;
    }
    
    if(!self.update){
        [[BaseDataManager sharedManager] removeAllObjectsInEntityForName:@"CDAirport"];
    }
    
    [[BaseDataManager sharedManager]
     insertAirportsWithOffset:[self.fetchedResultsController.fetchedObjects  count]
     count:(airportsInRequest)
     language:@"en"
     onSuccess:^{}
     onFailure:^(NSError *error, NSInteger statuscode) {}];
    
    self.update = YES;
}

@end
