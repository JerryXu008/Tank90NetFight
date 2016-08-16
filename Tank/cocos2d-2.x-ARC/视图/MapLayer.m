//
//  MapLayer.m
//  Tank90
//
//  Created by song on 15/4/27.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import "MapLayer.h"
#import "Tank90Sprite.h"
#import "StartScene.h"
#import "TankEnemySprite.h"
#import "ScoreScene.h"
#import "ToolSprite.h"
#import "SimpleAudioEngine.h"
#import "BonjourHelper.h"
@interface MapLayer()<Tank90SpriteDelegate>
{
int _leve;//关卡
 CCTMXObjectGroup* _objects;//层事件
 CCSprite* _home;//老鹰
 CGRect _homeRect;//老鹰的矩形区域
 BOOL _isGameOver;//游戏是否结束
    
  int _enemyNum;
  NSMutableArray* _enemyArray;



   int _bornNum;  //敌军出现的位置标识
}
@end

@implementation MapLayer
- (id)initWithMap:(int)leve kind:(int)tKind life:(int)numLife {
    self = [super initWithColor:ccc4(0, 0, 0, 255)];
    if ( self != nil ) {
        
        [BonjourHelper sharedInstance].dataDelegate = self;

      
        
        
        // glClearColor(1, 0.5, 1, 1);
        _leve = leve;
        _winSize = [[CCDirector sharedDirector] winSize];
        
        
        self.map = [CCTMXTiledMap tiledMapWithTMXFile:[NSString stringWithFormat:@"map%d.tmx",leve]];

        
        float big = _winSize.height/_map.contentSize.height;
        _map.scale = big;

        _bg1Layer = [_map layerNamed:@"bg1"];
        _bg2Layer = [_map layerNamed:@"bg2"];
        _bg2Layer.visible = NO;//将层2隐藏
        
        _objects = [_map objectGroupNamed:@"objects"];
        
        //改变层得大小和位置
//        [self changeWidth:_winSize.height height:_winSize.height];
//        //self.position = ccp(_winSize.width/6,0);
//        self.position = ccp(_winSize.width/2-_winSize.height/2,0);
         [self addChild:_map];
       
        
        
        //添加那个老鹰
        CGPoint homePoint = [self objectPosition:_objects object:@"home"];
        _home = [CCSprite spriteWithFile:@"home.png"];
        
        _home.position = ccp(homePoint.x + _home.textureRect.size.width/2,homePoint.y + _home.
                             textureRect.size.height/2);
        _homeRect = CGRectMake(_home.position.x - _home.textureRect.size.width/2,
                               _home.position.y - _home.textureRect.size.height/2,
                               _home.textureRect.size.width,
                               _home.textureRect.size.height);
        [_map addChild:_home z:-1];

      
        
        //添加我方坦克
        _tank1 = [Tank90Sprite initWithDelegate:self life:numLife tKind:tKind mapSize:_bg1Layer.contentSize ptype:@"1"] ;
        
        CGPoint tankPosition = [self objectPosition:_objects object:@"pl1"];
        _tank1.position = ccp(tankPosition.x + _tank1.boundingBox.size.width/2,tankPosition.y + _tank1.boundingBox.size.height/2);
        _tank1.bornPosition = _tank1.position;
        _tank1.homeRect = _homeRect;
        _tank1.tag=100;
         [_map addChild:_tank1 z:-1 tag:100];
        
        if([kkDanJi intValue]==1){
            _tank2=nil;
        }
        else{
        _tank2 = [Tank90Sprite initWithDelegate:self life:numLife tKind:tKind mapSize:_bg1Layer.contentSize ptype:@"2"];
        _tank2.tag=101;
        tankPosition = [self objectPosition:_objects object:@"pl2"];
        _tank2.position = ccp(tankPosition.x + _tank2.boundingBox.size.width/2,tankPosition.y + _tank2.boundingBox.size.height/2);
        _tank2.bornPosition = _tank2.position;
        _tank2.homeRect = _homeRect;
        
        [_map addChild:_tank2 z:-1 tag:101];

        }
        
        
        
        
        
        //添加敌方坦克
        if([kkDanJi intValue]==1||[kkCurPID intValue]==1){
        
        _enemyNum = 1;
        _enemyArray = [NSMutableArray arrayWithCapacity:0];
        [self initAIPlistFile];
        [self schedule:@selector(initEnemys) interval:2];
        
        }
        else{//p2
            _enemyNum=0;
            _enemyArray=[NSMutableArray new];
            _aiDic=[NSMutableDictionary new];
            
        }

//        //工具包初始化
//        _rodamPoint = 10;
//        _pointArray = [NSMutableArray arrayWithCapacity:0];
//        _propArray = [NSMutableArray arrayWithCapacity:0];
//        
//        for (int i = 1; i<=_rodamPoint;i++){
//            CGPoint point = [self objectPosition:_objects object:[NSString stringWithFormat:@"t%d",i]];
//            [_pointArray addObject:[NSValue valueWithCGPoint:point]];
//        }

         
        
    }
    return  self;
}
//初始化关卡敌方坦克信息
- (void)initAIPlistFile{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"AI" ofType:@"plist"];
    NSMutableDictionary* data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    _aiDic = [data objectForKey:[NSString stringWithFormat:@"leve%d",_leve]] ;
    
    
}
-(void)gotoScoreAndNet{
    
    [UserInfoManager sendGotoScore];
    [self unschedule:@selector(initEnemys)];//停止生成敌人
    [self scheduleOnce:@selector(gotoScoreScene) delay:1];//去得分页面

}
-(void)gotoScoreFromRemote
{
 [self scheduleOnce:@selector(gotoScoreScene) delay:1];//去得分页面
}
//初始化敌人
- (void)initEnemys {
    
    
    //20个坦克都被消灭
    if (_enemyNum > 20 && _enemyArray.count == 0) {
        [self gotoScoreAndNet];
    }
    
    if (_enemyNum > 20) return;
    if (_enemyArray.count >= 4) return;
    
    NSNumber* tankKind = [_aiDic objectForKey:[NSString stringWithFormat:@"%d",_enemyNum++]];
    
    TankEnemySprite* enemy = [TankEnemySprite initWithKind:[tankKind intValue]];
    enemy.tag=(_enemyNum-1);
    enemy.mapSize = _bg1Layer.contentSize;
    enemy.delegate = self;
    enemy.tank1 = _tank1;
    enemy.tank2=_tank2;
    enemy.homeRect = _homeRect;
    
    if (_bornNum == 3){
        _bornNum = 0;
    }
    int random = _bornNum;
    _bornNum ++;
    
    CGPoint poin;
    
    if ( random == 0){
        poin = [self objectPosition:_objects object:@"en1"];
    }else if (random == 1) {
        poin = [self objectPosition:_objects object:@"en2"];
        
    }else if (random == 2) {
        poin = [self objectPosition:_objects object:@"en3"];
    }else {
        poin = [self objectPosition:_objects object:@"en3"];
    }
    
    
    enemy.position = ccp(poin.x + enemy.boundingBox.size.width/2,poin.y + enemy.boundingBox.size.height/2);
    [_map addChild:enemy z:-1];
    
    [_enemyArray addObject:enemy];
    
    //更新主界面敌军的数目
    [self.delegate bornEnmey];
    
    [UserInfoManager sendTankEnemyCreate:enemy.position tankKind:enemy.kind tankTag:enemy.tag];

    
    
    
    
    
    
    
    
    
}


