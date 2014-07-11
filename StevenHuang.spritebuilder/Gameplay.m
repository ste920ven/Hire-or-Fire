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
    CCNode *_contentNode,*_readyNode,*_scoreScreen,*_noBar;
    CCSprite *_clockhandSprite;
    NSMutableArray *documentArray;
    
    bool ready,noBarActive;
    NSArray *noArray;
    CCNode *selectedObject;
    CGFloat roundTime;
    int level, score;
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
    
    score=0;
    ready=false;
    _noBar.zOrder=INT_MAX;
    documentArray=[NSMutableArray array];
    documentArray[0]=_rulebookNode;
    documentArray[1]=_resumeNode;
    components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"plist"];
    root = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary* resumeInfo= root[@"ResumeInfo"];
    [_resumeNode setup:components rootDir:resumeInfo rules:_rulebookNode];
    _rulebookNode.Leveldata=root[@"Levels"];
#pragma mark TODO change to loading levels and num of No
    [_rulebookNode createRulesWithLevel:0];
    
    [self setupNoOptions:3];
    roundTime=120.f;
}

-(void)setupNoOptions:(int)num{
    CCNode* no;
    CCNode* no1;
    CCNode* no2=[CCBReader load:@"No"];
    switch (num) {
        case 3:
            no=[CCBReader load:@"No"];
            [_noBar addChild:no];
        case 2:
            no1=[CCBReader load:@"No"];
            [_noBar addChild:no1];
        case 1:
            [_noBar addChild:no2];
            break;
    }
    noArray=[NSArray arrayWithObjects:no2,no1,no, nil];
    int divisions = noArray.count+1;
    float lastDivision = 0;
    for(int i=0;i<noArray.count;++i){
        lastDivision+=_noBar.contentSizeInPoints.height/divisions;
        ((CCNode*)noArray[i]).position=ccp(5,lastDivision);
        
    }
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
        [self schedule:@selector(endGame) interval:roundTime];
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
    if(touchLocation.x<=20){
        noBarActive=true;
        _noBar.position=ccp(0,.05);
    }else if(noBarActive){
        _noBar.position=ccp(-80,.05);
        noBarActive=false;
    }
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(selectedObject==_resumeNode){
        CGPoint touchLocation = [touch locationInNode:_contentNode];
        if(touchLocation.x<=20){
            if(_resumeNode.correct==false)
                ++score;
            [self newResume];
        }else if(touchLocation.x>_contentNode.contentSizeInPoints.width-20){
            if(_resumeNode.correct==true)
                ++score;
            [self newResume];
        }
    }
    if(noBarActive){
        _noBar.position=ccp(-80,.05);
        noBarActive=false;
    }
}

#pragma mark Game End

-(void) endGame{
    ScoreScreen* screen = (ScoreScreen*)[CCBReader load:@"screens/scoreScreen"];
    screen.positionType = CCPositionTypeNormalized;
    screen.position = ccp(0.5, 0.5);
    screen.zOrder = INT_MAX;
    [screen setScreenWithScore:score message:@"Level Passed" total:_resumeNode.totalCount];
#pragma mark TODO diasble touch in the back
    
    [_contentNode addChild:screen];
    ready=false;
}

@end
