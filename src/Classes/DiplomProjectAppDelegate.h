//
//  DiplomProjectAppDelegate.h
//  DiplomProject
//
//  Created by Alexander Hantzsch on 14.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "ARViewController.h"

@class ARViewController;

@interface DiplomProjectAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate, ARViewDelegate> {
    UIWindow *window;
    ARViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ARViewController *viewController;

@end

