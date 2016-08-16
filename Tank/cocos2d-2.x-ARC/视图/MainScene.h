//
//  MainScene.h
//  Tank90
//
//  Created by song on 15/4/24.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainScene : CCScene {
    
    
    
    CCSpriteFrameCache* _frameCache;
    CGSize _winSize;

    
    
}





+ (id)scene;
- (id)initWithMapInformation:(int)leve status:(int)status life:(int)life;
@end
