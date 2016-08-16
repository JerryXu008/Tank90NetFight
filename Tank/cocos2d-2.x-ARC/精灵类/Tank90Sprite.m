//
//  Tank90Spirte.m
//  Tank90
//
//  Created by song on 15/4/27.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import "Tank90Sprite.h"
#import "TankEnemySprite.h"
#import "ToolSprite.h"
#import "SimpleAudioEngine.h"
#define FRAME(image) [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:image]
@interface Tank90Sprite()
{
    ToolSprite *  _tmpTool;
   
}
@property(nonatomic)int buttleCount;





@end
@implementation Tank90Sprite
@synthesize timer=_timer;




+ (id)initWithDelegate:(id<Tank90SpriteDelegate>)aDelegate life:(int)numLife tKind:(Tank90Kind)tKind mapSize:(CGSize)mSize ptype:(NSString*)type{

    CCSpriteFrame* frameKind;
    Tank90Sprite* tank90;
  //  tKind=kPlusStarThree;
    switch (tKind) {
            
        case kBorn:{
           frameKind = FRAME(([NSString stringWithFormat:@"p%@.png",type]));
            
            tank90 = [Tank90Sprite spriteWithSpriteFrame:frameKind];
            tank90.speed = 1;
            
        }
        case kPlusStarOne:{
            frameKind = FRAME(([NSString stringWithFormat:@"p%@-a.png",type]));
            tank90 = [Tank90Sprite spriteWithSpriteFrame:frameKind];
            tank90.speed = 1.5;
            break;
        }
        case kPlusStarTwo:{
            frameKind = FRAME(([NSString stringWithFormat:@"p%@-b.png",type]));
            tank90  = [Tank90Sprite spriteWithSpriteFrame:frameKind];
            tank90.speed = 1.5;
            break;
        }
        case kPlusStarThree:{
            frameKind = FRAME(([NSString stringWithFormat:@"p%@-c.png",type]));
            tank90 = [Tank90Sprite spriteWithSpriteFrame:frameKind];
            tank90.speed = 1.5;
            break;
        }
        default:
            break;
    }
    tank90.delegate = aDelegate;
    tank90.life = numLife;
    tank90.mapSize = mSize;
    
    tank90.kind = tKind;
    tank90.scale = 0.7f;

    tank90.kAction = kUp;
    tank90.isCanFire = YES;
    
    [tank90 bronInformation];
    return tank90;
}

//初始动画
- (void)bronInformation{
  [self animationBorn];
    
   [self scheduleOnce:@selector(animationShield) delay:1/2];
   [self scheduleOnce:@selector(removeShield) delay:5];
    
    
}
//坦克消失动画
- (void)animationBang {
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    CCSpriteFrame* f1 ;
    for (int i = 1; i < 3; i++) {
        NSString* name = [NSString stringWithFormat:@"explode%1d.png",i];
        f1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
        [array addObject:f1];
    }
    
    CCAnimation* anim = [CCAnimation animationWithSpriteFrames:array delay:0.1];
    
    [anim setRestoreOriginalFrame:YES];
    
    CCAnimate *animate = [CCAnimate actionWithAnimation:anim];
    [self runAction:animate];
    [array removeAllObjects];
}




//坦克出现动画
- (void)animationBorn {
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    CCSpriteFrame* f1 ;
    for (int i = 1; i < 5; i++) {
        NSString* name = [NSString stringWithFormat:@"xing%1d.png",i];
        f1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
        [array addObject:f1];
    }
    
    CCAnimation* anim = [CCAnimation animationWithSpriteFrames:array delay:0.1];
    [anim setRestoreOriginalFrame:YES];
    CCAnimate *animate = [CCAnimate actionWithAnimation:anim];
    [self runAction:animate];
    [array removeAllObjects];
}
//保护层动画
- (void)animationShield {
    
    
    _isProtect = YES;
    
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    CCSpriteFrame* f1 ;
    for (int i = 1; i < 3; i++) {
        NSString* name = [NSString stringWithFormat:@"shield%1d.png",i];
        f1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
        [array addObject:f1];
    }
    
    CCAnimation* anim = [CCAnimation animationWithSpriteFrames:array delay:0.2];
    
    CCAnimate *animate = [CCAnimate actionWithAnimation:anim];
    CCAction* action = [CCRepeatForever actionWithAction:animate];
    
       CCSprite* backAn = [CCSprite node];
    
    
    backAn.position = ccp(backAn.position.x + self.contentSize.width/2,backAn.position.y + self.contentSize.height/2);//精灵出生时，坐标为0，0.
    [backAn runAction:action];
    [self addChild:backAn z:1 tag:1001];//将此执行动画的精灵加到坦克精灵上
    [array removeAllObjects];
}
- (void)removeShield {
    
    CCSprite* backAnim = (CCSprite *)[self getChildByTag:1001];
    [backAnim removeFromParentAndCleanup:YES];
    
    _isProtect = NO;
}