- (void) receivedData: (NSData *) thedata
{
    
    CFStringRef errorString;
    CFPropertyListRef plist = CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (__bridge CFDataRef)thedata, kCFPropertyListMutableContainers, &errorString);
    if (!plist)
    {
        CFShow(errorString);
        return;
    }
    NSMutableDictionary *dic = (__bridge NSMutableDictionary *)plist;
    if(dic){
       id type=[dic objectForKey:datatype];
        if ([type isKindOfClass:[NSNumber class]])
        {
            //敌军坦克的引用我方的坦克，要改一改，别忘了
            switch ([(NSNumber *)type intValue])
            {
                case TankEnemyRandomFire:{
                    
                    int ii=0;
                    NSLog(@"iiiii=%d",ii);
                    if([kkCurPID intValue]==2){
                        NSDictionary *dicInfo=[dic objectForKey:datainfo];
                        int tag=[[dicInfo objectForKey:tankEnemyTag] intValue];
                        for(int i=0;i<_enemyArray.count;i++){
                            TankEnemySprite *enemy=_enemyArray[i];
                             if(enemy.tag==tag){
                                 [enemy onFire];
                    
                            }
                        }
                    break;
                    }
                }
    
                    
                case TankEnemyRandomMove:{
                    if([kkCurPID intValue]==2){
                        NSDictionary *dicInfo=[dic objectForKey:datainfo];
                        
                       
                        int tag=[[dicInfo objectForKey:tankEnemyTag] intValue];
                        NSString *position=[dicInfo objectForKey:tankEnemyPosition];
                         for(int i=0;i<_enemyArray.count;i++){
                            TankEnemySprite *enemy=_enemyArray[i];
                           
                            if(enemy.tag==tag){
                               switch (enemy.kAction) {
                                    case kUp:{
                                         enemy.position=CGPointFromString(position);
                                        [enemy moveUp];
                                         break;
                                    }
                                        
                                    case kDown:{
                                         enemy.position=CGPointFromString(position);
                                        [enemy moveDown];
                                         break;
                                    }
                                        
                                    case kLeft:{
                                         enemy.position=CGPointFromString(position);
                                        [enemy moveLeft];
                                        break;
                                    }
                                        
                                    case kRight:{
                                         enemy.position=CGPointFromString(position);
                                        [enemy moveRight];
                                         break;
                                    }
                                        
                                    default:
                                        break;
                                }

                                break;
                            }
                            
                        }

                    
                    }
                    break;
                }
                    
                    case TankEnemyRandomDirection:{
                    if([kkCurPID intValue]==2){
                        NSDictionary *dicInfo=[dic objectForKey:datainfo];
                      
                        int derection =[[dicInfo objectForKey:tankEnemyRandomDirection] intValue];
                        int tag=[[dicInfo objectForKey:tankEnemyTag] intValue];
                        NSLog(@"tagtag=%d",tag);
                        
                        for(int i=0;i<_enemyArray.count;i++){
                            TankEnemySprite *enemy=_enemyArray[i];
                            if(enemy.tag==tag){
                                enemy.kAction=derection;
                             break;
                            }
                        
                        }
                    
                    }
                    
                    
                    break;
                }
                // [info setObject:[NSNumber numberWithInt:tag] forKey:tankEnemyTag];
                
                case TankEnemyCreate:{//敌军坦克创造
                    if([kkCurPID intValue]==2){
                        
                        NSDictionary *dicInfo=[dic objectForKey:datainfo];
                        int kind=[[dicInfo objectForKey:tankEnemyKind]intValue];
                        CGPoint pos=CGPointFromString([dicInfo objectForKey:tankEnemyPosition]);
                        int tag=[[dicInfo objectForKey:tankEnemyTag] intValue];
                        TankEnemySprite* enemy = [TankEnemySprite initWithKind:kind];
                        enemy.tag=tag;
                        enemy.mapSize =_bg1Layer.contentSize;
                        enemy.delegate = self;
                        enemy.tank1 = _tank1;
                        enemy.tank2=_tank2;
                        enemy.homeRect = _homeRect;
                        enemy.position = pos;
                        [_map addChild:enemy z:-1];
                        [_enemyArray addObject:enemy];
                        //更新主界面敌军的数目
                        [self.delegate bornEnmey];
                    }
                    
                    break;
                }
                case TankGotoScore:{
                    [self gotoScoreFromRemote];
                    break;
                }
                case  Tank90Move: {//我方坦克的移动
                   NSDictionary *dicInfo=[dic objectForKey:datainfo];
                    MoveType typem=[((NSNumber *)[dicInfo objectForKey:movetype]) intValue];
                    NSString *position=[dicInfo objectForKey:tank90position];
                   
                    Tank90Sprite *_tank=nil;
                    if([kkCurPID intValue]==1){
                        _tank=_tank2;
                    }
                    else if([kkCurPID intValue]==2){
                        _tank=_tank1;
                    }
                    
                      _tank.position=CGPointFromString(position);
                        if (typem==tank_top)
                        {
                            [_tank moveUp];
                        }
                        else  if (typem==tank_bottom)
                        {
                             [_tank moveDown];
                        }
                        else if (typem==tank_left)
                        {
                             [_tank moveLeft];
                        }
                       else if (typem==tank_right)
                        {
                             [_tank moveRight];
                        }

                    break;
                }
                case Tank90Fire:{
                    Tank90Sprite *_tank=nil;
                    if([kkCurPID intValue]==1){
                        _tank=_tank2;
                    }
                    else if([kkCurPID intValue]==2){
                        _tank=_tank1;
                    }
                    [_tank onFire];
                    break;
                }
                    
            }
        }
    }
    
}












