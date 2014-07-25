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
    int gameCode, counter;
    CCNode *selectedObject;
    CGPoint startLocation,ogPosition;
    bool done;
    NSMutableArray *arr;
    CCNodeColor *_emailParent;
}

-(void)didLoadFromCCB{
    
    self.userInteractionEnabled=true;
}

-(void)exit{
    [self removeFromParent];
}

-(void)setGame:(int)i{
    gameCode=i;
    switch (gameCode) {
        case SIGNATURE_GAME:{
            break;
        }
        case DELETE_EMAIL:{
            arr=[NSMutableArray arrayWithArray:[_emailParent children]];
            for(int i=0;i<[arr count];i++){
                ((CCLabelTTF*) [((CCNode*)arr[i]) children][1]).string=[NSString stringWithFormat:@"%d",i];
            }
            break;
        }
    }
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    startLocation=[touch locationInNode:_emailParent];
    switch (gameCode) {
        case SIGNATURE_GAME:{
            break;
        }
        case DELETE_EMAIL:{
            startLocation=ccp(startLocation.x,_emailParent.contentSize.height-startLocation.y);
            [self emailTouchBegan];
            break;
        }
        case 2:{
            break;
        }
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:_emailParent];
    switch (gameCode) {
        case SIGNATURE_GAME:{
            break;
        }
        case DELETE_EMAIL:{
            CGFloat f=touchLocation.x-startLocation.x;
            selectedObject.position=ccp(f,ogPosition.y);
            break;
        }
        case 2:{
            break;
        }
    }
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:_emailParent];
    switch (gameCode) {
        case SIGNATURE_GAME:{
            break;
        }
        case DELETE_EMAIL:{
            [self emailTouchEnd];
            CGFloat f=touchLocation.x-startLocation.x;
            if(f>100 || f<-50)
                [self getNewEmail];
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
    for(CCSprite* item in arr){
        CGFloat rect=item.contentSize.height;
        if(startLocation.y>item.position.y && startLocation.y<item.position.y+rect && startLocation.x>0 && startLocation.x<200){
            selectedObject=item;
            ogPosition=item.position;
            break;
        }
    }
}

-(void)emailTouchEnd{
    selectedObject.position=ogPosition;
    if(counter==20)
        [self exit];
}

-(void)getNewEmail{
    CGPoint tmp=((CCNode*)arr[[arr count]-1 ]).position;
    int num=[arr indexOfObject:selectedObject];
    for(int i=[arr count]-1;i>num;i--){
        CCActionScaleTo *translation = [CCActionMoveTo actionWithDuration:0.2f position:((CCNode*)arr[i-1]).position];
        CCActionSequence *sequence = [CCActionSequence actionWithArray:@[translation]];
        [(CCNode*)arr[i] runAction:sequence];
    }
    
    ((CCNode*)arr[num]).position=ccp(tmp.x,tmp.y+100);
    CCActionScaleTo *translation = [CCActionMoveTo actionWithDuration:0.2f position:tmp];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[translation]];
    [(CCNode*)arr[num] runAction:sequence];
    
    CCNode* node=arr[num];
    [arr removeObjectAtIndex:num];
    [arr addObject:node];
    
    counter++;
    selectedObject=nil;
}


@end
