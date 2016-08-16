//
//  MainScene.m
//  Tank90
//
//  Created by song on 15/4/24.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import "MainScene.h"
#import "InputLayer.h"
#import "MapLayer.h"
#import "SimpleAudioEngine.h"
#import "Tank90Sprite.h"
@interface MainScene()<MapLayerDelegate>{
    NSMutableArray *_iconArray;

     CCLabelTTF* _1plifeString;//p1生命数
     CCLabelTTF* _2plifeString;//p1生命数
    
     CCLabelTTF* _leveString;
    
    InputLayer * _inputLayer;
    
    MapLayer *_mapLayer;
}
@end

@implementation MainScene
+(id)scene {
    
    MainScene* scene = [MainScene node];
    
    return scene;

}
- (id)initWithMapInformation:(int)leve status:(int)status life:(int)life {
    
    self = [super init];
    
    if (self != nil){
        if([kkDanJi intValue]==1){
            kkTank90TotalLife=life;
        }
        else{
            kkTank90TotalLife=life*2;
        }
        
         [[SimpleAudioEngine sharedEngine] playEffect:@"02 start.aif"];
        
        //背景
        CCLayerColor* backColor = [CCLayerColor layerWithColor:ccc4(192,192,192,255)];
        [self addChild:backColor];
        
         _winSize = [[CCDirector sharedDirector] winSize];
        
        //纹理缓存
        _frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [_frameCache addSpriteFramesWithFile:@"images.plist"];
        
        _iconArray=[NSMutableArray new];
        
        [self iconTank];//敌军坦克图标
        
        
        //生命值布局 p1 //生命值布局 p2
        CCSpriteFrame* ipLifeFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"IP.png"];
        CCSprite* ipLife = [CCSprite spriteWithSpriteFrame:ipLifeFrame];
        ipLife.position = ccp(30,_winSize.height - 50);
        [self addChild:ipLife];
        
        CCSpriteFrame* ipIconFrmae = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"p1.png"];
        CCSprite* ipLifeIcok = [CCSprite spriteWithSpriteFrame:ipIconFrmae];
        ipLifeIcok.position = ccp(20,_winSize.height - 70);
        ipLifeIcok.scale = 0.5f;
        [self addChild:ipLifeIcok];
        [self showLife:life];
        
        if([kkDanJi intValue]==0){
        CCSpriteFrame* ipIconFrmae2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"p2.png"];
        CCSprite* ipLifeIcok2 = [CCSprite spriteWithSpriteFrame:ipIconFrmae2];
        ipLifeIcok2.position = ccp(20,_winSize.height - 90);
        ipLifeIcok2.scale = 0.5f;
        [self addChild:ipLifeIcok2];
        [self showLife2:life];
        }
        
        
        
        
        //关卡
        CCSpriteFrame* flagFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flag.png"];
        CCSprite* flag = [CCSprite spriteWithSpriteFrame:flagFrame];
        flag.position  = ccp(_winSize.width - 50 , _winSize.height - 200);
        [self addChild:flag];
        [self showLeve:leve];
        
        
        
        
        
        

       
        _mapLayer = [[MapLayer alloc] initWithMap:leve kind:status life:life];
        _mapLayer.delegate = self;
        [self addChild:_mapLayer];
        
        [_mapLayer changeWidth:_winSize.height height:_winSize.height];
        _mapLayer.position = ccp(_winSize.width/2-_winSize.height/2,0);
        
     //    CGPoint ff=  _mapLayer.anchorPoint;
        
        //手柄
        _inputLayer = [InputLayer node];
         _inputLayer.mapLayer = _mapLayer;
        [self addChild:_inputLayer];

    }
    return self;
}
-(void)iconTank{
    
    
    int width = 55;
    int height = 15;
    
    
    CCSpriteFrame* iconFrame =[_frameCache spriteFrameByName:@"enemy.png"];
    
    
    CCSprite* iconA;
    CCSprite* iconB;
    
    
    for (int i = 0; i <10; i ++) {
        
        height += 15;
        iconA = [CCSprite spriteWithSpriteFrame:iconFrame];
        iconA.position = ccp(_winSize.width - width,_winSize.height - height);
        [self addChild:iconA];
        [_iconArray addObject:iconA];
        
        iconB = [CCSprite spriteWithSpriteFrame:iconFrame];
        iconB.position = ccp(_winSize.width - width + 18,_winSize.height - height);
        [self addChild:iconB];
        [_iconArray addObject:iconB];
    }
}
//刷新生命数
- (void)showLife:(int)numLife {
    
    [_1plifeString removeFromParentAndCleanup:YES];
    _1plifeString = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",numLife] fontName:@"Courier-Bold" fontSize:20];
    _1plifeString.color = ccc3(0, 0, 0);
    _1plifeString.position = ccp(45,_winSize.height - 70);
    [self addChild:_1plifeString];
}
- (void)showLife2:(int)numLife {
    
    [_2plifeString removeFromParentAndCleanup:YES];
    _2plifeString = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",numLife] fontName:@"Courier-Bold" fontSize:20];
    _2plifeString.color = ccc3(0, 0, 0);
    _2plifeString.position = ccp(45,_winSize.height - 90);
    [self addChild:_2plifeString];
}
//显示关卡
- (void)showLeve:(int)inLeve {
    
    [_leveString removeFromParentAndCleanup:YES];
    _leveString = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",inLeve] fontName:@"Courier-Bold" fontSize:20];
    _leveString.color = ccc3(0, 0, 0);
    _leveString.position = ccp(_winSize.width - 50 , _winSize.height - 230);
    [self addChild:_leveString];
}


/**************************************地图的回调委托*************************************/
- (void)bornEnmey {
    if (_iconArray.count > 0) {
        
        CCSprite* icon = [_iconArray lastObject];
        [icon removeFromParentAndCleanup:YES];
        [_iconArray removeLastObject];
    }
    
}

- (void)changeTankLife:(int)inLife andTank:(Tank90Sprite *)tank{
    if(tank.tag==100 )
    [self showLife:inLife];
    else if(tank.tag==101){
        [self showLife2:inLife];
    }
}













@end
