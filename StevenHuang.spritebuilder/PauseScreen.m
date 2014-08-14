//
//  PauseScreen.m
//  StevenHuang
//
//  Created by Steven Huang on 7/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PauseScreen.h"
#import "GameplayManager.h"

@implementation PauseScreen{
    CCButton *_resumeButton,*_exitButton;
}

-(void)didLoadFromCCB{
    CCActionEaseBounceOut *translation=[CCActionEaseBounceOut actionWithAction:[CCActionMoveTo actionWithDuration:.5f position:ccp(.5,.45)] ];
    [_exitButton runAction:translation];
    translation=[CCActionEaseBounceOut actionWithAction:[CCActionMoveTo actionWithDuration:.5f position:ccp(.5,.3)] ];
    [_resumeButton runAction:translation];
}

-(void)LevelSelect{
    [[OALSimpleAudio sharedInstance] playBg:@"Assets/click1.wav"];
    [GameplayManager sharedInstance].paused=false;
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionUp duration:.5f]];
}

-(void)Resume{
    [[OALSimpleAudio sharedInstance] playBg:@"Assets/click1.wav"];
    [self removeFromParent];
    self.userInteractionEnabled=true;
    [GameplayManager sharedInstance].paused=false;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unPause" object:self];
}

@end