//创建工具包
-(void)createTool
{
  [[SimpleAudioEngine sharedEngine] playEffect:@"sound3.aif"];
    int rodam = arc4random() % 6 + 1;  //有可能生成0 所以-1 +1
    
    ToolSprite *propSprite;
    
   
    if (_propArray.count != 0){
        propSprite = [_propArray lastObject];
        [propSprite removeFromParentAndCleanup:YES];
        [_propArray removeAllObjects];
     }
     propSprite=[ToolSprite initWithKind:rodam];
    
    
    if(_pointArray.count>0){
    
    NSValue* value =  [_pointArray lastObject];
    CGPoint point = [value CGPointValue];
    propSprite.position = ccp(point.x + propSprite.textureRect.size.width/2 , point.y + propSprite.textureRect.size.height/2);
    [_map addChild:propSprite z:-1];
    [_pointArray removeObject:value];
    [_propArray addObject:propSprite];
  
    [self upQutoRemoveTool];
  }
    
}

- (void)upQutoRemoveTool{
    [self unschedule:@selector(autoRemoveTool)]; //取消之前定时 开启一个全新的
    [self scheduleOnce:@selector(autoRemoveTool) delay:10];
}
- (void)autoRemoveTool {
    ToolSprite* sprite = [_propArray lastObject];
    [sprite removeFromParentAndCleanup:YES];
    [_propArray removeAllObjects];
}




