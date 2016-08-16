//
//  AppDelegate.m
//  cocos2d-2.x-ARC
//
//  Created by Steffen Itterheim on 01.04.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "HelloWorldLayer1.h"
#import "StartScene.h"
#import "NetViewController.h"
#import "UserInfoManager.h"
@implementation MyNavigationController

// The available orientations should be defined in the Info.plist file.
// And in iOS 6+ only, you can override it in the Root View controller in the "supportedInterfaceOrientations" method.
// Only valid for iOS 6+. NOT VALID for iOS 4 / 5.
-(NSUInteger)supportedInterfaceOrientations {
    
    // iPhone only
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
        return UIInterfaceOrientationMaskLandscape;
    //return UIInterfaceOrientationMaskPortrait;
    // iPad only
    return UIInterfaceOrientationMaskLandscape;
}

@end



@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;
@synthesize netVC,navControllerNet;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Create the main window
    window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    // Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
    CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
                                   pixelFormat:kEAGLColorFormatRGBA8	//kEAGLColorFormatRGBA8
                                   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
                            preserveBackbuffer:NO
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0];
    
    /****************斜角瓦片启用这个**********************/
    //    CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
    //                                   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
    //                                   depthFormat:GL_DEPTH_COMPONENT24_OES
    //                            preserveBackbuffer:NO
    //                                    sharegroup:nil
    //                                 multiSampling:NO
    //                               numberOfSamples:0];
    
    
    /****************斜角瓦片启用这个**********************/
    
    director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
    
    // 2D projection
    [director_ setProjection:kCCDirectorProjection2D];
    
    
    
    
    
    director_.wantsFullScreenLayout = YES;
    
    
    //使用 setDisplayStats 方法可在屏幕左下角显示数字
    // Display FSP and SPF
    [director_ setDisplayStats:NO];
    
    // set FPS at 60
    [director_ setAnimationInterval:1.0/60];
    
    // attach the openglView to the director
    [director_ setView:glView];
    
    // for rotation and other messages
    [director_ setDelegate:self];
    
    
    //    /************************是否支持Retina屏幕的高清显示*****************************/
    //注意顺序，一定要在 [director_ setView:glView] 之后
    [director_ enableRetinaDisplay:NO];
    
    
    //	[director setProjection:kCCDirectorProjection3D];
    
    
    // Create a Navigation Controller with the Director
    navController_ = [[MyNavigationController alloc] initWithRootViewController:director_];
    navController_.navigationBarHidden = YES;
    
    netVC=[[ NetViewController alloc]init];
    navControllerNet = [[MyNavigationController alloc] initWithRootViewController:netVC];
    
    
    // navController_.navigationBarHidden = YES;
    //netVC.view.backgroundColor=[UIColor redColor];
    
    
    // set the Navigation Controller as the root view controller
    //	[window_ setRootViewController:rootViewController_];
    //[window_ addSubview:navController_.view];
    window_.rootViewController=navController_;
    // make main window visible
    [window_ makeKeyAndVisible];
    
    // Default texture format for PNG/BMP/TIFF/JPEG/GIF images
    // It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
    // You can change anytime.
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    // When in iPhone RetinaDisplay, iPad, iPad RetinaDisplay mode, CCFileUtils will append the "-hd", "-ipad", "-ipadhd" to all loaded files
    // If the -hd, -ipad, -ipadhd files are not found, it will load the non-suffixed version
    
    CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
    [sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
    [sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
    [sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
    [sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
    
    // Assume that PVR images have premultiplied alpha
    [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
    
    // and add the scene to the stack. The director will run it when it automatically when the view is displayed.
    //[director_ pushScene: [StartScene scene]];
    //    CCScene* scene = [CCScene node];
    //    CCLayer* layer = [StartScene node];
    //    [scene addChild:layer];
    
    netVC.dataDelegate=self;
    [navController_ presentViewController:navControllerNet animated:YES completion:nil];
    
    //glView.backgroundColor=[UIColor redColor];
    //    [navControllerNet dismissViewControllerAnimated:YES completion:nil];
    //    [director_ pushScene: [StartScene scene]];
    
    return YES;
}


//连接成功之后的回调
- (void) connectionEstablished
{
    kkDanJi=@"0";
    
    [navControllerNet dismissViewControllerAnimated:YES completion:nil];
    [director_ pushScene: [StartScene scene]];
    
}
- (void)danjiOnly{
    kkDanJi=@"1";
    [director_ pushScene: [StartScene scene]];
}



// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
    if( [navController_ visibleViewController] == director_ )
        [director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
    if( [navController_ visibleViewController] == director_ )
        [director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
    if( [navController_ visibleViewController] == director_ )
        [director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
    if( [navController_ visibleViewController] == director_ )
        [director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
    CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
    [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end
