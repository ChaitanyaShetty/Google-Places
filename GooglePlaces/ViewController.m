//
//  ViewController.m
//  GooglePlaces
//
//  Created by test on 2/27/17.
//  Copyright © 2017 com.meheboob. All rights reserved.
//

#import "ViewController.h"
#import "MapPoint.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myMapView.delegate = self;
    self.myMapView.showsUserLocation = YES;
    locationManger = [[CLLocationManager alloc]init];
    
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc]init];
    pointAnnotation.coordinate = locationManger.location.coordinate;;
   
    
    [locationManger setDelegate:self];
    [locationManger setDistanceFilter:kCLDistanceFilterNone];
    [locationManger setDesiredAccuracy:kCLLocationAccuracyBest];
    firstLaunch = YES;
    [self.myMapView addAnnotation:pointAnnotation];

    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views
{
    CLLocationCoordinate2D centre = [mapView centerCoordinate];
    MKCoordinateRegion region;
    if (firstLaunch) {
        region = MKCoordinateRegionMakeWithDistance(locationManger.location.coordinate, 10000, 10000);
        firstLaunch = NO;
    } else {
        region = MKCoordinateRegionMakeWithDistance(centre, currentDist, currentDist);
    }
    
    [mapView setRegion:region animated:YES];
}



- (IBAction)toolBarButtonPress:(id)sender {
    
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    NSString *buttonTitle = [button.title lowercaseString];
    [self queryGooglePlaces:buttonTitle];
    
}

-(void)queryGooglePlaces :(NSString *)googleType {
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", currentcentre.latitude, currentcentre.longitude, [NSString stringWithFormat:@"%i", currentDist], googleType, kGOOGLE_API_KEY];
    NSURL *googleRequestURL= [NSURL URLWithString:url];
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData: (NSData *)responseData {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *places = [json objectForKey:@"results"];
    NSLog(@"google data:%@", places);
    [self plotPositions:places];
    
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKMapRect mRect = self.myMapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    currentDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    currentcentre = self.myMapView.centerCoordinate;
    
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.myMapView.centerCoordinate = userLocation.location.coordinate;
}

-(void)plotPositions:(NSArray *)data {
    
    for (id<MKAnnotation> annotation in self.myMapView.annotations) {
        if ([annotation isKindOfClass:[MapPoint class]]) {
            [self.myMapView removeAnnotation:annotation];
        }
    }
    
    for (int i = 0; i<[data count]; i++) {
        NSDictionary *places = [data objectAtIndex:i];
        NSDictionary *geo = [places objectForKey:@"geometry"];
        NSDictionary *loc = [geo objectForKey:@"location"];
        NSString *name = [places objectForKey:@"name"];
        NSString *vicinity = [places objectForKey:@"vicinity"];
        CLLocationCoordinate2D placeCoord;
        placeCoord.latitude = [[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude = [[loc objectForKey:@"lng"] doubleValue];
        
        MapPoint *placeObject = [[MapPoint alloc]initWithName:name address:vicinity coordinate:placeCoord];
        [self.myMapView addAnnotation:placeObject];
        
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"MapPoint";
    if ([annotation isKindOfClass:[MapPoint class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
        } else {
            
            annotationView.annotation = annotation;
            
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
    return nil;
}

- (IBAction)ZoomIn:(id)sender {
    MKCoordinateSpan span;
    span.latitudeDelta = self.myMapView.region.span.latitudeDelta/2;
    span.longitudeDelta = self.myMapView.region.span.longitudeDelta/2;
    MKCoordinateRegion region;
    region.span = span;
    region.center = self.myMapView.region.center;
    [self.myMapView setRegion:region animated:YES];
}

- (IBAction)ZoomOut:(id)sender {
    MKCoordinateSpan span;
    span.latitudeDelta = self.myMapView.region.span.latitudeDelta*2;
    span.longitudeDelta = self.myMapView.region.span.longitudeDelta*2;
    MKCoordinateRegion region;
    region.span = span;
    region.center = self.myMapView.region.center;
    [self.myMapView setRegion:region animated:YES];

}
@end
