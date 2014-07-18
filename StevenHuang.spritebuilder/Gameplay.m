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
#import "GameplayManager.h"

typedef NS_ENUM(NSInteger, GameMechanics){
    SIGNATURE_GAME,
    ALWAYS_CORRRECT
};

@implementation Gameplay{
    //timer vars
    int framesForClockTick,roundCounter;
    
    //spritebuilder vars
    Resume *_resumeNode;
    RuleBook *_rulebookNode;
    CCNode *_contentNode,*_scoreScreen,*_noBar;
    CCSprite *_clockhandSprite;
    CCLabelTTF *_currDateLabel;
    
    bool ready,noBarActive,gameOver,rulesActive;
    NSArray *noArray;
    CCNode *selectedObject;
    CGFloat roundTime;
    NSDictionary *root;
    NSDateComponents *components;
    
    CCScene *level;
}

#pragma mark Setup
- (id)init{
    self = [super init];
    if (self) {
        
        UISwipeGestureRecognizer *upSwipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        [[CCDirector sharedDirector].view addGestureRecognizer:upSwipe];
        upSwipe.direction=UISwipeGestureRecognizerDirectionUp;
        
        UISwipeGestureRecognizer *downSwipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        [[CCDirector sharedDirector].view addGestureRecognizer:downSwipe];
        downSwipe.direction=UISwipeGestureRecognizerDirectionDown;
    }
    return self;
}


-(void) didLoadFromCCB{
    self.userInteractionEnabled = TRUE;
    
    roundCounter=0;
    ready=false;
    gameOver=false;
    _noBar.zOrder=INT_MAX;
    //    documentArray=[NSMutableArray array];
    //    documentArray[0]=_rulebookNode;
    //    documentArray[1]=_resumeNode;
    components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    _currDateLabel.string=[NSString stringWithFormat:@"Today is %d/%d/%d",[components month],[components day],[components year]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"plist"];
    root = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary* resumeInfo= root[@"ResumeInfo"];
    [_resumeNode setup:components rootDir:resumeInfo rules:_rulebookNode];
    _rulebookNode.Leveldata=root[@"Levels"][[GameplayManager sharedInstance].level];
    [_rulebookNode createRulesWithLevel:[GameplayManager sharedInstance].level resumeData:resumeInfo];
    
#pragma mark TODO currently set as constants
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"noNumber"];
    [[NSUserDefaults standardUserDefaults] setValue:@"fire" forKey:@"no1"];
    [[NSUserDefaults standardUserDefaults] setValue:@"dog" forKey:@"no2"];
    [[NSUserDefaults standardUserDefaults] setValue:@"shredder" forKey:@"no3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setupNoOptions:[[NSUserDefaults standardUserDefaults] integerForKey:@"noNumber"]];
    roundTime=60.f;
    
#pragma mark Tutorial
    
    if([GameplayManager sharedInstance].level==0){
        level = [CCBReader loadAsScene:@"screens/Tutorial1"];
        [_contentNode addChild:level];
    }
    
    [_rulebookNode show:true];
}

-(void)noAnimation:(NSString*)str{
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:str];
}

-(void)setupNoOptions:(int)num{
    CCSprite* no;
    CCSprite* no1;
    CCSprite* no2=(CCSprite*)[CCBReader load:@"NoChoice"];
    switch (num) {
        case 3:{
            no=(CCSprite*)[CCBReader load:@"NoChoice"];
            [_noBar addChild:no];
            [no.animationManager runAnimationsForSequenceNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"no3"]];
        }case 2:{
            no1=(CCSprite*)[CCBReader load:@"NoChoice"];
            [_noBar addChild:no1];
            [no1.animationManager runAnimationsForSequenceNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"no2"]];
        }case 1:{
            [_noBar addChild:no2];
            [no2.animationManager runAnimationsForSequenceNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"no1"]];
            break;
        }
    }
    noArray=[NSArray arrayWithObjects:no2,no1,no, nil];
    int divisions = noArray.count+1;
    float lastDivision = 0;
    for(int i=0;i<noArray.count;++i){
        /*
        if(divisions==4){
            if(i==0){
                ((CCNode*)[noArray[i] children][0]).anchorPoint=ccp(.5,1);
                ((CCNode*)[noArray[i] children][1]).anchorPoint=ccp(.5,1);
            }if(i==2){
                ((CCNode*)[noArray[i] children][0]).anchorPoint=ccp(.5,0);
                ((CCNode*)[noArray[i] children][1]).anchorPoint=ccp(.5,0);
            }
        }
        if(divisions==3){
            if(i==0){
                ((CCNode*)[noArray[i] children][0]).anchorPoint=ccp(.5,1);
                ((CCNode*)[noArray[i] children][0]).anchorPoint=ccp(.5,1);
            }if(i==1){
                ((CCNode*)[noArray[i] children][0]).anchorPoint=ccp(.5,0);
                ((CCNode*)[noArray[i] children][0]).anchorPoint=ccp(.5,0);
            }
        }
         */
        lastDivision+=_noBar.contentSizeInPoints.height/divisions;
        ((CCNode*)noArray[i]).position=ccp(0,lastDivision);
        
    }
}

#pragma mark Animations Controls
-(void)newResume{
    [_resumeNode createNew];
}

