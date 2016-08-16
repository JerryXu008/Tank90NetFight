//
//  ScoreScene.m
//  Tank90
//
//  Created by song on 15/4/28.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import "ScoreScene.h"
#import "MainScene.h"
#import "WinScene.h"
@implementation ScoreScene
+(id)scene {
    
    CCScene* scene = [CCScene node];
    CCLayerColor* layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
    [scene addChild:layer];
    return scene;
}
- (id)initWithNumber:(int)slow quike:(int)quike strong:(int)strong strongY:(int)strongY strongG:(int)strongG leve:(int)leve_ kind:(int)kind_ life:(int)life_{
    
    if (self = [super init] ){
        [BonjourHelper sharedInstance].dataDelegate = self;
        winSize = [[CCDirector sharedDirector] winSize];
        layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
        [self addChild:layer];
        _slow = slow;
        _quike = quike;
        _strong = strong;
        _strongYe = strongY;
        _strongG = strongG;
        leve = leve_;
        kind = kind_;
        life = life_;
       
        CCLabelTTF* stageLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"STAGE %d",leve] fontName:@"Courier-Bold" fontSize:25];
        stageLabel.position = ccp(winSize.width/2,winSize.height/2 + 120);
        [layer addChild:stageLabel];
        
        
        [CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
        [CCMenuItemFont setFontSize:25];
         CCMenuItemFont* item1 = [CCMenuItemFont itemWithString:@"NEXT" target:self selector:@selector(menuItem1Touch)];
      
        
        CCMenu* menu = [CCMenu menuWithItems:item1 ,nil];
        menu.position = ccp(winSize.width - 70,30);
        [layer addChild:menu];
        
        
        [self score1];
        [self score2];
        [self score3];
        [self score4];
        [self score5];
        [self scoreSum];
    }
    return self;
}
- (void)score1 {
    // 1
    CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"en1.png"];
    CCSprite* tankSprite = [CCSprite spriteWithSpriteFrame:frame];
    tankSprite.scale = 0.7f;
    tankSprite.position = ccp(winSize.width/2 - 100,winSize.height/2 + 80);
    [layer addChild: tankSprite];
    
    
    CCSprite* sprite = [CCSprite spriteWithFile:@"jiantou.png"];
    sprite.position = ccp(winSize.width/2-50,winSize.height/2 + 80);
    sprite.scale = 1.5f;
    [layer addChild:sprite];

    CCLabelTTF* scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_slow*100] fontName:@"Courier-Bold" fontSize:20];
    scoreLabel.position = ccp(winSize.width/2+ 10,winSize.height/2 + 80);
    [layer addChild:scoreLabel];
    
    CCLabelTTF* numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%dpts",_slow] fontName:@"Courier-Bold" fontSize:20];
    numLabel.position = ccp(winSize.width/2 + 90,winSize.height/2 + 80);
    [layer addChild:numLabel];
}
- (void)score2 {
    CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"en2.png"];
    CCSprite* tankSprite = [CCSprite spriteWithSpriteFrame:frame];
    tankSprite.position = ccp(winSize.width/2 - 100,winSize.height/2 + 50);
    tankSprite.scale = 0.7f;
    [layer addChild: tankSprite];
    CCSprite* sprite = [CCSprite spriteWithFile:@"jiantou.png"];
    sprite.position = ccp(winSize.width/2-50,winSize.height/2 + 50);
    sprite.scale = 1.5f;
    [layer addChild:sprite];
    
    CCLabelTTF* scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_quike*200]  fontName:@"Courier-Bold" fontSize:20];
    scoreLabel.position = ccp(winSize.width/2+ 10,winSize.height/2 + 50);
    [layer addChild:scoreLabel];
    
    CCLabelTTF* numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%dpts",_quike] fontName:@"Courier-Bold" fontSize:20];
    numLabel.position = ccp(winSize.width/2 + 90,winSize.height/2 + 50);
    [layer addChild:numLabel];
}
- (void)score3 {
    CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"en6.png"];
    CCSprite* tankSprite = [CCSprite spriteWithSpriteFrame:frame];
    tankSprite.position = ccp(winSize.width/2 - 100,winSize.height/2 + 20);
    tankSprite.scale = 0.7f;
    [layer addChild: tankSprite];
    CCSprite* sprite = [CCSprite spriteWithFile:@"jiantou.png"];
    sprite.position = ccp(winSize.width/2-50,winSize.height/2 + 20);
    sprite.scale = 1.5f;
    [layer addChild:sprite];
    
    CCLabelTTF* scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_strong*500] fontName:@"Courier-Bold" fontSize:20];
    scoreLabel.position = ccp(winSize.width/2+ 10,winSize.height/2 + 20);
    [layer addChild:scoreLabel];
    
    CCLabelTTF* numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%dpts",_strong] fontName:@"Courier-Bold" fontSize:20];
    numLabel.position = ccp(winSize.width/2 + 90,winSize.height/2 + 20);
    [layer addChild:numLabel];
}
- (void)score4 {
    CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"en5.png"];
    CCSprite* tankSprite = [CCSprite spriteWithSpriteFrame:frame];
    tankSprite.position = ccp(winSize.width/2 - 100,winSize.height/2 - 10);
    tankSprite.scale = 0.7f;
    [layer addChild: tankSprite];
    CCSprite* sprite = [CCSprite spriteWithFile:@"jiantou.png"];
    sprite.position = ccp(winSize.width/2-50,winSize.height/2 - 10);
    sprite.scale = 1.5f;
    [layer addChild:sprite];
    
    CCLabelTTF* scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_strongYe*800] fontName:@"Courier-Bold" fontSize:20];
    scoreLabel.position = ccp(winSize.width/2+ 10,winSize.height/2 - 10);
    [layer addChild:scoreLabel];
    
    CCLabelTTF* numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%dpts",_strongYe] fontName:@"Courier-Bold" fontSize:20];
    numLabel.position = ccp(winSize.width/2 + 90,winSize.height/2 - 10);
    [layer addChild:numLabel];
}
- (void)score5 {
    CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"en3.png"];
    CCSprite* tankSprite = [CCSprite spriteWithSpriteFrame:frame];
    tankSprite.position = ccp(winSize.width/2 - 100,winSize.height/2 - 40);
    tankSprite.scale = 0.7f;
    [layer addChild: tankSprite];
    CCSprite* sprite = [CCSprite spriteWithFile:@"jiantou.png"];
    sprite.position = ccp(winSize.width/2-50,winSize.height/2 - 40);
    sprite.scale = 1.5f;
    [layer addChild:sprite];
    
    CCLabelTTF* scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_strongG*1000] fontName:@"Courier-Bold" fontSize:20];
    scoreLabel.position = ccp(winSize.width/2+ 10,winSize.height/2 - 40);
    [layer addChild:scoreLabel];
    
    CCLabelTTF* numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%dpts",_strongG] fontName:@"Courier-Bold" fontSize:20];
    numLabel.position = ccp(winSize.width/2 + 90,winSize.height/2 - 40);
    [layer addChild:numLabel];
}

