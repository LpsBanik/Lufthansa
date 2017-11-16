//
//  AirportTableViewCell.h
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/6/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirportTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* airportNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* countryCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel* cityCodeLabel;

@end