- (void)gotoScoreScene {
    CCScene* scoreScene = [[ScoreScene alloc] initWithNumber:_slow quike:_quike strong:_strong strongY:_strongYe strongG:_strongG leve:_leve kind:_tank1.kind life:_tank1.life];
    [[CCDirector sharedDirector] replaceScene:scoreScene];
  
}


//退回主界面
- (void)retunMainScene {
    [[CCDirector sharedDirector] replaceScene:[StartScene scene]];
}
- (CGPoint)objectPosition:(CCTMXObjectGroup *)group object:(NSString *)object {
    
    CGPoint point;
    NSMutableDictionary* dic = [group objectNamed:object];
    point.x = [[dic valueForKey:@"x"] intValue];
    point.y = [[dic valueForKey:@"y"] intValue];
    return point;
}

//根据坦克坐标得到所在位置的瓦片位置
- (CGPoint)tileCoordinateFromPosition:(CGPoint)pos {
    
    int cox,coy;
    CGSize szLayer = _bg1Layer.layerSize;
    CGSize szTile = _map.tileSize;
    
    cox = pos.x / szTile.width;
    coy = szLayer.height - pos.y / szTile.height;
    if ((cox >=0) && (cox < szLayer.width) && (coy >= 0) && (coy < szLayer.height)) {
        return  ccp(cox,coy);
    }else {
        return ccp(-1,-1);
    }
    
}

- (unsigned int)tileIDFromPosition:(CGPoint)pos {
    
    CGPoint cpt = [self tileCoordinateFromPosition:pos];
    if (cpt.x < 0) return  -1;
    if (cpt.y < 0) return -1;
    if (cpt.x >= _bg1Layer.layerSize.width) return -1;
    if (cpt.y >= _bg1Layer.layerSize.height) return -1;
    return [ _bg1Layer tileGIDAt:cpt];
    
}
- (unsigned int)tileIDFromPositionFroLayer2:(CGPoint)pos {
    
    if (!_bg2Layer.visible) return 0;
    CGPoint cpt = [self tileCoordinateFromPosition:pos];
    if (cpt.x < 0) return  -1;
    if (cpt.y < 0) return -1;
    if (cpt.x >= _bg2Layer.layerSize.width) return -1;
    if (cpt.y >= _bg2Layer.layerSize.height) return -1;
    return [ _bg2Layer tileGIDAt:cpt];
}
//消除瓦片
- (void)destpryTile:(CGPoint)pos {
    CGPoint cpt = [self tileCoordinateFromPosition:pos];
    [_bg1Layer setTileGID:0 at:cpt];
}








