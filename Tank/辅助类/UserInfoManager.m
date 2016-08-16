//
//  UserInfoManager.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UserInfoManager.h"
#import "sys/xattr.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Tank90Sprite.h"
static UserInfoManager *gUserManager = nil;

@implementation UserInfoManager

+ (UserInfoManager *)Share {
    if (!gUserManager) {
        gUserManager = [[UserInfoManager alloc] init];
    }
    return gUserManager;
}


- (NSString *)mDanJi {
    NSString *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"mDanJi"];
    if(number==nil)number=@"";
    return number;
}

- (void)setMDanJi:(NSString *)number {
    
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"mDanJi"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)mCurPID {
    NSString *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"mFindPwdTempAccount"];
    if(number==nil)number=@"";
    return number;
}

- (void)setMCurPID:(NSString *)number {
    
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"mFindPwdTempAccount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)sendTank90Move:(CGPoint)piont moveType:(MoveType)movety{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSNumber *dataType=[NSNumber numberWithInt:Tank90Move];
    [dic setObject:dataType forKey:datatype];
    NSMutableDictionary *info=[NSMutableDictionary new];
    [dic setObject:info forKey:datainfo];
    
    [info setObject:[NSNumber numberWithInt:movety] forKey:movetype];
    CGPoint tankpoint=piont;
    [info setObject:NSStringFromCGPoint(tankpoint) forKey:tank90position];
    
    NSString *errorString;
    NSData *plistdata = [NSPropertyListSerialization dataFromPropertyList:dic format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
    if (plistdata)
        [BonjourHelper sendData:plistdata];
    else
        CFShow((__bridge CFTypeRef)(errorString));
   
    
}
+(void)sendTank90Fire{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSNumber *dataType=[NSNumber numberWithInt:Tank90Fire];
    [dic setObject:dataType forKey:datatype];
    NSMutableDictionary *info=[NSMutableDictionary new];
    [dic setObject:info forKey:datainfo];
    NSString *errorString;
    NSData *plistdata = [NSPropertyListSerialization dataFromPropertyList:dic format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
    if (plistdata)
        [BonjourHelper sendData:plistdata];
    else
        CFShow((__bridge CFTypeRef)(errorString));
    
    
}
//同步产生敌军
+(void)sendTankEnemyCreate:(CGPoint)piont tankKind:(int)kind tankTag:(int)tag {
     NSMutableDictionary *dic=[NSMutableDictionary new];
     NSNumber *dataType=[NSNumber numberWithInt:TankEnemyCreate];
    [dic setObject:dataType forKey:datatype];
    NSMutableDictionary *info=[NSMutableDictionary new];
    [dic setObject:info forKey:datainfo];
    [info setObject:[NSNumber numberWithInt:kind] forKey:tankEnemyKind];
    [info setObject:NSStringFromCGPoint(piont) forKey:tankEnemyPosition];
    [info setObject:[NSNumber numberWithInt:tag] forKey:tankEnemyTag];
    
    NSString *errorString;
    NSData *plistdata = [NSPropertyListSerialization dataFromPropertyList:dic format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
    if (plistdata)
        [BonjourHelper sendData:plistdata];
    else
        CFShow((__bridge CFTypeRef)(errorString));

}
//同步敌军坦克方向
+(void)sendTankEnemyDirection:(int)action tankTag:(int)tag {
    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSNumber *dataType=[NSNumber numberWithInt:TankEnemyRandomDirection];
    [dic setObject:dataType forKey:datatype];
    NSMutableDictionary *info=[NSMutableDictionary new];
    [dic setObject:info forKey:datainfo];
    [info setObject:[NSNumber numberWithInt:action] forKey:tankEnemyRandomDirection];
    [info setObject:[NSNumber numberWithInt:tag] forKey:tankEnemyTag];
    
    NSString *errorString;
    NSData *plistdata = [NSPropertyListSerialization dataFromPropertyList:dic format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
    if (plistdata)
        [BonjourHelper sendData:plistdata];
    else
        CFShow((__bridge CFTypeRef)(errorString));
    
}

+(void)sendTankEnemyRadomFire:(int)action tankTag:(int)tag {
    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSNumber *dataType=[NSNumber numberWithInt:TankEnemyRandomFire];
    [dic setObject:dataType forKey:datatype];
    NSMutableDictionary *info=[NSMutableDictionary new];
    [dic setObject:info forKey:datainfo];
    [info setObject:[NSNumber numberWithInt:action] forKey:tankEnemyRandomFire];
    [info setObject:[NSNumber numberWithInt:tag] forKey:tankEnemyTag];
    
    NSString *errorString;
    NSData *plistdata = [NSPropertyListSerialization dataFromPropertyList:dic format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
    if (plistdata)
        [BonjourHelper sendData:plistdata];
    else
        CFShow((__bridge CFTypeRef)(errorString));
    
}



//同步敌军轨迹
+(void)sendTankRandomRandomMovetankTag:(int)tag posion:(CGPoint)point {
    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSNumber *dataType=[NSNumber numberWithInt:TankEnemyRandomMove];
    [dic setObject:dataType forKey:datatype];
    NSMutableDictionary *info=[NSMutableDictionary new];
    [dic setObject:info forKey:datainfo];
    //[info setObject:[NSNumber numberWithInt:tag] forKey:tankEnemyRandomMove];
    CGPoint tankpoint=point;
    [info setObject:NSStringFromCGPoint(tankpoint) forKey:tankEnemyPosition];

    [info setObject:[NSNumber numberWithInt:tag] forKey:tankEnemyTag];
    NSString *errorString;
    NSData *plistdata = [NSPropertyListSerialization dataFromPropertyList:dic format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
    if (plistdata)
        [BonjourHelper sendData:plistdata];
    else
        CFShow((__bridge CFTypeRef)(errorString));
    
}

//TankEnemy,
//TankEnemy,
//TankEnemyRandomFire

+(void)sendGotoScore{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSNumber *dataType=[NSNumber numberWithInt:TankGotoScore];
    [dic setObject:dataType forKey:datatype];
    NSMutableDictionary *info=[NSMutableDictionary new];
    [dic setObject:info forKey:datainfo];
      
    NSString *errorString;
    NSData *plistdata = [NSPropertyListSerialization dataFromPropertyList:dic format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
    if (plistdata)
        [BonjourHelper sendData:plistdata];
    else
        CFShow((__bridge CFTypeRef)(errorString));
}

@end
