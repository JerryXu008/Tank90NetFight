//
//  Tank90Spirte.h
//  Tank90
//
//  Created by song on 15/4/27.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
typedef enum {
    kBorn = 1,
    kPlusStarOne,
    kPlusStarTwo,
    kPlusStarThree
}Tank90Kind;//90坦克种类

typedef  enum {
    
    kUp = 1,
    kDown,
    kLeft,
    kRight,
    kFire,
    kStay,
    kPause
    
}Tank90Action;

typedef enum {
    
    kP1 = 0,
    kSlow,
    kQuike,
    kStrong,
    kStrongYellow,
    kStrongRed,
    kStrongRedLife3,
    kStrongGreen,
    kQuikeR,
    kSlowR,
    
}TankKind;

@class Tank90Sprite;
@class ToolSprite;

@protocol Tank90SpriteDelegate <NSObject>
//图层1的Gid
- (int)tileIDFromPosition:(CGPoint)pon aTank:(Tank90Sprite *)aTank;
//图层2的Gid
- (int)tileIDFromPositionLayer2:(CGPoint)pon aTank:(Tank90Sprite *)aTank;
//返回敌军坦克数组
- (NSMutableArray *)enemyArray:(Tank90Sprite *)aTank;
//初始化子弹
- (void)initButtleDidFinish:(Tank90Sprite *)aTank buttle:(CCSprite *)buttle;
//游戏结束
- (void)gameOver:(Tank90Sprite *)tank;
//根据瓦片的坐标，消除瓦片
- (void)destpryTile:(CGPoint)pon aTank:(Tank90Sprite *)aTank;
//移除被击中的坦克
- (void)removeSprite:(Tank90Sprite *)aTank;
//改变生命值
- (void)changeLife:(Tank90Sprite *)tank;
//创建道具包
- (void)createTool;
//返回生成的工具箱数组，这里其实数组里每次都只有一个工具箱
- (NSMutableArray *)toolsArray:(Tank90Sprite *)aTank;
//移除工具包
- (void)removeTool:(ToolSprite *)tool;
//炸弹包
- (void)plusBoon:(Tank90Sprite *)aTank;
//暂停敌方坦克
- (void)plusPass:(Tank90Sprite *)aTank;
//保护老家
- (void)homeProtect:(BOOL)isProtect aTank:(Tank90Sprite *)aTank;
@end



@interface Tank90Sprite : CCSprite {
     Tank90Sprite* _tmpTank; //记录被击中的临时坦克
}

@property(nonatomic,assign) NSTimer* timer;


@property(nonatomic)int speed;//坦克速度
@property(nonatomic)int life;//几条命
@property(nonatomic)  Tank90Kind kind;//坦克类型
@property(nonatomic,assign) int enemyKindForScore;
@property(nonatomic,assign) Tank90Action kAction;//坦克动作，向上向下向左向右
@property(nonatomic,assign) BOOL isCanFire;//是否可以开火
@property(nonatomic) CGSize mapSize;//地图大小
@property(nonatomic,retain) CCSprite* buttleSprite;//子弹精灵
@property(nonatomic)int buttleOrientation;//子弹射出的方向

@property(nonatomic,assign) BOOL isHomeProtect;//老家是否被保护
@property(nonatomic,assign) BOOL isTankDone; //对方坦克被干掉了，一个标示，用于发音频和移除被击中的坦克
@property(nonatomic,assign) BOOL isHomeDone; //老家被干掉了
@property(nonatomic,assign) BOOL isButtleDone;//子弹被干掉了
@property(nonatomic,assign) BOOL isProtect; //坦克刚出现的时候是星星，此时坦克是受保护的
@property(nonatomic,assign) BOOL isRead; //击中之后生成道具包

//坦克出现动画
- (void)animationBorn;
//坦克消失动画
- (void)animationBang;
- (void)fire:(CCSprite *)buttle orientation:(Tank90Action)buttleOrientation;

+ (id)initWithDelegate:(id<Tank90SpriteDelegate>)aDelegate life:(int)numLife tKind:(Tank90Kind)tKind mapSize:(CGSize)mSize ptype:(NSString*)type;
@property(nonatomic,assign) CGPoint bornPosition;//坦克初始位置
@property(nonatomic,assign) CGRect homeRect;//坦克所保护的家的矩形
- (void)onFire;
- (void)moveUp;
- (void)moveDown;
- (void)moveLeft;
- (void)moveRight;

//- (void)changeKind:(ToolSprite *)tool;

- (BOOL)checkHome:(CCSprite *)buttle;
- (BOOL)checkWall:(CCSprite *)buttle;

- (BOOL)checkBound:(CCSprite *)buttle;

- (BOOL)checkStrongWall:(CCSprite *)buttle;

- (BOOL)checkLayer2:(CCSprite *)buttle;

- (void)removeShield;
- (void)playMoveVideo;

- (void)topButtle;
-(void)removeSelfFromMap ;
@property(nonatomic,weak) id<Tank90SpriteDelegate> delegate;
@end