//坦克被击中
- (void)topButtle{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"blast.aif"];
    [self animationBang];
     _isProtect = YES;
     [self schedule:@selector(checkLife) interval:0.3];

}
//中弹后检查生命
- (void)checkLife {
  [self unschedule:@selector(checkLife)];
  [self setVisible:NO];


    if (_life > 1){
        _life--;
        kkTank90TotalLife--;
        self.position = self.bornPosition;
        
        [self bronInformation];
        self.rotation = 0;
        _kAction = kUp;
        [self setVisible:YES];
        [_delegate changeLife:self];
        
    }else {
        _life--;
        kkTank90TotalLife--;
        [_delegate changeLife:self];
        if(kkTank90TotalLife<=0){
            [_delegate gameOver:self];
        }
    }


}





/**********************************移动方向********************************************/
- (BOOL)checkPoint:(CGPoint)pon {
    
    CGPoint tnp = pon;
    unsigned int tid;
    tid = [_delegate tileIDFromPosition:tnp aTank:self];
  //  NSLog(@"tid反反复复反反复复凤飞飞=%d",tid);
    //如果瓦片不是 0，9，10，37，38，那么坦克就不能走,这些ID只的是空或者草坪
    if (tid != 0 && tid != 9 && tid != 10 && tid != 37 && tid != 38 ) return YES;
    
    tid = [_delegate tileIDFromPositionLayer2:tnp aTank:self];
    if (tid != 0) return YES;
    return NO;
}
//监测我方坦克和敌方坦克的碰撞
-(BOOL)checkTankPosition{
    
      NSMutableArray* array = [_delegate enemyArray:self];
     CGPoint point;
     CGPoint tp = self.position;
    if (_kAction == kUp){
        point = ccp(tp.x,tp.y + self.boundingBox.size.height / 2 + _speed);
    }else if (_kAction == kDown){
        point = ccp(tp.x,tp.y - self.boundingBox.size.height / 2 - _speed);
    }else if (_kAction == kLeft) {
        point =  ccp(tp.x - self.boundingBox.size.width/2 - _speed,tp.y);
    }else if (_kAction == kRight) {
        point = ccp(tp.x + self.boundingBox.size.width/2 + _speed,tp.y);
    }
    CGRect tankEnemy;
    for (Tank90Sprite * tank in array) {
        tankEnemy = CGRectMake(tank.position.x - tank.boundingBox.size.width/2,
                               tank.position.y - tank.boundingBox.size.height/2,
                               tank.boundingBox.size.width,
                               tank.boundingBox.size.height);
        if (CGRectContainsPoint(tankEnemy, point)){
            return YES;
        }
    }
    return NO;
    
}

//检测是否吃了工具包
- (void)checkTool {
    NSMutableArray* arr = [[_delegate toolsArray:self] copy];
    CGRect tankRect,propRect;
    tankRect = CGRectMake(self.position.x - self.boundingBox.size.width/2,
                          self.position.y - self.boundingBox.size.height/2,
                          self.boundingBox.size.width,
                          self.boundingBox.size.height);
    
    for (ToolSprite* pro in arr) {
        
        propRect = CGRectMake(pro.position.x - pro.contentSize.width/2,
                              pro.position.y - pro.contentSize.height/2,
                              pro.contentSize.width, pro.contentSize.height);
        if (pro.visible == NO) continue;
        
        if (CGRectContainsPoint(tankRect, pro.position)){
            pro.visible = NO;
            _tmpTool = pro;
            [self changeTankStatus:pro];
            [_delegate removeTool:_tmpTool];
        }
        
    }

}
- (void)changeTankStatus:(ToolSprite *)tool {
  
    if (tool.kind == kStart) {//坦克装备升级
        if (self.kind == kBorn){
            [[SimpleAudioEngine sharedEngine] playEffect:@"award.aif"];
            self.kind = kPlusStarOne;
            self.speed = 1.5;
            CCSpriteFrame* newFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"p1-a.png"];
            [self setDisplayFrame:newFrame];
        }else if (self.kind == kPlusStarOne) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"award.aif"];
            self.kind = kPlusStarTwo;
            self.speed = 1.5;
            CCSpriteFrame* newFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"p1-b.png"];
            [self setDisplayFrame:newFrame];
            
        }else if (self.kind == kPlusStarTwo) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"award.aif"];
            self.kind = kPlusStarThree;
            self.speed = 1.5;
            CCSpriteFrame* newFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"p1-c.png"];
            [self setDisplayFrame:newFrame];
            
        }else {
            return;
        }
    }
    else if(tool.kind==kMine){//炸弹包，把敌方坦克全部炸掉
        [[SimpleAudioEngine sharedEngine] playEffect:@"tankbomb.aif"];
        [_delegate plusBoon:self];

    }
    else if(tool.kind==kLife){//增加一条命
        [[SimpleAudioEngine sharedEngine] playEffect:@"addlife.aif"];
        _life++;
         [_delegate changeLife:self];
    }
    else if (tool.kind == kPass) {//暂停坦克
        [[SimpleAudioEngine sharedEngine] playEffect:@"award.aif"];
        [_delegate plusPass:self];
        
    }
    else if (tool.kind == kSafe) {//增加坦克保护层
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"award.aif"];
        
        if (_isProtect) {
             return;
        }
        [self animationShield];
        [self scheduleOnce:@selector(removeShield) delay:10];
        
    }
    else if (tool.kind == kWall) {//把老家外面加上铁板
        [[SimpleAudioEngine sharedEngine] playEffect:@"award.aif"];
        _isHomeProtect = YES;
        [_delegate homeProtect:YES aTank:self];
        [self scheduleOnce:@selector(removeHomeProtect) delay:10];
    }

    
}


