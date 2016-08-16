//
//  StartScene.m
//  Tank90
//
//  Created by song on 15/4/24.
//  Copyright 2015年 __MyCompanyName__. All rights reserved.
//

#import "StartScene.h"
#import "MainScene.h"
#import "BonjourHelper.h"
@implementation StartScene
@synthesize layer;
+(id)scene {
    
    CCScene* scene = [CCScene node];
    CCLayer* layer = [StartScene node];
    [scene addChild:layer];
    return scene;
}
- (id)init {
    
    if (self = [super init]) {
        [self initMenum];
        
        
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // CCScene* gameScene = [[ MainScene alloc] initWithMapInformation:1 status:1 life:30];
            
            
            [BonjourHelper sharedInstance].dataDelegate = self;
            
        });
        
        
    }
    return  self;
}
- (void)initMenum {
    
    
    [CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
    [CCMenuItemFont setFontSize:25];
    
    
    
    CCMenuItemImage* item3 = [CCMenuItemImage itemWithNormalImage:@"BattleCity.png" selectedImage:nil];
    CCMenuItemFont* item1 = [CCMenuItemFont itemWithString:@"Start Game" target:self selector:@selector(menuItem1Touch:)];
    
    
    
    CCMenu* menu = [CCMenu menuWithItems:item3,item1, nil];
    [menu alignItemsVerticallyWithPadding:20];
    [menu setPosition:ccp(kScrrenCenter.x, kScrrenCenter.y - 50)];
    
    
    [self addChild:menu];
}

- (void)menuItem1Touch:(id)sender {
    
    
    if (_isRun) return;
    kkCurPID=@"1";
    NSData *data=  [@"kaishi" dataUsingEncoding:NSUTF8StringEncoding];
    [BonjourHelper sendData:data];
    
    
    [self gotoMain];
    
    
    
    
}

-(void)gotoMain
{
    CCScene* gameScene = [[ MainScene alloc] initWithMapInformation:2 status:1 life:1];
    
    [[CCDirector sharedDirector] replaceScene:gameScene];
    
    _isRun = YES;
}




- (void) receivedData: (NSData *) thedata
{
    NSString *string = [[NSString alloc] initWithData:thedata encoding:NSUTF8StringEncoding] ;
    if ([string isEqualToString:@"kaishi"])
    {
        kkCurPID=@"2";
        [self gotoMain];
    }
    
}
















@end
