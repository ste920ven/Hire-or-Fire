//
//  LevelSelect.m
//  StevenHuang
//
//  Created by Steven Huang on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelSelect.h"
#import "GameplayManager.h"

@implementation LevelSelect



-(void)play{
    [GameplayManager sharedInstance].level=0;
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
