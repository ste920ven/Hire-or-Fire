//
//  PauseScreen.m
//  StevenHuang
//
//  Created by Steven Huang on 7/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PauseScreen.h"
#import "GameplayManager.h"

@implementation PauseScreen

-(void)LevelSelect{
    self.userInteractionEnabled = true;
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)Resume{
    self.userInteractionEnabled=true;
    [self.parent removeChild:self];
    [GameplayManager sharedInstance].paused=false;;
}

@end
