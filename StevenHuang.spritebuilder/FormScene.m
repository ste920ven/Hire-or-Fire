//
//  FormScene.m
//  StevenHuang
//
//  Created by Steven Huang on 7/27/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "FormScene.h"
#import "GameplayManager.h"

@implementation FormScene{
    CCTextField *_act1Field,*_act2Field,*_act3Field,*_act4Field,*_act5Field,*_ex1Field,*_ex2Field,*_nameField;
    CCSprite *_formNode;
}

-(void)didLoadFromCCB{
    _formNode.cascadeOpacityEnabled=true;
    [self.animationManager runAnimationsForSequenceNamed:@"Run"];
}

-(void)submit{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:_nameField.string, @"name", _act1Field.string, @"act1",_act2Field.string,@"act2",_act3Field.string,@"act3",_act4Field.string, @"act4",_act5Field.string, @"act5", _ex1Field.string,@"ex1",_ex2Field.string,@"ex2", nil];
    //[MGWU logEvent:@"levelcomplete" withParams:params];
    [GameplayManager sharedInstance].submitted=true;
    [self back];
}

-(void)back{
    [[OALSimpleAudio sharedInstance] playBg:@"Assets/click1.wav"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.3f]];
}

@end
