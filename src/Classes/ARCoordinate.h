//
//  ARCoordinate.h
//  DiplomProject
//
//  Created by Alexander Hantzsch on 14.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * (180.0/M_PI))

@interface ARCoordinate : NSObject {
	double radialDistance; //Distance to object
	double inclination; //angle off horizon.
	double azimuth; //Angle from north
	
	NSString *title;
	NSInteger coordinateID;
	
	CLLocation *location;
}


+ (ARCoordinate *)coordinateWithLocation:(CLLocation *)location;
+ (ARCoordinate *)coordinateWithLocation:(CLLocation *)location fromOrigin:(CLLocation *)origin;
+ (ARCoordinate *)coordinateWithRadialDistance:(double)newRadialDistance inclination:(double)newInclination azimuth:(double)newAzimuth;

- (float)angleFromCoordinate:(CLLocationCoordinate2D)first toCoordinate:(CLLocationCoordinate2D)second;
- (void)calibrateUsingOrigin:(CLLocation *)origin;

@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSString *title;
@property (nonatomic) NSInteger coordinateID;
@property (nonatomic) double radialDistance;
@property (nonatomic) double inclination;
@property (nonatomic) double azimuth;

@end
