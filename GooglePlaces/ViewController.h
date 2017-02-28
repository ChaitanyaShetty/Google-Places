//
//  ViewController.h
//  GooglePlaces
//
//  Created by test on 2/27/17.
//  Copyright © 2017 com.meheboob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


#define kGOOGLE_API_KEY @"AIzaSyBDznQSyiGcau6dZzKpWOoWOnyt5JZmNV0"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManger;
    CLLocationCoordinate2D currentcentre;
    int currentDist;
    int oldValue;
    BOOL firstLaunch;
}

- (IBAction)toolBarButtonPress:(id)sender;

- (IBAction)ZoomIn:(id)sender;
- (IBAction)ZoomOut:(id)sender;



@property (weak, nonatomic) IBOutlet MKMapView *myMapView;


@end

