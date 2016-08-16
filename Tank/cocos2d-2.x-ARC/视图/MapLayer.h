//
//  MapLayer.h
//  Tank90
//
//  Created by song on 15/4/27.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class Tank90Sprite;
@protocol MapLayerDelegate;




@interface MapLayer : CCLayerColor {
    
    
    CGSize _winSize;
    
    
    int _slow;//曼坦克数目
    int _quike;//快坦克
    int _strong;//虎式坦克
    int _strongYe;
    int _strongG;
    
     NSMutableDictionary* _aiDic;
    
    
    int _rodamPoint;//工具包随机点个数
    NSMutableArray* _pointArray;//工具包坐标
    CGPoint _tmpPoint;
    NSMutableArray* _propArray;

}

@property(nonatomic,retain)id<MapLayerDelegate> delegate;


@property(nonatomic,retain)CCTMXTiledMap* map;
@property(nonatomic,assign)CCTMXLayer* bg1Layer;
@property(nonatomic,assign)CCTMXLayer* bg2Layer;
@property(nonatomic,strong) Tank90Sprite *  tank1;
@property(nonatomic,strong) Tank90Sprite *  tank2;
- (id)initWithMap:(int)leve kind:(int)tKind life:(int)numLife;
@end



@protocol MapLayerDelegate <NSObject>


//- (void)gameOver;

- (void)bornEnmey; //更新敌人界面上的数目

- (void)changeTankLife:(int)inLife andTank:(Tank90Sprite*)tank; //改变我方坦克的命数的显示

@end