- (void)removeHomeProtect {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    _isHomeProtect = NO;
    [_delegate homeProtect:NO aTank:self];
}

- (void)playMoveVideo {
    [[SimpleAudioEngine sharedEngine] playEffect:@"move.aif"];
}
- (void)moveUp {
    
    
    [self setRotation:0];
    _kAction = kUp;
    
    CGPoint tp = self.position;
    CGPoint tnp = ccp(tp.x,tp.y + self.boundingBox.size.height / 2 + _speed);
    
    
    if (tnp.y > _mapSize.height ) return;
    if ([self checkPoint:tnp]) return;
    
    //左上角监测
    tnp = ccp(tp.x - self.boundingBox.size.width/2,tp.y + self.boundingBox.size.height / 2 + _speed);
    if ([self checkPoint:tnp]) return;
    
    tnp = ccp(tp.x - self.boundingBox.size.width/3,tp.y + self.boundingBox.size.height / 2 + _speed);
    if ([self checkPoint:tnp]) return;
    
    //右上角监测
    tnp = ccp(tp.x + self.boundingBox.size.width/2,tp.y + self.boundingBox.size.height / 2 + _speed);
    if ([self checkPoint:tnp]) return;
    
    tnp = ccp(tp.x + self.boundingBox.size.width/3,tp.y + self.boundingBox.size.height / 2 + _speed);
    if ([self checkPoint:tnp]) return;
    
    
    
    
    if ([self checkTankPosition]){
        return;
    }
    [self checkTool];
    
    self.position = ccp(self.position.x,self.position.y  + _speed);
//    static int  iii=0;
//    iii++;
//    if(iii==60){
        [self playMoveVideo];
//        iii=0;
//    }
}

- (void)moveDown {
    
    [self setRotation:180];
    _kAction = kDown;
    
    CGPoint tp = self.position;
    CGPoint tnp = ccp(tp.x,tp.y - self.boundingBox.size.height / 2 - _speed);
    
    if ((tp.y - self.boundingBox.size.height/2 - _speed) < 0) return;
    
    if ([self checkPoint:tnp]) return;
    
    tnp = ccp(tp.x - self.boundingBox.size.width/2,tp.y - self.boundingBox.size.height / 2 - _speed);
    if ([self checkPoint:tnp]) return;
    
    tnp = ccp(tp.x - self.boundingBox.size.width/3,tp.y - self.boundingBox.size.height / 2 - _speed);
    if ([self checkPoint:tnp]) return;
    
    tnp = ccp(tp.x + self.boundingBox.size.width/2,tp.y - self.boundingBox.size.height / 2 - _speed);
    if ([self checkPoint:tnp]) return;
    
    tnp = ccp(tp.x + self.boundingBox.size.width/3,tp.y - self.boundingBox.size.height / 2 - _speed);
    if ([self checkPoint:tnp]) return;
    if ([self checkTankPosition]){
        return;
    }
    
    [self checkTool];
    self.position = ccp(self.position.x,self.position.y  - _speed);
}



- (void)moveLeft{
    
    [self setRotation:-90];
    _kAction = kLeft;
    
    CGPoint tp = self.position;
    CGPoint tnp = ccp(tp.x - self.boundingBox.size.width/2 - _speed,tp.y);
    
    if ((tp.x - self.boundingBox.size.width/2 - _speed) < 0) return;
    
    if ([self checkPoint:tnp]) return;
    
    tnp = ccp(tp.x - self.boundingBox.size.width/2 - _speed,tp.y + self.boundingBox.size.height/2 - 2);
    if ([self checkPoint:tnp]) return;
    
    tnp = ccp(tp.x - self.boundingBox.size.width/2 - _speed,tp.y + self.boundingBox.size.height/3);
    if ([self checkPoint:tnp]) return;
    
    tnp = ccp(tp.x - self.boundingBox.size.width/2 - _speed,tp.y - self.boundingBox.size.height/2 + 2);
    if ([self checkPoint:tnp]) return;
    
    tnp = ccp(tp.x - self.boundingBox.size.width/2 - _speed,tp.y - self.boundingBox.size.height/3);
    if ([self checkPoint:tnp]) return;
    if ([self checkTankPosition]){
        return;
    }
    [self checkTool];
    self.position = ccp(self.position.x - _speed,self.position.y);
}



