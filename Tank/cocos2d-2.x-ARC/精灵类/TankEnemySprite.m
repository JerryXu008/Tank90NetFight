//
//  TankEnemySprite.m
//  Tank90
//
//  Created by song on 15/4/28.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import "TankEnemySprite.h"
#define FRAME(image) [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:image]

@implementation TankEnemySprite

//-(id)copyWithZone:(NSZone *)zone
//{
//
//}

+ (TankEnemySprite *)initWithKind:(int)kind {
    
    CCSpriteFrame* frame;
    TankEnemySprite* tank;
    switch (kind) {
        case kSlow:{
            frame = FRAME(@"en1.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            tank.life = 1;
            tank.speed = 1;
            tank.score = 500;
            tank.kind = kSlow;
            tank.enemyKindForScore = kSlow;
            [tank setRotation:180];
            break;
        }
        case kQuike:{
            frame = FRAME(@"en2.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            
            tank.life = 1;
            tank.speed = 2;
            tank.score = 1000;
            tank.kind = kQuike;
            tank.enemyKindForScore = kQuike;
            [tank setRotation:180];
            break;
        }
        case kStrong:{
            frame = FRAME(@"en6.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            
            tank.life = 1;
            tank.speed = 1;
            tank.score = 1000;
            tank.kind = kStrong;
            tank.enemyKindForScore = kStrong;
            [tank setRotation:180];
            break;
        }
        case kStrongYellow:{
            frame = FRAME(@"en5.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            
            tank.life = 2;
            tank.speed = 1;
            tank.score = 1500;
            tank.kind = kStrongYellow;
            tank.enemyKindForScore = kStrongYellow;
            [tank setRotation:180];
            break;
        }
        case kStrongRedLife3:{
            frame = FRAME(@"en7.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            
            tank.life = 3;
            tank.speed = 1;
            tank.score = 2000;
            tank.isRead = YES;
            tank.kind = kStrongRedLife3;
            tank.enemyKindForScore = kStrongRedLife3;
            [tank setRotation:180];
            break;
        }
        case kStrongRed:{
            frame = FRAME(@"en7.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            
            tank.life = 1;
            tank.speed = 1;
            tank.score = 2500;
            tank.kind = kStrongRed;
            tank.enemyKindForScore = kStrongRed;
            tank.isRead = YES;
            [tank setRotation:180];
            break;
        }
        case kStrongGreen:{
            frame = FRAME(@"en3.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            
            tank.life = 3;
            tank.speed = 1;
            tank.score = 3000;
            tank.kind = kStrongGreen;
            tank.enemyKindForScore = kStrongGreen;
            [tank setRotation:180];
            break;
        }
        case kQuikeR:{
            frame = FRAME(@"en2r.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            
            tank.life = 1;
            tank.speed = 2;
            tank.score = 1000;
            tank.kind = kQuikeR;
            tank.enemyKindForScore = kQuikeR;
            tank.isRead = YES;
            [tank setRotation:180];
            break;
        }
        case kSlowR:{
            frame = FRAME(@"en1r.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            tank.life = 1;
            tank.speed = 1;
            tank.score = 500;
            tank.isRead = YES;
            [tank setRotation:180];
            tank.kind = kSlowR;
            tank.enemyKindForScore = kSlowR;
            break;
        }
        default:
            break;
    }
    
    tank.scale = 0.8f;
    tank.kAction = kDown;
    tank.isCanFire = YES;
    [tank animationBorn];
    
    if([kkCurPID isEqualToString:@"1"]){
     [tank scheduleOnce:@selector(initAction) delay:1];
    }
    
    
    return tank;
}

- (void)initAction {
    
    [self unschedule:@selector(initAction)];
    [self schedule:@selector(doRandomAction) interval:1];
    [self schedule:@selector(keepMove) interval:1/30];
    [self schedule:@selector(rodmoFire) interval:1];
}
- (void)doRandomAction {
    
    float ran = CCRANDOM_0_1();
    
    if (ran < 0.4) self.kAction = kDown;
    else if (ran < 0.6)  self.kAction = kLeft;
    else if (ran < 0.9)  self.kAction = kRight;
    else  self.kAction = kUp;
    [UserInfoManager sendTankEnemyDirection:self.kAction tankTag:self.tag] ;
    
}
- (void)rodmoFire {
    
    int rodom ;
    
    for (int i = 0 ;i < 4; i++){
        rodom = arc4random() % 4;
        if (rodom == 0){
            [self onFire];
        }else if (rodom == 1){
            [self unschedule:@selector(onFireAndNet)];
            [self scheduleOnce:@selector(onFireAndNet) delay:0.2];
        }else if (rodom == 2){
            [self unschedule:@selector(onFireAndNet)];
            [self scheduleOnce:@selector(onFireAndNet) delay:0.4];
        }else if (rodom == 3){
            [self unschedule:@selector(onFireAndNet)];
            [self scheduleOnce:@selector(onFireAndNet) delay:0.7];
        }
    }
}
-(void)onFireAndNet{
   
    [UserInfoManager sendTankEnemyRadomFire:0 tankTag:self.tag];
    
    [self onFire];
}
//重写父类方法
- (void)onFire {
    
    CCSpriteFrame* frameButtle = FRAME(@"bullet.png");
    if (self.isCanFire == NO) return;
    self.buttleOrientation = self.kAction;
    CCSprite* buttle = [CCSprite spriteWithSpriteFrame:frameButtle];
    
   self.buttleSprite = buttle;
    
    [self.delegate initButtleDidFinish:self buttle:buttle];
    buttle.visible = NO;
    self.isCanFire = NO;
    
    [self fire:buttle orientation:self.kAction];
}

//重写父类方法
- (BOOL)checkTankPosition {
    
    BOOL jiechu=NO;
    
    CGRect tankEnemy;
    CGPoint point;
    CGPoint tp = self.position;
    
    if (self.kAction == kUp){
        point = ccp(tp.x,tp.y + self.boundingBox.size.height / 2 + self.speed);
    }else if (self.kAction == kDown){
        point = ccp(tp.x,tp.y - self.boundingBox.size.height / 2 - self.speed);
    }else if (self.kAction == kLeft) {
        point =  ccp(tp.x - self.boundingBox.size.width/2 - self.speed,tp.y);
    }else if (self.kAction == kRight) {
        point = ccp(tp.x + self.boundingBox.size.width/2 + self.speed,tp.y);
    }
    tankEnemy = CGRectMake(_tank1.position.x - _tank1.boundingBox.size.width/2,
                           _tank1.position.y - _tank1.boundingBox.size.height/2,
                           _tank1.boundingBox.size.width,
                           _tank1.boundingBox.size.height);
    if (CGRectContainsPoint(tankEnemy, point)){
        jiechu=YES;
    }
    if([kkDanJi intValue]==0){
        tankEnemy = CGRectMake(_tank2.position.x - _tank2.boundingBox.size.width/2,
                               _tank2.position.y - _tank2.boundingBox.size.height/2,
                               _tank2.boundingBox.size.width,
                               _tank2.boundingBox.size.height);
        
        if (CGRectContainsPoint(tankEnemy, point)){
            jiechu=YES;
        }
    
    }
    
    
    return jiechu;
}

//重写父类方法
- (void)checkTool {
    
}
//重写父类方法
- (void)checkBang:(NSTimer *)timer{
    
    CCSprite* buttle = [timer userInfo];
    
   
    if ([self checkLayer2:buttle]) {
        [timer invalidate];self.timer = nil;
        [buttle removeFromParentAndCleanup:YES];
        self.isCanFire = YES;
        self.buttleSprite = nil;
        return;
    }
    //检查老家是否被干掉
    if ([self checkHome:buttle]) {
        [timer invalidate];self.timer = nil;
        [buttle removeFromParentAndCleanup:YES];
        self.isCanFire = YES;
        self.buttleSprite = nil;
        return;
    }
    if (self.isButtleDone) {//子弹和我方子弹碰撞，敌方子弹也消失
        [timer invalidate];self.timer = nil;
        [buttle removeFromParentAndCleanup:YES];
        self.isCanFire = YES;
        self.buttleSprite = nil;
        self.isButtleDone = NO;
        return;
    }
    //敌方子弹击中我方坦克的逻辑
    if ([self checkTank:buttle]){
        [timer invalidate];self.timer = nil;
        [buttle removeFromParentAndCleanup:YES];
        self.buttleSprite = nil;
        self.isCanFire = YES;
        return;
    }

    //检查墙壁碰撞
    if ([self checkWall:buttle]) {
        [timer invalidate];self.timer = nil;
        [buttle removeFromParentAndCleanup:YES];
        self.isCanFire = YES;
        self.buttleSprite = nil;
        return;
    }
    //检查钢板碰撞
    if ([self checkStrongWall:buttle]) {
        [timer invalidate];self.timer = nil;
        [buttle removeFromParentAndCleanup:YES];
        self.isCanFire = YES;
        self.buttleSprite = nil;
        return;
    }
    
    //监测子弹是否超出屏幕了
    if([self checkBound:buttle]){
        [timer invalidate];
       self.timer = nil;
        self.isCanFire = YES;
        [buttle removeFromParentAndCleanup:YES];
        return;
        
    }
}
- (void)stopTankAction {
    [self unschedule:@selector(doRandomAction)];
    [self unschedule:@selector(keepMove)];
    [self unschedule:@selector(rodmoFire)];
}

-(void)removeSelfFromMap {
    
    [self removeFromParentAndCleanup:YES];
}


- (void)keepMove {
    
    switch (self.kAction) {
        case kUp:{
           
            [UserInfoManager sendTankRandomRandomMovetankTag:self.tag posion:self.position];
             [self moveUp];
            break;
        }
           
        case kDown:{
                        [UserInfoManager sendTankRandomRandomMovetankTag:self.tag posion:self.position];
            [self moveDown];

            break;
        }
            
        case kLeft:{
          
             [UserInfoManager sendTankRandomRandomMovetankTag:self.tag posion:self.position];
              [self moveLeft];
            break;
        }
           
        case kRight:{
           
             [UserInfoManager sendTankRandomRandomMovetankTag:self.tag posion:self.position];
            [self moveRight];
            break;
        }
           
        default:
            break;
    }
}

//敌方坦克才有的检测
-(BOOL)checkTank:(CCSprite *)buttle{
   CGRect tankRect;
    if(_tank1.visible==YES){
    
        tankRect = CGRectMake(_tank1.position.x - _tank1.boundingBox.size.width/2,
                              _tank1.position.y - _tank1.boundingBox.size.height/2,
                              _tank1.boundingBox.size.width,
                              _tank1.boundingBox.size.height);

    
    
        if (CGRectContainsPoint(tankRect, buttle.position)) {
            if (_tank1.isProtect) {
                return YES;
            }
            else{
            
            CCSpriteFrame* newFrame;
                if (_tank1.kind == kPlusStarThree){
                    newFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"p1-b.png"];
                    _tank1.displayFrame = newFrame;
                    _tank1.speed = 1.5;
                    _tank1.kind = kPlusStarTwo;
                    return YES;
                }else if (_tank1.kind == kPlusStarTwo){
                    newFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"p1-a.png"];
                    _tank1.displayFrame = newFrame;
                    _tank1.speed = 1.5;
                    _tank1.kind = kPlusStarOne;
                    return YES;
                }else {
                    
                    newFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"p1.png"];
                    _tank1.displayFrame = newFrame;
                    _tank1.speed = 1;
                    _tank1.kind = kBorn;
                   
                    [_tank1 topButtle];//我方坦克被击中了
                }

            }
        
        }
    
    }
    if([kkDanJi intValue]==0){
    if(_tank2.visible==YES){
        
        tankRect = CGRectMake(_tank2.position.x - _tank2.boundingBox.size.width/2,
                              _tank2.position.y - _tank2.boundingBox.size.height/2,
                              _tank2.boundingBox.size.width,
                              _tank2.boundingBox.size.height);
        
        
        
        if (CGRectContainsPoint(tankRect, buttle.position)) {
            if (_tank2.isProtect) {
                return YES;
            }
            else{
                
                CCSpriteFrame* newFrame;
                if (_tank2.kind == kPlusStarThree){
                    newFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"p2-b.png"];
                    _tank2.displayFrame = newFrame;
                    _tank2.speed = 1.5;
                    _tank2.kind = kPlusStarTwo;
                    return YES;
                }else if (_tank2.kind == kPlusStarTwo){
                    newFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"p2-a.png"];
                    _tank2.displayFrame = newFrame;
                    _tank2.speed = 1.5;
                    _tank2.kind = kPlusStarOne;
                    return YES;
                }else {
                    
                    newFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"p2.png"];
                    _tank2.displayFrame = newFrame;
                    _tank2.speed = 1;
                    _tank2.kind = kBorn;
                    
                    [_tank2 topButtle];//我方坦克被击中了
                }
                
            }
            
        }
        
    }

   }
    
    
    return NO;
    
}
- (void)playMoveVideo {
   
}
- (void)onExit {
    [super onExit];
    
    [self.buttleSprite removeFromParentAndCleanup:YES];
    _tank1 = nil;
    _tank2=nil;
    
}

@end
