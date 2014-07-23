//
//  Minigame.m
//  StevenHuang
//
//  Created by Steven Huang on 7/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Minigame.h"

typedef NS_ENUM(NSInteger, MINIGAME){
    SIGNATURE_GAME,
    DELETE_EMAIL
};

@implementation Minigame{
    int gameCode;
    CCNode *_contentNode,*selectedObject;
    CGPoint startLocation;
    bool done;
}

-(void)exit{
    [[CCDirector sharedDirector] popScene];
}

-(void)setGame:(int)i{
    CCNode* screen;
    gameCode=i;
    switch (gameCode) {
        case SIGNATURE_GAME:{
            screen =[CCBReader load:@"minigames/sign"];
            break;
        }
        case DELETE_EMAIL:{
            screen =[CCBReader load:@"minigames/email"];
            break;
        }
    }
    [_contentNode addChild:screen];
}


-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
        startLocation=[touch locationInNode:_contentNode];
    switch (gameCode) {
        case SIGNATURE_GAME:{
            break;
        }
        case DELETE_EMAIL:{
            [self emailTouchBegan];
            break;
        }
        case 2:{
            break;
        }
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    switch (gameCode) {
        case SIGNATURE_GAME:{
            break;
        }
        case DELETE_EMAIL:{
            selectedObject.position=touchLocation;
            break;
        }
        case 2:{
            break;
        }
    }
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    switch (gameCode) {
        case SIGNATURE_GAME:{
            break;
        }
        case DELETE_EMAIL:{
            [self emailTouchEnd];
            break;
        }
        case 2:{
            break;
        }
    }
    if (done) {
        [self exit];
    }
}

#pragma mark game 1 - signing game

#pragma mark game 2 - email game
-(void)emailTouchBegan{
    
}

-(void)emailTouchEnd{
    
}

@end
