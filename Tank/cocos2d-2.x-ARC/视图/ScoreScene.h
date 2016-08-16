//
//  ScoreScene.h
//  Tank90
//
//  Created by song on 15/4/28.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScoreScene:CCScene {
    
    int _slow;
    int _quike;
    int _strong;
    int _strongYe;
    int _strongG;
    int leve;
    int life;
    int kind;
    
    
    CCLayerColor* layer;
    CGSize winSize;
}
- (id)initWithNumber:(int)slow quike:(int)quike strong:(int)strong strongY:(int)strongY strongG:(int)strongG
                leve:(int)leve kind:(int)kind life:(int)life;
+(id)scene;
@end
