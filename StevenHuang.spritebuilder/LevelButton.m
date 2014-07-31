//
//  LevelButton.m
//  StevenHuang
//
//  Created by Steven Huang on 7/31/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelButton.h"
#import "GameplayManager.h"

@implementation LevelButton

-(void)play{
    
    [GameplayManager sharedInstance].level=self.level;
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
