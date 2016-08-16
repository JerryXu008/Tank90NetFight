//
//  SneakyExtensions.h
//  BattleCity
//
//  Created by 喆 肖 on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// SneakyInput headers
#import "ColoredCircleSprite.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"

@interface SneakyButton(Extension)
+(id) button;
+(id) buttonWithRect:(CGRect)rect;

@end

@interface SneakyButtonSkinnedBase(Extension)
+(id) skinnedButton;

@end

@interface SneakyJoystick(Extension)
+(id) joystickWithRect:(CGRect)rect;

@end
@interface SneakyJoystickSkinnedBase(Extension)
+(id) skinnedJoystick;
@end
