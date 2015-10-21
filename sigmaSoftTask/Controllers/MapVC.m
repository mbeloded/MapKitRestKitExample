//
//  MapVC.m
//  sigmaSoftTask
//
//  Created by Michael Bielodied on 10/20/15.
//  Copyright © 2015 Michael Bielodied. All rights reserved.
//

#import "MapVC.h"
#import "DetailsVC.h"
#import "Place.h"
#import "PinView.h"
#import "Constants.h"
#import "PlacePinAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import <RestKit/RestKit.h>

#define PIN_IDENTIFIER @"pinId"

@interface MapVC ()

@property (weak, nonatomic) IBOutlet MKMapView *placesMap;
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) NSMutableArray * placeAnnotations;
@property (nonatomic, strong) PinView *pinView;
@property (nonatomic, strong) CLLocation * currentLocation;
@property (nonatomic, strong) CLLocation * prevLocation;
@property (nonatomic, assign) BOOL userLocationShown;

@end

@implementation MapVC
{
    int counter;
}

@synthesize places, placeAnnotations, placesMap, pinView, currentLocation, prevLocation, userLocationShown;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    counter = 0;
    
    userLocationShown = NO;
    
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"PinView"
                                                    owner:self options:nil];
    for (id object in bundle) {
        if ([object isKindOfClass:[PinView class]]) {
            self.pinView = (PinView *)object;
            break;
        }
    }
    
    self.title = @"Map of venues";
    
    self.places = [[NSArray alloc] init];
    self.placeAnnotations = [[NSMutableArray alloc] init];
    
    [self configureRestKit];
    
    // Do any additional setup after loading the view.
    self.placesMap.delegate = self;
    self.placesMap.mapType = MKMapTypeStandard;
    self.placesMap.showsUserLocation = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureRestKit
{
    // init AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // init RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup mappings for Place + Location + Place details
    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Place class]];
    [venueMapping addAttributeMappingsFromArray:@[@"name"]];
    
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping addAttributeMappingsFromArray:@[@"address", @"city", @"crossStreet", @"lat", @"lng"]];
    
    RKObjectMapping *detailsMapping = [RKObjectMapping mappingForClass:[Details class]];
    [detailsMapping addAttributeMappingsFromDictionary:@{@"checkinsCount": @"checkins", @"tipsCount": @"tips", @"usersCount": @"users"}];
    
    // define relationship mapping
    [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:locationMapping]];
    
    [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"stats" toKeyPath:@"details" withMapping:detailsMapping]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:venueMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:SEARCH_URL
                                                keyPath:SEARCH_KEYPASS
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (void)loadPlacesInfo :(void (^)(void)) completeBlock {
    
    NSString *latLon = [NSString stringWithFormat:@"%f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];//@"37.33,-122.03";
    
    NSString *clientID = F_CLIENTID;
    NSString *clientSecret = F_CLIENTSECRET;
    
    NSDictionary *queryParams = @{@"ll" : latLon,
                                  @"client_id" : clientID,
                                  @"client_secret" : clientSecret,
                                  @"v" : @"20140118"};
    
    counter = 0;
    
    __weak typeof (self) weakSelf = self;
    
    [[RKObjectManager sharedManager] getObjectsAtPath:SEARCH_URL
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  if (weakSelf.placeAnnotations.count > 0) {
                                                      [weakSelf.placesMap removeAnnotations:weakSelf.placeAnnotations];
                                                      [weakSelf.placeAnnotations removeAllObjects];
                                                  }
                                                  
                                                  weakSelf.places = mappingResult.array;
                                                  
                                                  for(Place* placeObj in weakSelf.places) {
                                                      [weakSelf setPinOnMapGeoPoint:placeObj];
                                                  }
                                                  
                                                  if (completeBlock != nil) {
                                                      completeBlock();
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Huston, we have a problem with REST request': %@", error);
                                              }];
}

#pragma mark MapView manager

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
    NSLog(@"map view center : %f %f", mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    if(userLocationShown) return;
    
    [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
 
    __weak typeof (self) weakSelf = self;
    [self updatePinsIfNeeded:^{
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(weakSelf.placesMap.centerCoordinate, MAP_RADIUS , MAP_RADIUS);
        
            [weakSelf.placesMap setRegion:region animated:YES];
            [weakSelf refreshZoom];
        
            weakSelf.userLocationShown = YES;
            [weakSelf deselectAllAnnotations];
    }];
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    if(!userLocationShown) return;
    
    __weak typeof (self) weakSelf = self;
    [self updatePinsIfNeeded:^{
        [weakSelf deselectAllAnnotations];
    }];
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *myPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PIN_IDENTIFIER];
    
    myPin.canShowCallout = NO;
    
    myPin.pinTintColor = UIColorFromRGB(pinColor);
    
    return myPin;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        
        pinView.tag = [view.annotation.title intValue];
        
        Place* placeObject = [places objectAtIndex:pinView.tag];
        
        [pinView setFrame:CGRectMake(view.frame.origin.x - (pinView.frame.size.width/2), view.frame.origin.y - pinView.frame.size.height, pinView.frame.size.width, pinView.frame.size.height)];
        pinView.owner = self;
        pinView.placeObject = placeObject;
        
        [view.superview addSubview:pinView];
        
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        [pinView removeFromSuperview];
    }
}

