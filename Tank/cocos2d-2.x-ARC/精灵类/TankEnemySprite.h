//
//  TankEnemySprite.h
//  Tank90
//
//  Created by song on 15/4/28.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Tank90Sprite.h"

@protocol TankEnemySpriteDelegate;


@interface TankEnemySprite :  Tank90Sprite {
    
}

@property(nonatomic,assign)int score;

@property(nonatomic)  TankKind kind;//坦克类型
+ (TankEnemySprite *)initWithKind:(int)kind;
@property(nonatomic,assign)id<TankEnemySpriteDelegate> subDelegate;
@property(nonatomic,retain)Tank90Sprite* tank1;
@property(nonatomic,retain)Tank90Sprite* tank2;
+ (TankEnemySprite *)initWithKind:(int)kind;
- (void)stopTankAction;
-(void)removeSelfFromMap;
@end


@protocol TankEnemySpriteDelegate <NSObject,Tank90SpriteDelegate>

- (Tank90Sprite *)tankFromMap:(TankEnemySprite *)aTank;
@end
