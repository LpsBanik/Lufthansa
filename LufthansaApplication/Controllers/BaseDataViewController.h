//
//  BaseDataViewController.h
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/3/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AFNetworkReachabilityManager.h"

@interface BaseDataViewController : UITableViewController <NSFetchedResultsControllerDelegate>


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic , assign) BOOL update;

//тут надо проверить, по уроку там
//-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object;


@end