- (void)scoreSum {
    
    int totalScore = _slow*100 + _quike*200+_strong*500+_strongYe*800+_strongG*1000;
    int totalNum = _slow + _quike + _strong + _strongYe + _strongG;
    
    CCLabelTTF* totalLabel = [CCLabelTTF labelWithString:@"TOTAL" fontName:@"Courier-Bold" fontSize:25];
    totalLabel.position = ccp(winSize.width/2- 120,winSize.height/2 - 80);
    [layer addChild:totalLabel];
    
    CCLabelTTF* scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",totalScore] fontName:@"Courier-Bold" fontSize:25];
    scoreLabel.position = ccp(winSize.width/2+ 10,winSize.height/2 - 80);
    [layer addChild:scoreLabel];
    
    CCLabelTTF* numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%dpts",totalNum] fontName:@"Courier-Bold" fontSize:25];
    numLabel.position = ccp(winSize.width/2+ 120,winSize.height/2 - 80);
    [layer addChild:numLabel];
    
}



- (void)menuItem1Touch {
    
    if (leve+1 > 20){
         if([kkDanJi intValue]==0){
        NSData *data=  [@"jieshu" dataUsingEncoding:NSUTF8StringEncoding];
       
        [BonjourHelper sendData:data];
            [[CCDirector sharedDirector] replaceScene:[WinScene scene]];
        }
        
    }else {
          if([kkDanJi intValue]==0){
        NSData *data=  [@"kaishi" dataUsingEncoding:NSUTF8StringEncoding];
        [BonjourHelper sendData:data];
          }
        MainScene* scene = [[MainScene alloc] initWithMapInformation:leve+1 status:kind life:3];
        [[CCDirector sharedDirector] replaceScene:scene];
        
    }
    
    
}
- (void) receivedData: (NSData *) thedata
{
    NSString *string = [[NSString alloc] initWithData:thedata encoding:NSUTF8StringEncoding] ;
    if ([string isEqualToString:@"kaishi"])
    {
     
        MainScene* scene = [[MainScene alloc] initWithMapInformation:leve+1 status:kind life:3];
        [[CCDirector sharedDirector] replaceScene:scene];

    }
    else if([string isEqualToString:@"jieshu"]){
         [[CCDirector sharedDirector] replaceScene:[WinScene scene]];
    }
    
}


@end
