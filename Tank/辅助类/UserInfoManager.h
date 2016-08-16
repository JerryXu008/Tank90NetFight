//
//  UserInfoManager.h
//  TestRedCollar
//
//  Created by Bruce Xu on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DataType_{
    
    Tank90Move=0,
    Tank90Fire,
    TankEnemyCreate,
    TankGotoScore,
    TankEnemyRandomDirection,
    TankEnemyRandomMove,
    TankEnemyRandomFire
    
    
} DataType;




#define datatype @"datatype"
#define datainfo @"datainfo"
#define movetype @"movetype"
#define tank90position @"tank90position"
#define tankEnemyKind @"tankEnemyKind"
#define tankEnemyTag @"tankEnemyTag"
#define tankEnemyPosition @"tankEnemyPosition"
#define tankEnemyObject @"tankEnemyObject"
#define tankGotoScoreScene @"tankGotoScoreScene"
#define tankEnemyRandomDirection @"tankEnemyRandomDirection"
#define tankEnemyRandomMove @"tankEnemyRandomMove"
#define tankEnemyRandomFire @"tankEnemyRandomFire"





typedef enum MoveType_{
    tank_right,
    tank_left,
    tank_top,
    tank_bottom
} MoveType;



@interface UserInfoManager : NSObject {
    
}


@property (nonatomic,weak) NSString *mCurPID;
@property (nonatomic,weak) NSString *mDanJi;
@property (nonatomic,assign) int mTank90TotalLife;
+ (UserInfoManager *)Share;

#define kkCurPID      [UserInfoManager Share].mCurPID
#define kkDanJi      [UserInfoManager Share].mDanJi
#define kkTank90TotalLife [UserInfoManager Share].mTank90TotalLife

+(void)sendTank90Move:(CGPoint)piont moveType:(MoveType)movety;
+(void)sendTank90Fire;
+(void)sendTankEnemyCreate:(CGPoint)piont tankKind:(int)kind tankTag:(int)tag;
+(void)sendGotoScore;
+(void)sendTankEnemyDirection:(int)action tankTag:(int)tag ;
+(void)sendTankEnemyRadomFire:(int)action tankTag:(int)tag ;
+(void)sendTankRandomRandomMovetankTag:(int)tag posion:(CGPoint)point;
@end
