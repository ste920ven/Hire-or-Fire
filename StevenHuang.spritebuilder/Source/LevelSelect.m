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

-(void)play1{
    [self play:0];
}

-(void)play2{
    [self play:1];
}

-(void)play3{
    [self play:2];
}

-(void)play4{
    [self play:3];
}

-(void)play5{
    [self play:4];
}


-(void)play:(int)level{
    
    [GameplayManager sharedInstance].level=level;
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)openStore{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Store"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];

}

@end