- (void)moveRight {
    
    [self setRotation:90];
    _kAction = kRight;
    
    CGPoint tp = self.position;
    
    CGPoint tnp = ccp(tp.x + self.boundingBox.size.width/2 + _speed,tp.y); //计算向左将
    if ((tp.x + self.boundingBox.size.width/2 + _speed) > _mapSize.width )return;
    
    
    if ([self checkPoint:tnp]) return;
    
    tnp = ccp(tp.x + self.boundingBox.size.width/2 + _speed,tp.y + self.boundingBox.size.height/2 - 2);
    if ([self checkPoint:tnp]) return;
    
    tnp = ccp(tp.x + self.boundingBox.size.width/2 + _speed,tp.y + self.boundingBox.size.height/3);
    if ([self checkPoint:tnp]) return;
    
    tnp = ccp(tp.x + self.boundingBox.size.width/2 + _speed,tp.y - self.boundingBox.size.height/2 + 2);
    if ([self checkPoint:tnp]) return;
    
    tnp = ccp(tp.x + self.boundingBox.size.width/2 + _speed,tp.y - self.boundingBox.size.height/3);
    if ([self checkPoint:tnp]) return;
    
    
    if ([self checkTankPosition]){
        return;
    }
    
    [self checkTool];
    self.position = ccp(self.position.x  + _speed,self.position.y);
}






