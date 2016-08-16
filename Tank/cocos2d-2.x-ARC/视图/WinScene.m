//
//  WinScene.m
//  BattleCity
//
//  Created by 喆 肖 on 12-8-13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "WinScene.h"
#import "StartScene.h"

@implementation WinScene

+ (id)scene {
    
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    CCScene* scene = [WinScene node];
    
    CCLayerColor* layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
    CCSprite* sprite = [CCSprite spriteWithFile:@"gameover.png"];
    sprite.position = ccp(winSize.width/2,winSize.height/2);
    [layer addChild:sprite];
    [scene addChild:layer];
    
    return scene;
}
- (id)init {
    
    if (self = [super init]){
        [self scheduleOnce:@selector(gotoMainScene) delay:3];
    }
    return self;
}
- (void)gotoMainScene {
    [[CCDirector sharedDirector] replaceScene:[StartScene scene]];
}
@end
