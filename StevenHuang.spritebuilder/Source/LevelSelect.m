//
//  LevelSelect.m
//  StevenHuang
//
//  Created by Steven Huang on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelSelect.h"
#import "GameplayManager.h"
#import "LevelButton.h"

@implementation LevelSelect{
    CCNode *_container,*_popup;
    NSArray* levels;
}

-(void)didLoadFromCCB{
    levels=[[[_container children][0] children][3] children];
    for(LevelButton* item in levels){
        ((CCButton*)[item children][0]).title=[NSString stringWithFormat:@"%d",item.level+1];
        if(item.level>[[NSUserDefaults standardUserDefaults] integerForKey:@"level"])
            ((CCButton*)[item children][0]).enabled=false;
    }
    if([GameplayManager sharedInstance].submitted){
        _popup.visible=true;
        _popup.cascadeOpacityEnabled=true;
        CCActionDelay *delay=[CCActionDelay actionWithDuration:.5f];
        CCActionFadeOut *fade=[CCActionFadeOut actionWithDuration:1.f];
        CCActionSequence *seq=[CCActionSequence actionWithArray:@[delay,fade]];
        [_popup runAction:seq];
        [GameplayManager sharedInstance].submitted=false;
    }
}

-(void)openStore{
     [[OALSimpleAudio sharedInstance] playBg:@"Assets/click1.wav"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Store"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.3f]];
}

-(void)submitForm{
    [[OALSimpleAudio sharedInstance] playEffect:@"Assets/click1.wav"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"FormScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:.3f]];
    
}

@end