//开火
- (void)onFire{
    if (self.life == 0) {
        return;
    }
    CCSpriteFrame* frameButtle = FRAME(@"bullet.png");
  
    if (_kind == kPlusStarTwo || _kind == kPlusStarThree) {
        
        if (_buttleCount <= 2){
            
            _buttleOrientation = _kAction;     //子弹运行的方向
            CCSprite* buttle = [CCSprite spriteWithSpriteFrame:frameButtle];
            buttle.visible = NO;
            [_delegate initButtleDidFinish:self buttle:buttle];
            [self fire:buttle orientation:_kAction];
            _buttleCount++;
            if (_buttleCount > 2){
                [self scheduleOnce:@selector(canFire2) delay:1];//延迟吧字段数更新为0，否则下面得else不会走
            }
            
        }else {
            return;
        }
        
    }
    else if (_kind == kBorn || _kind == kPlusStarOne) {
        if(_isCanFire==NO)return;
        _buttleOrientation=_kAction;//子弹运行方向
        CCSprite* buttle = [CCSprite spriteWithSpriteFrame:frameButtle];
        //初始化子弹
        [_delegate initButtleDidFinish:self buttle:buttle];
        buttle.visible = NO;
        _isCanFire = NO;
        
        [self fire:buttle orientation:_kAction];

    }
}
//射出子弹
- (void)fire:(CCSprite *)buttle orientation:(Tank90Action)buttleOrientation {
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"bullet.aif"];
    CGPoint ptn;
    
    switch (buttleOrientation) {
            
        case kUp:{
            [buttle     setRotation:0];
            
            [buttle setPosition:ccp(self.position.x,self.position.y + self.boundingBox.size.height/2)];
            
            
            ptn = ccp(self.position.x,self.position.y + _mapSize.width);
            break;
        }
        case kDown:{
            [buttle setRotation:180];
            [buttle setPosition:ccp(self.position.x,self.position.y - self.boundingBox.size.height/2)];
            
            ptn = ccp(self.position.x,self.position.y - _mapSize.width);
            break;
        }
        case kLeft:{
            [buttle setRotation:-90];
            [buttle setPosition:ccp(self.position.x - self.boundingBox.size.width/2,self.position.y)];
            
            
            ptn = ccp(self.position.x - _mapSize.width,self.position.y);
            break;
        }
        case kRight:{
            [buttle setRotation:90];
            [buttle setPosition:ccp(self.position.x + self.boundingBox.size.width/2,self.position.y)];
            
            ptn = ccp(self.position.x + _mapSize.width,self.position.y);
            break;
        }
        default:
            break;
    }
    
    
    const CGPoint realyPosition = ptn;
    
    
    id ac1 = [CCShow action];
    id ac2 = [CCMoveTo actionWithDuration:2 position:realyPosition];
    id ac3 = [CCCallFunc actionWithTarget:self selector:@selector(makeCanFire)]; //解决bug
    id seq = [CCSequence actions:ac1,ac2,ac3,nil];
    [buttle runAction:seq];
    
    //这是一个不错的技巧哦，加一个循环函数
    _timer = [NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(checkBang:) userInfo:buttle repeats:YES];
}
- (void)checkBang:(NSTimer *)timer{

    if(_timer==timer)
    {
        int ff=0;
    
    }
    CCSprite* buttle = [timer userInfo];
  
    CGPoint btPoint = buttle.position;
    //得到瓦片gid
    unsigned gid = [_delegate tileIDFromPosition:btPoint aTank:self];

    if (gid == -1){ //这种情况一般不发生
        [timer invalidate];
        _timer = nil;
        [buttle removeFromParentAndCleanup:YES];
        _isCanFire = YES;
        return;
    }

    if ([self checkLayer2:buttle]) {
        [timer invalidate];_timer = nil;
        [buttle removeFromParentAndCleanup:YES];
        _isCanFire = YES;
        return;
    }
        //检查老家是否被干掉
        if ([self checkHome:buttle]) {
            [timer invalidate];_timer = nil;
            [buttle removeFromParentAndCleanup:YES];
            _isCanFire = YES;
            return;
        }
        //检查墙壁碰撞
         if ([self checkWall:buttle]) {
             [timer invalidate];_timer = nil;
             [buttle removeFromParentAndCleanup:YES];
              _isCanFire = YES;
              return;
       }
      //检查钢板碰撞
    if ([self checkStrongWall:buttle]) {
        [timer invalidate];_timer = nil;
        [buttle removeFromParentAndCleanup:YES];
        _isCanFire = YES;
        return;
    }
    //击中敌人的监测
    NSMutableArray* enemys = [_delegate enemyArray:self];
    CGRect buttleRect;
    CGRect tankEnemy;
    for (Tank90Sprite* tank in enemys) {
        //我方子弹范围
        buttleRect = CGRectMake(buttle.position.x - buttle.contentSize.width/2,
                                buttle.position.y - buttle.contentSize.height/2,
                                buttle.contentSize.width,
                                buttle.contentSize.height);
        //敌方坦克范围
        tankEnemy = CGRectMake(tank.position.x - tank.boundingBox.size.width/2,
                               tank.position.y - tank.boundingBox.size.height/2,
                               tank.boundingBox.size.width,
                               tank.boundingBox.size.height);
        
        
        if (nil != tank.buttleSprite){
            if ( CGRectContainsPoint(buttleRect, [tank.buttleSprite position])){//如果子弹碰撞了
            
                [timer invalidate];_timer = nil;
                [buttle removeFromParentAndCleanup:YES];//我方子弹移除
                _isCanFire = YES;
                tank.isButtleDone = YES;
                return;

                
            }
        
        }
        if ( CGRectContainsPoint(tankEnemy, buttle.position)){//如果子弹击中了敌军坦克
        
            [timer invalidate];_timer = nil;
            [buttle removeFromParentAndCleanup:YES];
            _isCanFire = YES;
            _tmpTank = tank;
            
             [self checkEnemyKind:tank];

        }
    }
    if (_isTankDone){
        [[SimpleAudioEngine sharedEngine] playEffect:@"blast.aif"];
        [_tmpTank animationBang];
        [_delegate removeSprite:_tmpTank];
        _isTankDone = NO;
        return;
    }

    //监测子弹是否超出屏幕了
    if([self checkBound:buttle]){
        [timer invalidate];
        _timer = nil;
        _isCanFire = YES;
        [buttle removeFromParentAndCleanup:YES];
        return;

    }
}


- (void)checkEnemyKind:(Tank90Sprite *)aTank2 {
    
    TankEnemySprite *aTank= (TankEnemySprite *)aTank2;
    CCSpriteFrame* frame;
    switch (aTank.kind) {
            
        case kSlow:{
            _isTankDone = YES;
            break;
        }
        case kQuike:{
            _isTankDone = YES;
            break;
        }
        case kStrong:{
            _isTankDone = YES;
            break;
        }
        case kStrongYellow:{
            if (aTank.life == 2){
                aTank.life--;
                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"en6.png"];
                aTank.kind = kStrong;
                [aTank setDisplayFrame:frame];
            }else {
                _isTankDone = YES;
            }
            break;
        }
        case kStrongRedLife3:{
            
            if (aTank.isRead) {
                [_delegate createTool];
                aTank.isRead = NO;
            }
            if (aTank.life == 3){
                aTank.life--;
                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"en5.png"];
                aTank.kind = kStrongYellow;
                [aTank setDisplayFrame:frame];
            }else if (aTank.life == 2){
                aTank.life--;
                aTank.kind = kStrong;
                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"en6.png"];
                [aTank setDisplayFrame:frame];
            }
            else {
                _isTankDone = YES;
            }
            break;
        }
        case kStrongRed:{
            
            [_delegate createTool];
            _isTankDone = YES;
            break;
        }
        case kStrongGreen:{
            if (aTank.life == 3){
                aTank.life--;
                aTank.kind = kStrongYellow;
                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"en5.png"];
                [aTank setDisplayFrame:frame];
            }else if (aTank.life == 2){
                aTank.kind = kStrong;
                aTank.life--;
                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"en6.png"];
                [aTank setDisplayFrame:frame];
            }
            else {
                _isTankDone = YES;
            }
            break;
            
        }
        case kQuikeR:{
            
            [_delegate createTool];
            _isTankDone = YES;
            break;
        }
        case kSlowR:{
            
            [_delegate createTool];
            _isTankDone = YES;
            break;
        }
        default:
            break;
    }
}




