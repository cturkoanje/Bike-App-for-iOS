//
//  SecondViewController.m
//  Bike App
//
//  Created by Christian Turkoanje on 4/16/14.
//  Copyright (c) 2014 Christian Turkoanje. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[self dataFilePath]];
    }
    else{
        [self displayControls:false];
        
        _locationTracking.enabled = false;
        [_locationTracking setAlpha:0.5];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Reading Data"
                                                        message:@"There was a problem reading the settings file. Please make sure that you are signed in correctly.\nIf the problem persists, reinstall the application."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    _incrementSwitch.enabled = false;
    [_incrementSwitch setAlpha:0.5];
    
    _accuracyControl.enabled = false;
    [_accuracyControl setAlpha:0.5];
    
    [_locationTracking setOn:FALSE animated:FALSE];
    
    [_trackingDistance setText:@"100"];
}

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"settings.plist"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)locationTrackingChanged:(id)sender {
    if(_locationTracking.on)
    {
        NSLog(@"Is On");
        [self startLocationTracking];
        
    }
    else
    {
         NSLog(@"Is Off");
        [_locationManager stopUpdatingLocation];
        [self displayControls:TRUE];
    }
}
- (IBAction)updateEveryChanged:(id)sender {
    [_trackingDistance setText:[NSString stringWithFormat:(@"%0.f"), _incrementSwitch.value]];
}


- (IBAction)trackingModeChanged:(id)sender {
    
    if(_trackingMode.selectedSegmentIndex == 0)
    {
        _incrementSwitch.enabled = false;
       [_incrementSwitch setAlpha:0.5];
        _accuracyControl.enabled = false;
        [_accuracyControl setAlpha:0.5];
        
        [_incrementSwitch setValue:100.0 animated:TRUE];
        [_accuracyControl setSelectedSegmentIndex:2];
        [_trackingDistance setText:@("100")];
    }
    else
    {
        _incrementSwitch.enabled = true;
        [_incrementSwitch setAlpha:1];
        
        _accuracyControl.enabled = true;
        [_accuracyControl setAlpha:1];
    }
}
- (IBAction)enteredGroupID:(id)sender {
    [_groupID resignFirstResponder];
}

-(void)displayControls:(BOOL)show
{
    if(show)
    {
        _incrementSwitch.enabled = true;
        [_incrementSwitch setAlpha:1];
        
        _accuracyControl.enabled = true;
        [_accuracyControl setAlpha:1];
        
        _groupID.enabled = true;
        [_groupID setAlpha:1];
        
        _trackingMode.enabled = true;
        [_trackingMode setAlpha:1];
        
        if(_trackingMode.selectedSegmentIndex == 0)
        {
            _incrementSwitch.enabled = false;
            [_incrementSwitch setAlpha:0.5];
            _accuracyControl.enabled = false;
            [_accuracyControl setAlpha:0.5];
            
            [_incrementSwitch setValue:100.0 animated:TRUE];
            [_accuracyControl setSelectedSegmentIndex:2];
            [_trackingDistance setText:@("100")];
        }
        else
        {
            _incrementSwitch.enabled = true;
            [_incrementSwitch setAlpha:1];
            
            _accuracyControl.enabled = true;
            [_accuracyControl setAlpha:1];
        }
    }
    else
    {
        _incrementSwitch.enabled = false;
        [_incrementSwitch setAlpha:0.5];
        
        _accuracyControl.enabled = false;
        [_accuracyControl setAlpha:0.5];
        
        _groupID.enabled = false;
        [_groupID setAlpha:0.5];
        
        _trackingMode.enabled = false;
        [_trackingMode setAlpha:0.5];
        
    }
}

-(void)startLocationTracking
{
    if([_groupID.text length] == 0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Group ID"
                                                        message:@"You must fill out the group ID before you can enable tracking."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [_groupID becomeFirstResponder];
        [_locationTracking setOn:FALSE animated:TRUE];
        return;
    }
    NSLog(@"Starting location tracking...");
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter = 100.0;
    
    [self displayControls:false];
    
    if(_trackingMode.selectedSegmentIndex == 0)
    {
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.distanceFilter = 100.0;
    }
    else if(_trackingMode.selectedSegmentIndex == 1)
    {
        switch (_accuracyControl.selectedSegmentIndex) {
            case 0:
                _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                break;
            case 1:
                _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
                break;
            case 2:
                _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
                break;
            case 3:
                _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
                break;
            case 4:
                _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
                break;
            default:
                _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
                break;
        }

        _locationManager.distanceFilter = [_trackingDistance.text floatValue];
        
        NSLog(@"Update for (%@) %fm",_trackingDistance.text, [_trackingDistance.text floatValue]);
    }
    
    
    [_locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    [self updateRemoteLocation:newLocation];
    NSLog(@"Got new locaton\n");
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    NSLog(@"Some error occured");
    
    [_locationManager stopUpdatingLocation];
    [_locationTracking setOn:FALSE animated:TRUE];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No GPS"
                                                    message:@"We could not get a location from your phone. Make sure you enable location service for this app."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)updateRemoteLocation:(CLLocation *)newLocation
{
    /*
     id = $_REQUEST['id'];
     $lat = $_REQUEST['lat'];
     $lon = $_REQUEST['lon'];
     $email = $_REQUEST['email'];
     */
    NSMutableData *xmlData = [[NSMutableData alloc] init];
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"http://api.bikeapp.me/update/location/?id=%@&email=crisss1205@me.com&lat=%f&lon=%f", _groupID.text, newLocation.coordinate.latitude, newLocation.coordinate.longitude]];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"error:%@", error.localizedDescription);
                               }
                               NSLog(@"The data: \n%@", data);
                               [xmlData appendData:data];
                           }];
}

@end
