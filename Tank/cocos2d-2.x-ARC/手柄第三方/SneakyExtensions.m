//
//  SneakyExtensions.m
//  BattleCity
//
//  Created by 喆 肖 on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SneakyExtensions.h"

@implementation SneakyButton(Extension)

+(id) buttonWithRect:(CGRect)rect {
     return [[[SneakyButton alloc] initWithRect:rect] autorelease];
}
+(id) button {
    return [[[SneakyButton alloc] initWithRect:CGRectZero] autorelease];
}

@end

@implementation SneakyButtonSkinnedBase(Extension)

+(id) skinnedButton {
    return [[[SneakyButtonSkinnedBase alloc] init] autorelease];
}

@end

@implementation SneakyJoystick(Extension)

+(id) joystickWithRect:(CGRect)rect {
    return [[[SneakyJoystick alloc] initWithRect:rect] autorelease];
}

@end
@implementation SneakyJoystickSkinnedBase(Extension)

+(id) skinnedJoystick {
    return [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
}

@end