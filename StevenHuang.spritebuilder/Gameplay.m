//
//  Gameplay.m
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Resume.h"
#import "RuleBook.h"
#import "ScoreScreen.h"

typedef NS_ENUM(NSInteger, GameMechanics){
    SIGNATURE_GAME,
    ALWAYS_CORRRECT
};

@implementation Gameplay{
    CCTimer *_timer;
    Resume *_resumeNode;
    RuleBook *_rulebookNode;
    CCNode *_contentNode,*_readyNode,*_scoreScreen;
    CCSprite *_clockhandSprite;
    NSMutableArray *documentArray;
    
    
    bool ready;
    CCNode *selectedObject;
    int roundTime,level;
    NSDictionary *root;
    NSDateComponents *components;
}

#pragma mark Setup
- (id)init{
    self = [super init];
    if (self) {
        _timer = [[CCTimer alloc] init];
    }
    return self;
}


-(void) didLoadFromCCB{
    self.userInteractionEnabled = TRUE;
    
    ready=false;
    documentArray=[NSMutableArray array];
    documentArray[0]=_rulebookNode;
    documentArray[1]=_resumeNode;
    components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"plist"];
    root = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary* resumeInfo= root[@"ResumeInfo"];
    [_resumeNode setup:components rootDir:resumeInfo];
    _rulebookNode.Leveldata=root[@"Levels"];
    [_rulebookNode createRulesWithLevel:0];
}

#pragma mark Animations Controls
-(void)newResume{
    [_resumeNode createNew];
}

-(void)update:(CCTime)delta{
    if(ready){
        _clockhandSprite.rotation++;
    }
}

#pragma mark Touch Controls
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    if(!ready && CGRectContainsPoint([_readyNode boundingBox], touchLocation)){
        ready=true;
        [self schedule:@selector(endGame) interval:3.f];
        [self newResume];
        [_readyNode removeFromParent];
        return;
    }
    selectedObject=nil;
    //item on top get priority
    for(CCNode* documentNode in documentArray){
        if(CGRectContainsPoint([documentNode boundingBox], touchLocation)){
            selectedObject=documentNode;
            break;
        }
    }
    selectedObject.zOrder=1;
    if(selectedObject!=nil){
    [documentArray removeObject:selectedObject];
    [documentArray insertObject:selectedObject atIndex:0];
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    CGPoint newLocation = ccp(touchLocation.x/_contentNode.contentSizeInPoints.width,touchLocation.y/_contentNode.contentSizeInPoints.height);
    selectedObject.position=newLocation;
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(selectedObject==_resumeNode){
        CGPoint touchLocation = [touch locationInNode:_contentNode];
        if(touchLocation.x<=20 || touchLocation.x>_contentNode.contentSizeInPoints.width-20)
            [self newResume];
    }
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    
}

-(void) endGame{
    ScoreScreen* screen = (ScoreScreen*)[CCBReader loadAsScene:@"screens/scoreScreen"];
    screen.positionType = CCPositionTypeNormalized;
    screen.position = ccp(0.5, 0.5);
    screen.zOrder = INT_MAX;
    [_contentNode addChild:screen];
    ready=false;
}


@end
