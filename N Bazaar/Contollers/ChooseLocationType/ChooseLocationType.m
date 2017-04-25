//
//  ChooseLocationType.m
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 31/03/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import "ChooseLocationType.h"
#import "Constant.h"
#import "Utilities.h"
#import <CoreLocation/CoreLocation.h>
#import "HomeVc.h"
#import <GooglePlaces/GooglePlaces.h>



@interface ChooseLocationType ()<CLLocationManagerDelegate,GMSAutocompleteViewControllerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property(weak, nonatomic)IBOutlet UIView *objBackgroundView;
@property(weak, nonatomic)IBOutlet UIButton *objAutomatic;
@property(weak, nonatomic)IBOutlet UIButton *objManual;

@end



@implementation ChooseLocationType

- (void)viewDidLoad {
    [super viewDidLoad];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame=self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.0/255.0 green:80.0/255.0 blue:120.0/255.0 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:20.0/255.0 green:42.0/255.0 blue:74.0/255.0 alpha:1.0] CGColor], nil];
    [self.objBackgroundView.layer insertSublayer:gradient atIndex:0];
    
    self.objAutomatic.layer.cornerRadius = 5.0;
    self.objAutomatic.layer.masksToBounds = YES;
    
    self.objManual.layer.cornerRadius = 5.0;
    self.objManual.layer.masksToBounds = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didClickClose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)didclickAutomaticallyfetchLocation:(id)sender{
    
    NSString *objusrlat = [[NSUserDefaults standardUserDefaults]valueForKey:Current_Lat];
    if (objusrlat) {
        [Utilities showLoadingWithText:@"Loading..."];
        [self setUserLocation];
    }
    else{
        [Utilities showLoadingWithText:@"Getting your Location..."];
        [self getCurrentLocation];
    }
      
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) setUserLocation {
    NSString *objusrlat = [[NSUserDefaults standardUserDefaults]valueForKey:Current_Lat];
    NSString *objusrlong = [[NSUserDefaults standardUserDefaults]valueForKey:Current_Long];
    
    if (![objusrlat isEqualToString:@""]) {
        NSString *strAddressFromLatLong = [self getAddressFromLatLon:objusrlat withLongitude:objusrlong];
        NSLog(@"%@",strAddressFromLatLong);
        [self.delegate setMynewLocationonText:strAddressFromLatLong];
    }
    else{
        NSLog(@"Location not found");
    }
    [Utilities hideLoading];
}

-(NSString *)getAddressFromLatLon:(NSString *)pdblLatitude withLongitude:(NSString *)pdblLongitude
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=false",pdblLatitude, pdblLongitude];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    NSData *data = [locationString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *dic = [[json objectForKey:@"results"] objectAtIndex:0];
    //    NSString *cityName = [[[dic objectForKey:@"address_components"] objectAtIndex:1] objectForKey:@"long_name"];
    NSString *objmyAddress = [dic objectForKey:@"formatted_address"];
    return objmyAddress;
}


#pragma mark CurrentUserLocation

-(void)getCurrentLocation{
    
    [Utilities showLoadingWithText:@"Getting your Location..."];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self->locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    [locations lastObject];
    
    currentLocation = [locations lastObject];
    [locationManager stopUpdatingLocation];
    
    double userCurrentLat = currentLocation.coordinate.latitude;
    double userCurrentLong = currentLocation.coordinate.longitude;
    
    NSString *objLatstr = [NSString stringWithFormat:@"%f",userCurrentLat];
    NSString *objLongstr = [NSString stringWithFormat:@"%f",userCurrentLong];
    
    [[NSUserDefaults standardUserDefaults]setValue:objLatstr forKey:Current_Lat];
    [[NSUserDefaults standardUserDefaults]setValue:objLongstr forKey:Current_Long];
    
    [self setUserLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error.description);
    [Utilities showInfo:error.description];
    [Utilities hideLoading];
}


-(IBAction)didClickManuallyfetchLocation:(id)sender{
    
     GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
     acController.delegate = self;
     acController.primaryTextHighlightColor = [UIColor darkTextColor];
     acController.primaryTextColor = [UIColor darkGrayColor];
     acController.tableCellBackgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
     acController.tableCellSeparatorColor = [UIColor lightGrayColor];
     [self presentViewController:acController animated:YES completion:nil];
     
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    
    [self.delegate setMynewLocationonText:place.formattedAddress];

    //self.objDeliveryaddress.text = place.formattedAddress;
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];


    

}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [Utilities showLoadingWithText:@"Getting location..."];
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [Utilities hideLoading];
}


@end
