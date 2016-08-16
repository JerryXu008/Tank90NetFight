//
//  InputLayer.m
//  BattleCity
//
//  Created by 喆 肖 on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InputLayer.h"
#import "Tank90Sprite.h"
#import "MapLayer.h"
#import "BonjourHelper.h"
@interface InputLayer(PrivateMethod)

-(void) addFireButton;
-(void) addJoystick;

@end


@implementation InputLayer

//@synthesize mapLayer = _mapLayer;

- (id)init {
    
    if ((self = [super init])) {
        
        [self addFireButton];
        [self addJoystick];
        [self scheduleUpdate];
        
    }
    return  self;
}
- (void)dealloc {
    
    
}

- (void) addFireButton {
    
    float buttonRadius = 80;
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    fireButton = [SneakyButton button];
    //长按连续发射
    fireButton.isHoldable=YES;
    
    
    SneakyButtonSkinnedBase* skinFireButton = [SneakyButtonSkinnedBase skinnedButton];
    skinFireButton.position = CGPointMake(winSize.width - buttonRadius/2,buttonRadius/2);
    skinFireButton.defaultSprite = [CCSprite spriteWithFile:@"fire_button_default.png"];
    skinFireButton.pressSprite = [CCSprite spriteWithFile:@"fire_button_press.png"];
    skinFireButton.button = fireButton;
    [self addChild:skinFireButton];
    skinFireButton.scale = 0.5;
    
    skinFireButton.defaultSprite.opacity = 100;
    skinFireButton.pressSprite.opacity = 100;
}
- (void) addJoystick {
    
    float stickRadius = 70;
    joystick = [SneakyJoystick joystickWithRect:CGRectMake(0, 0, stickRadius, stickRadius)];
    joystick.autoCenter = YES;
    joystick.hasDeadzone = YES;
    joystick.deadRadius = 5;
    
    
    SneakyJoystickSkinnedBase* skinStick = [SneakyJoystickSkinnedBase skinnedJoystick];
    skinStick.position = CGPointMake(stickRadius, stickRadius);
    skinStick.scale = 0.6;
    skinStick.backgroundSprite = [CCSprite spriteWithFile:@"control_bg.png"];
    skinStick.thumbSprite = [CCSprite spriteWithFile:@"cen.png"];
    skinStick.thumbSprite.scale = 1.0f;
    skinStick.joystick = joystick;
    
    skinStick.backgroundSprite.opacity = 100;
    skinStick.thumbSprite.opacity = 100;
    
    [self addChild:skinStick];
}

-(void)update:(ccTime)dt {
    
    if ( nil == _mapLayer) return;
    
    Tank90Sprite* tank =nil;
    if([kkCurPID intValue]==1){
        tank = _mapLayer.tank1;
    }
    if([kkCurPID intValue]==2){
        tank = _mapLayer.tank2;
    }
    
    
    if ( nil == tank) return;
    
    
    CGPoint poi = ccpMult(joystick.velocity, 50);
    
    if (fireButton.active) {
        [tank onFire];
        [UserInfoManager sendTank90Fire];
        
    }
    
    
    
    if ((poi.x  >  0)  && (poi.x - poi.y) >0 && (poi.x + poi.y) > 0){
        if([kkDanJi intValue]==0){
            [UserInfoManager sendTank90Move:tank.position moveType:tank_right];
        }
        
        [tank moveRight];
        
    }else if ( (poi.x < 0)  && (poi.x + poi.y) < 0 &&(poi.x - poi.y) < 0) {
        if([kkDanJi intValue]==0){
            [UserInfoManager sendTank90Move:tank.position moveType:tank_left];
        }
        [tank moveLeft];
        
    }else if ((poi.y > 0) &&(poi.y - poi.x) > 0 &&(poi.y + poi.x) >0 ){
        
        if([kkDanJi intValue]==0){
            [UserInfoManager sendTank90Move:tank.position moveType:tank_top];
        }
        [tank moveUp];
        
    }else if ((poi.y < 0) &&(poi.y - poi.x) < 0 && (poi.y + poi.x) < 0) {
        
        if([kkDanJi intValue]==0){
            [UserInfoManager sendTank90Move:tank.position moveType:tank_bottom];
        }
        
        [tank moveDown];
    }
    
}

@end
