//
//  MAPSViewController.m
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/8/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import "MapViewController.h"
#import "ServerManager.h"
#import "AFNetworkReachabilityManager.h"


@import GoogleMaps;

@interface MapViewController () <CLLocationManagerDelegate, GMSMapViewDelegate>

@property(strong) CLLocationManager* locationManager;

@end

@implementation MapViewController

GMSCameraPosition* camera;
GMSMapView* mapView;
GMSMarker* marker;
BOOL locationUpdate;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //[GMSServices locationManager] = [CLLocationManager ()];
    camera = [GMSCameraPosition cameraWithLatitude:52.4345
                                         longitude:30.9754
                                              zoom:8];
    mapView.myLocationEnabled = YES;

    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    
    [mapView addObserver:self
              forKeyPath:@"myLocation"
                 options:(NSKeyValueObservingOptionNew |
                           NSKeyValueObservingOptionOld)
                 context:NULL];
  
    self.view = mapView;
    //mapView.delegate = self;
    // Запросить данные моего местоположения после того, как карта уже добавлена на вьюшке.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView.myLocationEnabled = YES;
    });
}

//с этим методом мне помог ДИМА
-(void) showNearestAirportsWithLatitude:(double)latitude
                              longitude:(double)longitude {
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]){
        return;
    }
    
    [[ServerManager sharedManager]
     getNearestAirportsWithCoordinatesLatitude:latitude
     longitude:longitude
     language:@"en"
     onSuccess:^(NSArray* airports) {
         NSMutableArray* airportsArray = [NSMutableArray array];
         [airportsArray addObjectsFromArray: airports];
         
         for(Airport* obj in airportsArray){
             marker = [[GMSMarker alloc] init];
             marker.position = CLLocationCoordinate2DMake(obj.latitude ,obj.longitude);
             marker.title = obj.airportName;
             marker.snippet = obj.airportCode;
             marker.map = mapView;
            
         }
         locationUpdate = NO;
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@ , code = %ld" , [error localizedDescription] ,(long)statusCode);
     } ];
    
}

- (void) dealloc {
    
    if(mapView.myLocationEnabled){
        [mapView removeObserver:self
                      forKeyPath:@"myLocation"
                         context:NULL];
    }
}

//с этим методом мне помог ДИМА
- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context {
    
    if (!locationUpdate) {
        locationUpdate = YES;
        CLLocation* location = [change objectForKey:NSKeyValueChangeNewKey];
        
        mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:6];
        
        [self showNearestAirportsWithLatitude:location.coordinate.latitude
                                    longitude:location.coordinate.longitude];
    }
}

-(void)selectAirport:(Airport*) airport {
    
    camera = [GMSCameraPosition cameraWithLatitude:airport.latitude
                                         longitude:airport.longitude
                                              zoom:6];
    
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.mapType = kGMSTypeHybrid;
    self.view = mapView;
    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(airport.latitude, airport.longitude);
    marker.title = airport.airportName;
    marker.snippet = airport.airportCode;
    marker.icon = [GMSMarker markerImageWithColor:[UIColor magentaColor]];
    marker.map = mapView;
   
}

@end
