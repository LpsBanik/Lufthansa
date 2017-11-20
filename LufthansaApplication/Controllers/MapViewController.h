//
//  MAPSViewController.h
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/8/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDAirport.h"
#import "Airport.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController

-(void) selectAirport:(Airport*) airport;

@end
