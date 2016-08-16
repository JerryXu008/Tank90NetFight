//
//  ToolSprite.h
//  BattleCity
//
//  Created by 喆 肖 on 12-8-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    kStart = 1,
    kPass,    
    kLife,    
    kMine,    
    kSafe,    
    kWall     
}ToolSpriteKind;

@interface ToolSprite : CCSprite {
    ToolSpriteKind _kind;
}

@property(nonatomic,assign)ToolSpriteKind kind;
+ (ToolSprite *)initWithKind:(ToolSpriteKind)kind;

@end
