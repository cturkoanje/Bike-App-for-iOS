//
//  SecondViewController.h
//  Bike App
//
//  Created by Christian Turkoanje on 4/16/14.
//  Copyright (c) 2014 Christian Turkoanje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SecondViewController : UIViewController<CLLocationManagerDelegate>{
    
    UISwitch *locationTracking;
    UITextField *groupID;
    UISegmentedControl *trackingMode;
    UILabel *trackingDistance;
    CLLocationManager *locationManager;
    NSDateFormatter *dateFormatter;
    UISegmentedControl *accuracyControl;
    UISlider *incrementSwitch;
    NSMutableDictionary *settings;
    
}

@property (weak, nonatomic) IBOutlet UISwitch *locationTracking;
@property (weak, nonatomic) IBOutlet UITextField *groupID;
@property (weak, nonatomic) IBOutlet UISegmentedControl *trackingMode;
@property (weak, nonatomic) IBOutlet UILabel *trackingDistance;
@property (weak, nonatomic) IBOutlet UISlider *incrementSwitch;

@property (nonatomic, retain, readonly) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UISegmentedControl *accuracyControl;

@end
