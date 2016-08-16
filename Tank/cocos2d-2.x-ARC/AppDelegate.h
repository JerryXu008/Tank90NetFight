//
//  AppDelegate.h
//  cocos2d-2.x-ARC
//
//  Created by Steffen Itterheim on 01.04.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "NetViewController.h"
@interface MyNavigationController : UINavigationController 
@end
@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;
    
	CCDirectorIOS	*__unsafe_unretained director_;							// weak ref
}

@property (nonatomic) UIWindow *window;
@property (readonly) MyNavigationController  *navController;
@property (unsafe_unretained, readonly) CCDirectorIOS *director;
@property (strong, readonly) NetViewController *netVC;

@property (readonly) MyNavigationController  *navControllerNet;
@end