-(void)update:(CCTime)delta{
    if(ready){
        //clock
        [self animateClock:roundTime];
        [self endGame];
    }
}

-(void)animateClock:(CGFloat)time{
    if(framesForClockTick<=1){
        _clockhandSprite.rotation++;
        framesForClockTick=time/6;
    }else
        --framesForClockTick;
    
}

#pragma mark Touch Controls
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    selectedObject=nil;
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    if(CGRectContainsPoint([_resumeNode boundingBox], touchLocation)){
        selectedObject=_resumeNode;
    }
    
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    CGPoint newLocation = ccp(touchLocation.x/_contentNode.contentSizeInPoints.width,touchLocation.y/_contentNode.contentSizeInPoints.height);
    if(!rulesActive){
        if(selectedObject==_resumeNode){
            selectedObject.position=newLocation;
            if(touchLocation.x<=50){
                noBarActive=true;
                _noBar.position=ccp(40,.05);
            }else if(noBarActive){
                _noBar.position=ccp(-80,.05);
                noBarActive=false;
            }
        }
    }
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!rulesActive &&
       selectedObject==_resumeNode){
        CGPoint touchLocation = [touch locationInNode:_contentNode];
        if(touchLocation.x<=50){
            if(_resumeNode.correct==false)
                ++_resumeNode.correctCount;
            [self newResume];
        }else if(touchLocation.x>_contentNode.contentSizeInPoints.width-50){
            if(_resumeNode.correct==true){
                _resumeNode.passedCount++;
                _resumeNode.correctCount++;
            }
            [self newResume];
        }else{
            [self resetResume];
        }
    }
    if(noBarActive){
        _noBar.position=ccp(-80,.05);
        noBarActive=false;
    }
}

-(void)didSwipe:(UISwipeGestureRecognizer*)sender{
    if(ready)
        [self resetResume];
    
    UISwipeGestureRecognizerDirection direction=sender.direction;
    
    if(direction==UISwipeGestureRecognizerDirectionUp){
        [_rulebookNode show:true];
        rulesActive=true;
    }else if(direction==UISwipeGestureRecognizerDirectionDown){
        [_rulebookNode show:false];
        if(!ready){
            [self newResume];
                ready=true;
#pragma mark TUTORIAL
            [_contentNode removeChild:level];
        }
        rulesActive=false;
    }
}

-(void)resetResume{
    _resumeNode.position=ccp(.5,.6);
}
#pragma mark OLD CONTROLS
//-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
//    if(!gameOver){
//        CGPoint touchLocation = [touch locationInNode:_contentNode];
//        if(!ready && CGRectContainsPoint([_readyNode boundingBox], touchLocation)){
//            ready=true;
//            [self newResume];
//            [_readyNode removeFromParent];
//#pragma mark TUTORIAL
//            [_contentNode removeChild:level];
//            return;
//        }
//        selectedObject=nil;
//        //item on top get priority
//        for(CCNode* documentNode in documentArray){
//            if(CGRectContainsPoint([documentNode boundingBox], touchLocation)){
//                selectedObject=documentNode;
//                break;
//            }
//        }
//        selectedObject.zOrder=1;
//        if(selectedObject!=nil){
//            [documentArray removeObject:selectedObject];
//            [documentArray insertObject:selectedObject atIndex:0];
//        }
//    }
//}
//
//- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
//    CGPoint touchLocation = [touch locationInNode:_contentNode];
//    CGPoint newLocation = ccp(touchLocation.x/_contentNode.contentSizeInPoints.width,touchLocation.y/_contentNode.contentSizeInPoints.height);
//    selectedObject.position=newLocation;
//    if(selectedObject==_resumeNode){
//        if(touchLocation.x<=20){
//            noBarActive=true;
//            _noBar.position=ccp(0,.05);
//        }else if(noBarActive){
//            _noBar.position=ccp(-80,.05);
//            noBarActive=false;
//        }
//    }
//}
//
//-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
//    if(selectedObject==_resumeNode){
//        CGPoint touchLocation = [touch locationInNode:_contentNode];
//        if(touchLocation.x<=20){
//            if(_resumeNode.correct==false)
//                ++_resumeNode.correctCount;
//            [self newResume];
//        }else if(touchLocation.x>_contentNode.contentSizeInPoints.width-20){
//            if(_resumeNode.correct==true){
//                _resumeNode.passedCount++;
//                _resumeNode.correctCount++;
//
//            }
//            [self newResume];
//        }
//    }
//    if(noBarActive){
//        _noBar.position=ccp(-80,.05);
//        noBarActive=false;
//    }
//}

#pragma mark Game End

-(void) endGame{
    if(roundCounter==roundTime*60){
        gameOver=true;
        ScoreScreen* screen = (ScoreScreen*)[CCBReader load:@"screens/scoreScreen"];
        screen.positionType = CCPositionTypeNormalized;
        screen.position = ccp(0.5, 0.5);
        screen.zOrder = INT_MAX;
        [screen setScreenWithScore:_resumeNode.passedCount message:@"Level Passed" total:_resumeNode.totalCount correct:_resumeNode.correctCount];
        [_contentNode addChild:screen];
        ready=false;
    }else
        roundCounter++;
}

@end