//监测老家的防护墙
- (BOOL)checkLayer2:(CCSprite *)buttle {
    
    if (!_isHomeProtect) return NO; //没有被保护，那么包围老鹰的就是普通砖头或者空的，直接不用监测，后面会有方法监测砖头
    CGPoint btPoint = buttle.position;
    unsigned gid = [_delegate tileIDFromPositionLayer2:btPoint aTank:self];
    if (0 != gid){ //是钢板
        return YES;
    }
    return NO; //钢板没有，不检测
}



//检查铁板碰撞
- (BOOL)checkStrongWall:(CCSprite *)buttle {
    
    CGPoint btPoint = buttle.position;
    unsigned gid = [_delegate tileIDFromPosition:btPoint aTank:self];
    
    
    if (gid == 5 || gid ==6 ||gid ==33 ||gid == 34 ) {
        
        if (_kind == kPlusStarThree) { //当是三级导弹的时候，才能够击穿钢板
            
            [_delegate destpryTile:ccp(btPoint.x,btPoint.y) aTank:self];
            
            _isCanFire = YES;
            if ( _buttleOrientation == kUp){
                if (gid == 33) {
                    
                    [_delegate destpryTile:ccp(btPoint.x,btPoint.y + 8) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x + 8,btPoint.y) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x+8,btPoint.y+8) aTank:self];
                }else if (gid == 34){
                    
                    [_delegate destpryTile:ccp(btPoint.x,btPoint.y+8) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x - 8,btPoint.y) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x-8,btPoint.y+8) aTank:self];
                }
                return YES;
                
            }else if (_buttleOrientation == kDown){
                if (gid == 5) {
                    
                    [_delegate destpryTile:ccp(btPoint.x,btPoint.y - 8) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x + 8,btPoint.y) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x + 8,btPoint.y-8) aTank:self];
                }else if (gid == 6){
                    
                    [_delegate destpryTile:ccp(btPoint.x,btPoint.y-8) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x - 8,btPoint.y) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x-8,btPoint.y-8) aTank:self];
                }
                return YES;
                
            }else if (_buttleOrientation == kLeft){
                if (gid == 34){
                    
                    [_delegate destpryTile:ccp(btPoint.x - 8,btPoint.y) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x,btPoint.y +8) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x-8,btPoint.y+8) aTank:self];
                }else if(gid == 6){
                    
                    [_delegate destpryTile:ccp(btPoint.x- 8,btPoint.y) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x,btPoint.y - 8) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x - 8,btPoint.y -8) aTank:self];
                }
                return YES;
            }else if (_buttleOrientation == kRight){
                
                if (gid == 5){
                    
                    [_delegate destpryTile:ccp(btPoint.x + 8,btPoint.y) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x,btPoint.y -8) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x+8,btPoint.y-8) aTank:self];
                }else if(gid == 33){
                    
                    [_delegate destpryTile:ccp(btPoint.x,btPoint.y + 8) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x +8,btPoint.y) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x +8,btPoint.y +8) aTank:self];
                }
                return YES;
            }
            
        }else {
            return YES;
        }
        
    }
    return NO;
}
//检查墙壁碰撞
- (BOOL)checkWall:(CCSprite *)buttle
{
    
    CGPoint btPoint = buttle.position;
    unsigned gid,gid1,gid2,gid3,gid4;
    gid = [_delegate tileIDFromPosition:btPoint aTank:self];
    
    
    if (_buttleOrientation == kUp || _buttleOrientation == kDown)
    {
        
        gid1 = [_delegate tileIDFromPosition:ccp(btPoint.x - 8, btPoint.y) aTank:self];//左边第一个
        gid2 = [_delegate tileIDFromPosition:ccp(btPoint.x + 8, btPoint.y) aTank:self];//右臂那第一个
        gid3 = [_delegate tileIDFromPosition:ccp(btPoint.x - 16, btPoint.y) aTank:self];//左边第二个
        gid4 = [_delegate tileIDFromPosition:ccp(btPoint.x + 16, btPoint.y) aTank:self];//右边第二个
        
        
        if ( gid == 30||gid==1||gid==2||gid==29)//这四个id都是砖头的，瓦片编辑器的ID+1
        {
            
            [_delegate destpryTile:btPoint aTank:self];// 消除本身；
            
            
            if ((gid1 == 29 || gid1 == 30 || gid1 == 2 || gid1 == 1) && (gid2 == 29 || gid2 == 30 || gid2== 2 || gid2 == 1)) //左红，右红
            {
                
                
                if (gid4 == 29 || gid4 == 30 || gid4 == 2 || gid4 == 1 ) //如果右2为红， 消左1、右1、右2；
                {
                    [_delegate destpryTile:ccp(btPoint.x - 8, btPoint.y) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x + 8, btPoint.y) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x + 16, btPoint.y) aTank:self];
                    return YES;
                }
                else  //（右2为空或者非红）
                {
                    if (gid3 == 0) //左2为空,消左1、右1；
                    {
                        [_delegate destpryTile:ccp(btPoint.x - 8, btPoint.y) aTank:self];
                        [_delegate destpryTile:ccp(btPoint.x + 8, btPoint.y) aTank:self];
                        return YES;
                    }
                    else if (gid3 == 29 || gid3 == 30 || gid3 == 2 || gid3 == 1)//（左2为红）消除左1、左2、右1；
                    {
                        [_delegate destpryTile:ccp(btPoint.x - 8, btPoint.y) aTank:self];
                        [_delegate destpryTile:ccp(btPoint.x - 16, btPoint.y) aTank:self];
                        [_delegate destpryTile:ccp(btPoint.x + 8, btPoint.y) aTank:self];
                        return YES;
                    }else //左2非红）消除左1、右1；
                    {
                        [_delegate destpryTile:ccp(btPoint.x - 8, btPoint.y) aTank:self];
                        [_delegate destpryTile:ccp(btPoint.x + 8, btPoint.y) aTank:self];
                        return YES;
                    }
                }
                
            }
            
            
            if ((gid1 == 29 || gid1 == 30 || gid1 == 2 || gid1 == 1) && gid2 == 0) //左红、右空） 消除左1；
            {
                [_delegate destpryTile:ccp(btPoint.x - 8, btPoint.y) aTank:self];
                return YES;
            }
            
            
            if (gid1 == 0 && (gid2 == 29 || gid2 == 30 || gid2== 2 || gid2 == 1)) //（左空、右红） 消除右1；
            {
                [_delegate destpryTile:ccp(btPoint.x + 8, btPoint.y) aTank:self];
                return YES;
            }
            
            if ((gid1 != 1 && gid1 != 2 && gid1 != 29 && gid1 != 30 && gid1 != 0) && gid2 == 0) //（左非红、右空） 消除自身
            {
                return YES;
            }
            
            
            if ((gid1 != 1 && gid1 != 2 && gid1 != 29 && gid1 != 30 && gid1 != 0) && (gid2 == 29 || gid2 == 30 || gid2== 2 || gid2 == 1)) //（左非红、右红）消右1
            {
                [_delegate destpryTile:ccp(btPoint.x + 8, btPoint.y) aTank:self];
                return YES;
            }
            
            
            
            
            if ((gid2 != 1 && gid2 != 2 && gid2 != 29 && gid2 != 30 && gid2 != 0) && (gid1 == 29 || gid1 == 30 || gid1 == 2 || gid1 == 1)) //右非红、左红） 消左1
            {
                [_delegate destpryTile:ccp(btPoint.x - 8, btPoint.y) aTank:self];
                return YES;
            }
            
            
            if ((gid2 != 1 && gid2 != 2 && gid2 != 29 && gid2 != 30 && gid2 != 0) && gid1 == 0)//（右非红、左空） 消除自身
            {
                return YES;
            }
            
            
            if (gid1 == 0 && gid2 == 0) { //左空、右空  消除自身
                return YES;
            }
        }
    }
    
    
    if (_buttleOrientation == kLeft || _buttleOrientation == kRight)
    {
        
        gid1 = [_delegate tileIDFromPosition:ccp(btPoint.x, btPoint.y - 8) aTank:self];
        gid2 = [_delegate tileIDFromPosition:ccp(btPoint.x, btPoint.y + 8) aTank:self];
        gid3 = [_delegate tileIDFromPosition:ccp(btPoint.x, btPoint.y - 16) aTank:self];
        gid4 = [_delegate tileIDFromPosition:ccp(btPoint.x, btPoint.y + 16) aTank:self];
        
        
        if (gid == 29 || gid == 30 || gid == 2 || gid == 1)
        {
            
            [_delegate destpryTile:btPoint aTank:self];
            
            
            if ((gid1 == 29 || gid1 == 30 || gid1 == 2 || gid1 == 1) && (gid2 == 29 || gid2 == 30 || gid2== 2 || gid2 == 1))
            {
                
                
                if (gid4 == 29 || gid4 == 30 || gid4 == 2 || gid4 == 1 )
                {
                    [_delegate destpryTile:ccp(btPoint.x, btPoint.y - 8) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x, btPoint.y + 8) aTank:self];
                    [_delegate destpryTile:ccp(btPoint.x, btPoint.y + 16) aTank:self];
                    return YES;
                }
                else
                {
                    if (gid3 == 0)
                    {
                        [_delegate destpryTile:ccp(btPoint.x, btPoint.y - 8) aTank:self];
                        [_delegate destpryTile:ccp(btPoint.x, btPoint.y + 8) aTank:self];
                        return YES;
                    } else if (gid3 == 29 || gid3 == 30 || gid3 == 2 || gid3 == 1)
                    {
                        [_delegate destpryTile:ccp(btPoint.x, btPoint.y - 8) aTank:self];
                        [_delegate destpryTile:ccp(btPoint.x, btPoint.y - 16) aTank:self];
                        [_delegate destpryTile:ccp(btPoint.x, btPoint.y + 8) aTank:self];
                        return YES;
                    }else
                    {
                        [_delegate destpryTile:ccp(btPoint.x, btPoint.y - 8) aTank:self];
                        [_delegate destpryTile:ccp(btPoint.x, btPoint.y + 8) aTank:self];
                        return YES;
                    }
                }
                
            }
            
            
            if ((gid1 == 29 || gid1 == 30 || gid1 == 2 || gid1 == 1) && gid2 == 0)
            {
                [_delegate destpryTile:ccp(btPoint.x, btPoint.y - 8) aTank:self];
                return YES;
            }
            
            
            if (gid1 == 0 && (gid2 == 29 || gid2 == 30 || gid2== 2 || gid2 == 1))
            {
                [_delegate destpryTile:ccp(btPoint.x, btPoint.y + 8) aTank:self];
                return YES;
            }
            
            
            if ((gid1 != 1 && gid1 != 2 && gid1 != 29 && gid1 != 30 && gid1 != 0) && (gid2 == 29 || gid2 == 30 || gid2== 2 || gid2 == 1))
            {
                [_delegate destpryTile:ccp(btPoint.x, btPoint.y + 8) aTank:self];
                return YES;
            }
            
            
            if ((gid1 != 1 && gid1 != 2 && gid1 != 29 && gid1 != 30 && gid1 != 0) && gid2 == 0)
            {
                return YES;
            }
            
            
            if ((gid2 != 1 && gid2 != 2 && gid2 != 29 && gid2 != 30 && gid2 != 0) && (gid1 == 29 || gid1 == 30 || gid1 == 2 || gid1 == 1))
            {
                [_delegate destpryTile:ccp(btPoint.x, btPoint.y - 8) aTank:self];
                return YES;
            }
            
            
            if ((gid2 != 1 && gid2 != 2 && gid2 != 29 && gid2 != 30 && gid2 != 0) && gid1 == 0)
            {
                return YES;
            }
            
            
            if (gid1 == 0 && gid2 == 0) {
                return YES;
            }
            
        }
        
    }
    
    return NO;
}

