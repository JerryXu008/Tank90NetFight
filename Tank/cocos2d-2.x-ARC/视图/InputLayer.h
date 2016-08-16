//
//  InputLayer.h
//  BattleCity
//
//  Created by 喆 肖 on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ColoredCircleSprite.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "SneakyExtensions.h"
@class MapLayer;

@interface InputLayer : CCLayer {
    
    SneakyButton* fireButton;
    SneakyJoystick* joystick;
    
    
}

@property(nonatomic,assign)MapLayer* mapLayer;

@end
