//
//  PauseScreen.m
//  StevenHuang
//
//  Created by Steven Huang on 7/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PauseScreen.h"
#import "GameplayManager.h"

@implementation PauseScreen

-(void)LevelSelect{
    [[OALSimpleAudio sharedInstance] playBg:@"Assets/click1.wav"];
    [GameplayManager sharedInstance].paused=false;
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)Resume{
    [[OALSimpleAudio sharedInstance] playBg:@"Assets/click1.wav"];
    [self removeFromParent];
    self.userInteractionEnabled=true;
    [GameplayManager sharedInstance].paused=false;
}

@end
