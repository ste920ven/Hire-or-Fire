//
//  Minigame.m
//  StevenHuang
//
//  Created by Steven Huang on 7/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Minigame.h"
#import "GameplayManager.h"

typedef NS_ENUM(NSInteger, MINIGAME){
    PAPER_SHUFFLING,
    DELETE_EMAIL,
    TAPPING,
};

@implementation Minigame{
    int gameCode, counter, multiplier, score;
    CCNode *selectedObject,*_key,*_popoverNode;
    CGPoint startLocation,ogPosition;
    bool done;
    NSMutableArray *arr;
    CCNode *_contentNode;
    CCLabelTTF *_instructionLabel;
    float time;
}

-(void)didLoadFromCCB{
    
    self.userInteractionEnabled=true;
}

-(void)exit{
    [GameplayManager sharedInstance].minigame=false;
    [self removeFromParent];
}

-(void)setGame:(int)i multiplier:(int)n{
    gameCode=i;
    multiplier=n-1;
    switch (gameCode) {
        case PAPER_SHUFFLING:{
            CGSize contentSize=[_contentNode contentSizeInPoints];
            for(int i=0;i<15;i++){
                CCColor *color=[CCColor colorWithRed:arc4random_uniform(255)/255.f green:arc4random_uniform(255)/255.f blue:arc4random_uniform(255)/255.f];
                CCNodeColor *tmp=[CCNodeColor nodeWithColor:color width:(arc4random_uniform(40)+20)*contentSize.width/100 height:(arc4random_uniform(30)+30)*contentSize.height/100];
                tmp.position=ccp(arc4random_uniform(contentSize.width),arc4random_uniform(contentSize.height));
                [_contentNode addChild:tmp];
            }
            _instructionLabel.string=@"FIND";
            break;
        }
        case DELETE_EMAIL:{
            arr=[NSMutableArray arrayWithArray:[_contentNode children]];
            for(int i=0;i<[arr count];i++){
                ((CCLabelTTF*) [((CCNode*)arr[i]) children][1]).string=[NSString stringWithFormat:@"%d",i];
            }
            break;
        }
        case TAPPING:{
            arr=[NSMutableArray array];
            for(int i=0;i<15;++i){
                CCColor *color=[CCColor colorWithRed:20/255.f green:20/255.f blue:20/255.f];
                CCNodeColor *tmp=[CCNodeColor nodeWithColor:color width:50 height:50];
                tmp.position=ccp(arc4random_uniform(150),arc4random_uniform(350));
                [_contentNode addChild:tmp];
                [arr addObject:tmp];
            }
            _instructionLabel.string=@"TAP";
        }
    }
}

-(int)getScore{
    int tmp=score;
    score=0;
    return tmp;
}

-(void)score{
    score+=multiplier;
}

-(void)update:(CCTime)delta{
    time+=delta;
    if(time>1){
        _instructionLabel.visible=false;
    }
    for(int i=5;i>2;--i){
        if(time>=i){
            _instructionLabel.visible=true;
            _instructionLabel.string=[NSString stringWithFormat:@"%d",6-i ];
            break;
        }
    }
    if(time>6){
        [self exit];
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
            [self emailTouchBegan];
            break;
        }
        case TAPPING:{
            [self shuffleTouchBegan];
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
            if((f>100 || f<-50) && selectedObject!=nil)
                [self getNewEmail];
            break;
        }
        case TAPPING:{
            [selectedObject removeFromParent];
            [arr removeObject:selectedObject];
            if([arr count]==0)
                [self exit];
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
        if(CGRectContainsPoint([item boundingBox], startLocation)){
            selectedObject=item;
            ogPosition=item.position;
            break;
        }
    }
}

-(void)emailTouchEnd{
    selectedObject.position=ogPosition;
//    if(counter==10)
//        [self exit];
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
    CCActionScaleTo *translation = [CCActionMoveTo actionWithDuration:0.1f position:tmp];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[translation]];
    [(CCNode*)arr[num] runAction:sequence];
    
    CCNode* node=arr[num];
    [arr removeObjectAtIndex:num];
    [arr addObject:node];
    
    [self score];
    selectedObject=nil;
}

#pragma mark tap game


@end
