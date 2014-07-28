//
//  Minigame.m
//  StevenHuang
//
//  Created by Steven Huang on 7/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Minigame.h"

typedef NS_ENUM(NSInteger, MINIGAME){
    PAPER_SHUFFLING,
    DELETE_EMAIL
};

@implementation Minigame{
    int gameCode, counter;
    CCNode *selectedObject,*_key;
    CGPoint startLocation,ogPosition;
    bool done;
    NSMutableArray *arr;
    CCNode *_contentNode;
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
        case PAPER_SHUFFLING:{
            arr=[NSMutableArray array];
            for(int i=0;i<20;i++){
                CCColor *color=[CCColor colorWithRed:arc4random_uniform(255)/255.f green:arc4random_uniform(255)/255.f blue:arc4random_uniform(255)/255.f];
                CCNodeColor *tmp=[CCNodeColor nodeWithColor:color width:arc4random_uniform(100)+50 height:arc4random_uniform(100)+100];
                tmp.position=ccp(arc4random_uniform(150),arc4random_uniform(350));
                [_contentNode addChild:tmp];
            }
            break;
        }
        case DELETE_EMAIL:{
            arr=[NSMutableArray arrayWithArray:[_contentNode children]];
            for(int i=0;i<[arr count];i++){
                ((CCLabelTTF*) [((CCNode*)arr[i]) children][1]).string=[NSString stringWithFormat:@"%d",i];
            }
            break;
        }
    }
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    startLocation=[touch locationInNode:_contentNode];
    switch (gameCode) {
        case PAPER_SHUFFLING:{
            [self shuffleTouchBegan];
            break;
        }
        case DELETE_EMAIL:{
            startLocation=ccp(startLocation.x,_contentNode.contentSize.height-startLocation.y);
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
        case PAPER_SHUFFLING:{
            float x=touchLocation.x-startLocation.x;
            float y=touchLocation.y-startLocation.y;
            selectedObject.position=ccp(ogPosition.x+x,ogPosition.y+y);
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
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    switch (gameCode) {
        case PAPER_SHUFFLING:{
            if(selectedObject!=nil && selectedObject==_key)
                done=true;
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

#pragma mark game 1 - paper shuffling game
-(void)shuffleTouchBegan{
    for(CCNode* item in [_contentNode children]){
        if(CGRectContainsPoint([item boundingBox], startLocation)){
            selectedObject=item;
            ogPosition=selectedObject.position;
        }
    }
}


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