- (void)onExit {
    
    
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    [super onExit];
   _map = nil;
    
   _delegate = nil;
    _propArray = nil;
    _pointArray = nil;
    _enemyArray = nil;
    _aiDic = nil;
    [self removeAllChildrenWithCleanup:YES];
    
}



/********************************我方坦克委托的回调方法**************************************/

//返回瓦片GID
- (int)tileIDFromPosition:(CGPoint)pon aTank:(Tank90Sprite *)aTank{

 return [self tileIDFromPosition:pon];
}
//返回瓦片GID
- (int)tileIDFromPositionLayer2:(CGPoint)pon aTank:(Tank90Sprite *)aTank {
    return [self tileIDFromPositionFroLayer2:pon];
}
//返回敌军数组
- (NSMutableArray *)enemyArray:(Tank90Sprite *)aTank {
    return _enemyArray;
}
//把子弹加到地图上
- (void)initButtleDidFinish:(Tank90Sprite *)aTank buttle:(CCSprite *)buttle {
    
    [_map addChild:buttle];
}

//游戏结束
- (void)gameOver:(Tank90Sprite *)tank{
    [self unschedule:@selector(initEnemys)];
    
    if (_isGameOver)return;
    
    UIImage* image = [UIImage imageNamed:@"home2.png"];
    CCTexture2D* newTexture = [[CCTextureCache sharedTextureCache] addCGImage:image.CGImage forKey:nil];
    [_home setTexture:newTexture];//改变新纹理
    
    
    CCSprite* gameSprite = [CCSprite spriteWithFile:@"gamedone.png"];
    gameSprite.scale = 8.0f;
    gameSprite.position = ccp(_bg1Layer.contentSize.width/2,-10);
    CGPoint overPoint = ccp(_bg1Layer.contentSize.width/2,_bg1Layer.contentSize.height/2);
    [_map addChild:gameSprite z:2];
    
    id ac1 = [CCMoveTo actionWithDuration:4 position:overPoint];
    [gameSprite runAction:ac1];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"gameover.aif"];
    
    [self schedule:@selector(retunMainScene) interval:5];
    _isGameOver = YES;

}
- (void)destpryTile:(CGPoint)pon aTank:(Tank90Sprite *)aTank {
    [self destpryTile:pon];
}

- (void)removeSprite:(Tank90Sprite *)aTank {
    
    
    TankEnemySprite* tank = (TankEnemySprite *)aTank;
    
    if (tank.enemyKindForScore == kSlow || tank.enemyKindForScore == kSlowR) {
        _slow++;
    }else if (tank.enemyKindForScore == kQuike || tank.enemyKindForScore == kQuikeR){
        _quike++;
    }else if (tank.enemyKindForScore == kStrong || tank.enemyKindForScore == kStrongRed){
        _strong++;
    }else if (tank.enemyKindForScore == kStrongYellow){
        _strongYe++;
    }else if (tank.enemyKindForScore == kStrongRedLife3 || tank.enemyKindForScore == kStrongGreen) {
        _strongG++;
    }
    
    [_enemyArray removeObject:tank];
    [tank stopTankAction];
    [tank scheduleOnce:@selector(removeSelfFromMap) delay:0.3];
}
//改变生命值
- (void)changeLife:(Tank90Sprite *)tank {
    [_delegate changeTankLife:tank.life andTank:(Tank90Sprite*)tank];
   
}

//返回工具箱数组
- (NSMutableArray *)toolsArray:(Tank90Sprite *)aTank{

    return _propArray;
}
//移除工具包
- (void)removeTool:(ToolSprite *)tool {
    [_map removeChild:tool cleanup:YES];
}
//炸弹
- (void)plusBoon:(Tank90Sprite *)aTank {
    
    for (Tank90Sprite* tankSprite in _enemyArray) {
        [tankSprite animationBang];
        [tankSprite scheduleOnce:@selector(removeSelfFromMap) delay:0.3];
    }
    [_enemyArray removeAllObjects];
    
}
//把敌方坦克全部暂停
- (void)plusPass:(Tank90Sprite *)aTank {
    
    for (TankEnemySprite* tankSprite in _enemyArray) {
        [tankSprite stopTankAction];
        [tankSprite scheduleOnce:@selector(initAction) delay:5];
    }

}
//保护老家
- (void)homeProtect:(BOOL)isProtect aTank:(Tank90Sprite *)aTank {
    
    _bg2Layer.visible = isProtect;
}
@end
