//
//  StartScene.h
//  Tank90
//
//  Created by song on 15/4/24.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface StartScene : CCLayer {
     BOOL _isRun;
}
+ (id)scene;
@property(nonatomic) CCLayer* layer;
@end
