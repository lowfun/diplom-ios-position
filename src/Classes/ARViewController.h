//
//  ARViewController.h
//  DiplomProject
//
//  Created by Alexander Hantzsch on 14.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "ARCoordinate.h"

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * (180.0/M_PI))

@protocol ARViewDelegate

- (UIView *)viewForCoordinate:(ARCoordinate *)coordinate;

@end

@interface ARViewController : UIViewController <UIAccelerometerDelegate, CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	UIAccelerometer *accelerometerManager;
	
	CLLocation *centerLocation;
	ARCoordinate *centerCoordinate;
	
	UIImagePickerController *cameraController;
	
	NSObject<ARViewDelegate> *delegate;
	NSObject<CLLocationManagerDelegate> *locationDelegate;
	NSObject<UIAccelerometerDelegate> *accelerometerDelegate;
	
	BOOL scaleViewsBasedOnDistance;
	double maximumScaleDistance;
	double minimumScaleFactor;
	
	//defaults to 20hz;
	double updateFrequency;
	
	BOOL rotateViewsBasedOnPerspective;
	double maximumRotationAngle;
	
@private
	// only for touchBegin and touchMove
	CGPoint _startPoint;
	double _currentDegree;
	UIImageView *compassNeedle;
	
	BOOL ar_debugMode;
	
	NSTimer *_updateTimer;
	
	UIView *ar_overlayView;
	
	UILabel *ar_debugView;
	
	NSMutableArray *ar_coordinates;
	NSMutableArray *ar_coordinateViews;
	
	NSMutableArray *ar_shownCoordinates;
}

@property (readonly) NSArray *coordinates;

@property BOOL debugMode;

@property BOOL scaleViewsBasedOnDistance;
@property double maximumScaleDistance;
@property double minimumScaleFactor;

@property BOOL rotateViewsBasedOnPerspective;
@property double maximumRotationAngle;

@property double updateFrequency;

//adding coordinates to the underlying data model.
- (void)addCoordinate:(ARCoordinate *)coordinate;
- (void)addCoordinate:(ARCoordinate *)coordinate animated:(BOOL)animated;

- (void)addCoordinates:(NSArray *)newCoordinates;

//removing coordinates
- (void)removeCoordinate:(ARCoordinate *)coordinate;
- (void)removeCoordinate:(ARCoordinate *)coordinate animated:(BOOL)animated;

- (void)removeCoordinates:(NSArray *)coordinates;

- (id)initWithLocationManager:(CLLocationManager *)manager;

- (void)startListening;
- (void)updateLocations:(NSTimer *)timer;

- (CGPoint)pointInView:(UIView *)realityView forCoordinate:(ARCoordinate *)coordinate;

- (BOOL)viewportContainsCoordinate:(ARCoordinate *)coordinate;

@property (nonatomic, retain) UIImagePickerController *cameraController;

@property (nonatomic, assign) NSObject<ARViewDelegate> *delegate;
@property (nonatomic, assign) NSObject<CLLocationManagerDelegate> *locationDelegate;
@property (nonatomic, assign) NSObject<UIAccelerometerDelegate> *accelerometerDelegate;

@property (nonatomic, retain) CLLocation *centerLocation;
@property (retain) ARCoordinate *centerCoordinate;

@property (nonatomic, retain) UIAccelerometer *accelerometerManager;
@property (nonatomic, retain) CLLocationManager *locationManager;


@end
