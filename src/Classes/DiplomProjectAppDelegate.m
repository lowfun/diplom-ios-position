//
//  DiplomProjectAppDelegate.m
//  DiplomProject
//
//  Created by Alexander Hantzsch on 14.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DiplomProjectAppDelegate.h"

#import "JSON.h"

@implementation DiplomProjectAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

	viewController = [[ARViewController alloc] init];
	
	viewController.debugMode = YES;
	
	viewController.delegate = self;
	viewController.locationDelegate = self;
	
	viewController.scaleViewsBasedOnDistance = YES;
	viewController.minimumScaleFactor = .5;
	
	viewController.rotateViewsBasedOnPerspective = NO;
	
	NSMutableArray *tempLocationArray = [[NSMutableArray alloc] init];
	
	CLLocation *tempLocation;
	ARCoordinate *tempCoordinate;
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"poi" ofType:@"json"];
	if (filePath) {
		NSArray *poiList = [[[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] JSONValue] retain];
		
		NSDictionary *poi;
		NSInteger cID = 1;
		for (poi in poiList) {
			CLLocationCoordinate2D location;
			location.latitude = [[poi objectForKey:@"Latitude"] doubleValue];
			location.longitude = [[poi objectForKey:@"Longitude"] doubleValue];
			
			tempLocation = [[CLLocation alloc] initWithCoordinate:location altitude:[[poi objectForKey:@"Altitude"] doubleValue] horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:[NSDate date]];
			
			tempCoordinate = [ARCoordinate coordinateWithLocation:tempLocation];
			tempCoordinate.title = [poi objectForKey:@"Title"];
			tempCoordinate.coordinateID = cID++;
			
			[tempLocationArray addObject:tempCoordinate];
			[tempLocation release];
		}
		
		[poiList release];
	}	
	
	[viewController addCoordinates:tempLocationArray];
	[tempLocationArray release];
	
	CLLocationCoordinate2D location;
	location.latitude = 51.026874554891464;
	location.longitude = 13.71866226196289;
	
	CLLocation *newCenter = [[CLLocation alloc] initWithCoordinate:location altitude:113.0 horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:[NSDate date]];
	
	viewController.centerLocation = newCenter;
	[newCenter release];
	
	[viewController startListening];
	
    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Delegates

#define BOX_WIDTH 150.0
#define BOX_HEIGHT 100.0

- (UIView *)viewForCoordinate:(ARCoordinate *)coordinate {
	
	CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	UIView *tempView = [[UIView alloc] initWithFrame:theFrame];
	tempView.tag = coordinate.coordinateID;
	
	UIImageView *bgImage = [[UIImageView alloc] initWithFrame:theFrame];
	bgImage.image = [UIImage imageNamed:@"Box.png"];
	
	[tempView addSubview:bgImage];
	[bgImage release];
	
	//tempView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.3];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, BOX_WIDTH - 20.0, 70.0)];
	titleLabel.tag = 999;
	//titleLabel.backgroundColor = [UIColor colorWithWhite:.3 alpha:.8];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor blackColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.numberOfLines = 4;
	titleLabel.font = [UIFont systemFontOfSize:10.0];
	//titleLabel.text = coordinate.title;
	titleLabel.text = [NSString stringWithFormat:@"%@ - %5.2fkm", coordinate.title, coordinate.radialDistance / 1000.0];
	//[titleLabel sizeToFit];
	//titleLabel.frame = CGRectMake(10.0, 10.0, BOX_WIDTH - 20.0, 70.0);
	//titleLabel.frame = CGRectMake(BOX_WIDTH / 2.0 - titleLabel.frame.size.width / 2.0 - 4.0, 0, titleLabel.frame.size.width + 8.0, titleLabel.frame.size.height + 8.0);
	
	//UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectZero];
	//pointView.image = [UIImage imageNamed:@"location.png"];
	//pointView.frame = CGRectMake((int)(BOX_WIDTH / 2.0 - pointView.image.size.width / 2.0), (int)(BOX_HEIGHT / 2.0 - pointView.image.size.height / 2.0), pointView.image.size.width, pointView.image.size.height);
	
	[tempView addSubview:titleLabel];
	//[tempView addSubview:pointView];
	
	[titleLabel release];
	//[pointView release];
	
	tempView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
	
	return [tempView autorelease];
}

#pragma mark CLLocationManager

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	//viewController.centerLocation = newLocation;	
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [manager stopUpdatingLocation];
		manager.delegate = nil;
    }
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
