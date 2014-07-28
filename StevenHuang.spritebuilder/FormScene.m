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
    
}

-(void)back{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
