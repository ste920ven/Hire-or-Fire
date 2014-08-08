//
//  FormScene.m
//  StevenHuang
//
//  Created by Steven Huang on 7/27/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "FormScene.h"

@implementation FormScene{
    CCTextField *_act1Field,*_act2Field,*_act3Field,*_act4Field,*_act5Field,*_ex1Field,*_ex2Field,*_nameField;
}

-(void)submit{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:_nameField.string, @"name", _act1Field, @"act1",_act2Field,@"act2",_act3Field,@"act3",_act4Field, @"act4",_act5Field, @"act5", _ex1Field,@"ex1",_ex2Field,@"ex2", nil];
    [MGWU logEvent:@"levelcomplete" withParams:params];
}

-(void)back{
    [[OALSimpleAudio sharedInstance] playBg:@"Assets/click1.wav"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
