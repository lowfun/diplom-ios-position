//
//  ARCoordinate.m
//  DiplomProject
//
//  Created by Alexander Hantzsch on 14.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ARCoordinate.h"


@implementation ARCoordinate

#pragma mark -
#pragma mark Properties

@synthesize radialDistance, inclination, azimuth;
@synthesize title;
@synthesize coordinateID;
@synthesize location;

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ r: %.3fm φ: %.3f° θ: %.3f°", self.title, self.radialDistance, radiansToDegrees(self.azimuth), radiansToDegrees(self.inclination)];
}

#pragma mark -
#pragma mark Class Methods

+ (ARCoordinate *)coordinateWithLocation:(CLLocation *)location {
	ARCoordinate *newCoordinate = [[ARCoordinate alloc] init];
	newCoordinate.location = location;
	
	newCoordinate.title = @"";
	
	return [newCoordinate autorelease];
}

+ (ARCoordinate *)coordinateWithLocation:(CLLocation *)location fromOrigin:(CLLocation *)origin {
	ARCoordinate *newCoordinate = [ARCoordinate coordinateWithLocation:location];
	
	[newCoordinate calibrateUsingOrigin:origin];
	
	return [newCoordinate autorelease];
}

+ (ARCoordinate *)coordinateWithRadialDistance:(double)newRadialDistance inclination:(double)newInclination azimuth:(double)newAzimuth {
	ARCoordinate *newCoordinate = [[ARCoordinate alloc] init];
	newCoordinate.radialDistance = newRadialDistance;
	newCoordinate.inclination = newInclination;
	newCoordinate.azimuth = newAzimuth;
	
	newCoordinate.title = @"";
	
	return [newCoordinate autorelease];
}

#pragma mark -
#pragma mark Object Methods

- (float)angleFromCoordinate:(CLLocationCoordinate2D)first toCoordinate:(CLLocationCoordinate2D)second {
	float longitudinalDifference = second.longitude - first.longitude;
	float latitudinalDifference = second.latitude - first.latitude;
	
	// Polarkoordinaten - Winkelberechnung
	if (latitudinalDifference > 0 && longitudinalDifference >= 0)
		return atan(longitudinalDifference / latitudinalDifference);
	else if (latitudinalDifference > 0 && longitudinalDifference < 0)
		return 2 * M_PI + atan(longitudinalDifference / latitudinalDifference);
	else if (latitudinalDifference < 0)
		return M_PI + atan(longitudinalDifference / latitudinalDifference);
	else if (latitudinalDifference == 0 && longitudinalDifference > 0)
		return M_PI * .5f; // == M_PI / 2
	else if (latitudinalDifference == 0 && longitudinalDifference < 0)
		return M_PI * 1.5f; // 3 / 2 * M_PI	
	
	return 0.0f;
}

- (void)calibrateUsingOrigin:(CLLocation *)origin {
	
	if (!self.location) return;
	
	double baseDistance = [origin distanceFromLocation:self.location];
	
	self.radialDistance = sqrt(pow(origin.altitude - self.location.altitude, 2) + pow(baseDistance, 2)); // Satz des Pythagoras
	
	// winkel = sin( Gegenkathete / Hypotenuse )
	float angle = sin(ABS(origin.altitude - self.location.altitude) / self.radialDistance); // Winkelfunktionen im rechtwinkligen Dreieck
	
	if (origin.altitude > self.location.altitude) angle = -angle;
	
	self.inclination = angle;
	self.azimuth = [self angleFromCoordinate:origin.coordinate toCoordinate:self.location.coordinate];
}

#pragma mark -
#pragma mark Memmory Management

- (void)dealloc {
	self.title = nil;
	[title release];
	self.location = nil;
	[location release];
	
	[super dealloc];
}

@end
