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

-(void)didLoadFromCCB{
    self.userInteractionEnabled=true;
    if(!self.active){
        [self.animationManager runAnimationsForSequenceNamed:@"disabled"];
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if(self.active){
     [[OALSimpleAudio sharedInstance] playBg:@"Assets/click1.wav"];
        [self.animationManager runAnimationsForSequenceNamed:@"selected"];
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(self.active){
    [GameplayManager sharedInstance].level=self.level;
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:.5f]];
    }
}

@end