//检查老家是不是被干掉了
-(BOOL)checkHome:(CCSprite *)buttle{
    CGRect rc=_homeRect;
    if(CGRectContainsPoint(rc, buttle.position)){//被子弹击中了
        if(_isHomeProtect)return YES;
        if(!_isHomeDone){
            _isHomeDone=YES;
            [self.delegate gameOver:self];
        }
        return YES;
    }
    return NO;
}

//检查子弹是否超出了边界
- (BOOL)checkBound:(CCSprite *)buttle {
    
    if ((buttle.position.y + buttle.contentSize.height/2) > _mapSize.height){
        
        
        return YES;
        
    }
    
    else if((buttle.position.y - buttle.contentSize.height/2) < 0){
        
        
        return YES;
    }
    
    else if((buttle.position.x - buttle.contentSize.width/2) < 0){
        
        
        return YES;
    }
    
    else if((buttle.position.x + buttle.contentSize.width/2) > _mapSize.width){
        
        return YES;
    }
    return NO;
}


- (void)canFire2 {
    
    _buttleCount = 0;
    
}

- (void)makeCanFire {
    _isCanFire = YES;
}


-(void)removeSelfFromMap {
    
    [self removeFromParentAndCleanup:YES];
}







- (void)onExit {
    [super onExit];
    if (nil != _timer) {
       
        if ([_timer isValid]) {
             [_timer invalidate];
            _timer = nil;
        }
    }
    _delegate = nil;
}

@end