-(void) updatePinsIfNeeded:(void (^)(void)) completeBlock {
    
    currentLocation = [[CLLocation alloc] initWithLatitude:placesMap.centerCoordinate.latitude longitude:placesMap.centerCoordinate.longitude];
    
    CLLocationDistance dist = [prevLocation distanceFromLocation:currentLocation];
    
    if (dist > MAX_MOVE_DISTANCE || prevLocation == nil) {
        [self performSelector:@selector(loadPlacesInfo:) withObject:completeBlock afterDelay:1.0f];
    }
    
    prevLocation = [currentLocation copy];

}

-(void) refreshZoom {
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in placesMap.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [placesMap setVisibleMapRect:zoomRect animated:YES];
}

-(void) reloadMap {
    [placesMap setRegion:placesMap.region animated:TRUE];
}

-(void) deselectAllAnnotations {
    for (id currentAnnotation in placesMap.annotations) {
        if ([currentAnnotation isKindOfClass:[PlacePinAnnotation class]]) {
            [placesMap deselectAnnotation:currentAnnotation animated:YES];
        }
    }
}

-(void) setPinOnMapGeoPoint:(Place*) placeObj {
    PlacePinAnnotation *placemark = [[PlacePinAnnotation alloc] init];
    placemark.coordinate = CLLocationCoordinate2DMake([placeObj.location.lat doubleValue], [placeObj.location.lng doubleValue]);
    placemark.title = [NSString stringWithFormat:@"%d", counter];

    [placesMap addAnnotation:placemark];
    
    [placeAnnotations addObject:placemark];
    
    counter++;
}

- (void)pinClickAction:(id)sender {
    if ([sender isKindOfClass:[PinView class]]) {
        PinView* pinObject = (PinView*)sender;
        NSNumber * postIndex = [NSNumber numberWithInteger:pinObject.tag];
        
        [self deselectAllAnnotations];
        [self reloadMap];
        
        [self performSegueWithIdentifier:SHOW_POSITION_DETAILS_SEGUE sender:postIndex];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ( [segue.identifier isEqualToString:SHOW_POSITION_DETAILS_SEGUE] ) {
        DetailsVC *detailsVC = (DetailsVC*) segue.destinationViewController;
        if (sender != nil && [sender respondsToSelector:@selector(intValue)]) {
            detailsVC.placeObject = [places objectAtIndex:[sender intValue]];
        }
    }
}

@end
