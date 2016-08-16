//
//  ToolSprite.m
//  BattleCity
//
//  Created by 喆 肖 on 12-8-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ToolSprite.h"


@implementation ToolSprite

@synthesize kind = _kind;

+ (ToolSprite *)initWithKind:(ToolSpriteKind)inKind {
    
    CCSpriteFrame* frame;
    ToolSprite* propSprite;
    switch (inKind) {
        case kStart:{
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"props-start.png"];
            break; 
        }
        case kPass:{//定时器
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"props-timer.png"];
            
            break; 
        }
        case kLife:{
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"props-tank.png"];
            
            break; 
        }
        case kSafe:{
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"props-protect.png"];
            
            break; 
        }
        case kMine:{
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"props-mine.png"];
            
            break; 
        }
        case kWall:{
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"props-spade.png"];
            break; 
        }
            
        default:
            break;
    }
  
    propSprite = [ToolSprite spriteWithSpriteFrame:frame];
   // [propSprite setDisplayFrame:frame];
    propSprite.kind = inKind;
    return propSprite;
}
@end
