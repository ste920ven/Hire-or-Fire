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
#import "Minigame.h"
#import "PauseScreen.h"

@implementation Gameplay{
    //timer vars
    int framesForClockTick,minigameCode,feedbackTick;
    
    //spritebuilder vars
    Resume *_resumeNode,*_tmpResume;
    RuleBook *_rulebookNode;
    CCNode *_contentNode,*_scoreScreen,*_noBar,*_bubbleNode,*_tutorial1,*_tutorial2,*_pauseScreen,*_popoverNode,*_correctBarLeft,*_correctBarRight;
    CCSprite *_clockhandSprite;
    CCLabelTTF *_bubbleLabel;
    CCButton *_pauseButton;
    
    bool ready,noBarActive,gameOver,rulesActive,minigameNo,minigamePass,pushedScene;
    NSArray *noArray;
    CCNode *selectedObject;
    CGFloat roundTime,randomEventChance,penaltyChance,penaltyDelay,randomEventDelay;
    NSDictionary *root;
    UISwipeGestureRecognizer *downSwipe,*upSwipe;
    CGPoint startLocation;
    
    CCScene *level;
    PauseScreen *ps;
}

#pragma mark Setup
- (id)init{
    self = [super init];
    if (self) {
        upSwipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        [[CCDirector sharedDirector].view addGestureRecognizer:upSwipe];
        upSwipe.direction=UISwipeGestureRecognizerDirectionUp;
        
        downSwipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        [[CCDirector sharedDirector].view addGestureRecognizer:downSwipe];
        downSwipe.direction=UISwipeGestureRecognizerDirectionDown;
    }
    return self;
}


-(void) didLoadFromCCB{
    self.userInteractionEnabled = TRUE;
    
    _tmpResume.cascadeOpacityEnabled=true;
    _resumeNode.cascadeOpacityEnabled=true;
    [GameplayManager sharedInstance].roundCounter=0;
    rulesActive=true;
    ready=false;
    _noBar.zOrder=INT_MAX;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"plist"];
    root = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary* resumeInfo= root[@"ResumeInfo"];
    
    
    [_tmpResume setup:resumeInfo rules:_rulebookNode];
    [_resumeNode setup:resumeInfo rules:_rulebookNode];
    
    _rulebookNode.Leveldata=root[@"Levels"][[GameplayManager sharedInstance].level];
    NSArray* arr=_rulebookNode.Leveldata;
    [_rulebookNode createRulesWithLevel:[GameplayManager sharedInstance].level resumeData:resumeInfo];
    _rulebookNode.zOrder=INT_MAX-1;
    _popoverNode.zOrder=INT_MAX;
    
    [self setupNoOptions:[[NSUserDefaults standardUserDefaults] integerForKey:@"noNumber"]];
    roundTime=60.f;
    
    if([GameplayManager sharedInstance].level>9){
        randomEventChance=3000;
    }
    if([GameplayManager sharedInstance].level==9)
        randomEventChance=10000;
    
    //    randomEventDelay=1.f;
    
    if(arc4random_uniform(10000)<randomEventChance){
        randomEventDelay=arc4random_uniform(roundTime/2)+roundTime/4;
    }
    //*/
    [_rulebookNode show:true];
}

-(void)noAnimation:(NSString*)str{
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:str];
}

-(void)setupNoOptions:(int)num{
    CCSprite* no;
    CCSprite* no1;
    CCNode* no2=[CCBReader load:@"NoChoice"];
    switch (num) {
        case 3:{
            no=(CCSprite*)[CCBReader load:@"NoChoice"];
            [_noBar addChild:no];
            [no.animationManager runAnimationsForSequenceNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"noSelected"][2]];
        }case 2:{
            no1=(CCSprite*)[CCBReader load:@"NoChoice"];
            [_noBar addChild:no1];
            [no1.animationManager runAnimationsForSequenceNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"noSelected"][1]];
        }case 1:{
            [_noBar addChild:no2];
            [no2.animationManager runAnimationsForSequenceNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"noSelected"][0]];
            break;
        }
    }
    noArray=[NSArray arrayWithObjects:no2,no1,no, nil];
    int divisions = noArray.count+1;
    float lastDivision = 0;
    for(int i=0;i<noArray.count;++i){
        lastDivision+=1.f/divisions;
        ((CCNode*)noArray[i]).positionType=CCPositionTypeNormalized;
        ((CCNode*)noArray[i]).zOrder=INT_MAX;;
        ((CCNode*)noArray[i]).position=ccp(0,lastDivision);
    }
}

#pragma mark Animations Controls
-(void)newResume{
    _tmpResume.opacity=1;
    _resumeNode.zOrder=0;
    _tmpResume.zOrder=1;
    Resume *tmp=_resumeNode;
    _resumeNode=_tmpResume;
    _tmpResume=tmp;
    [_tmpResume createNew];
}

-(void)fadeResume:(UITouch *)touch{
    float percent=2*fabsf([touch locationInNode:self].x-startLocation.x) / [self contentSizeInPoints].width;
    _tmpResume.opacity=percent;
}

-(void)update:(CCTime)delta{
    if(![GameplayManager sharedInstance].paused){
        _pauseButton.enabled = YES;
        upSwipe.enabled = YES;
        downSwipe.enabled = YES;
        self.userInteractionEnabled = TRUE;
        if(ready){
            //clock
            
            [self animateClock:roundTime];
            [self endGame];
            
            //feedback handling
            if(feedbackTick>0)
                feedbackTick--;
            else{
                _correctBarLeft.visible=false;
                _correctBarRight.visible=false;
            }
            //minigame handling
            if(randomEventDelay*60==[GameplayManager sharedInstance].roundCounter){
                NSString *msg;
                
                //constant
                minigameCode=2;
                if([GameplayManager sharedInstance].level==9){
                    [GameplayManager sharedInstance].paused=true;
                    _rulebookNode.currPage=MINIGAME_TUTORIAL;
                    [_rulebookNode show:true];
                    downSwipe.enabled=true;
                }
                
                //minigameCode=arc4random_uniform(3);
                switch (minigameCode) {
                    case 0:
                        msg=@"Grab your car keys. I need you to run an errand.";
                        break;
                    case 1:
                        msg=@"Quick, delete your emails. The boss is coming to check them";
                        break;
                    case 2:
                        msg=@"I need you to sign some documents for me";
                }
                _bubbleLabel.string=msg;
                _bubbleNode.visible=true;
                _bubbleNode.zOrder=INT_MAX;
            }
        }
    }
}

-(void)animateNoBar:(BOOL)b{
    if(b && !noBarActive){
        [_noBar stopAllActions];
        CCActionScaleTo *translation = [CCActionMoveTo actionWithDuration:0.1f position:ccp(0,48)];
        [_noBar runAction:translation];
        noBarActive=true;
    }else if(!b){
        [_noBar stopAllActions];
        CCActionScaleTo *translation = [CCActionMoveTo actionWithDuration:0.1f position:ccp(-120,48)];
        [_noBar runAction:translation];
        noBarActive=false;
    }
}

-(void)animateClock:(CGFloat)time{
    if(framesForClockTick<=1){
        _clockhandSprite.rotation++;
        framesForClockTick=time/6;
    }else
        --framesForClockTick;
}

-(void)showFeedback:(BOOL)b{
    feedbackTick=10;
    if(b)
        [self.animationManager runAnimationsForSequenceNamed:@"correct"];
    else
        [self.animationManager runAnimationsForSequenceNamed:@"wrong"];
    _correctBarLeft.visible=true;
    _correctBarRight.visible=true;
}

#pragma mark Touch Controls
-(void) pause{
    upSwipe.enabled = NO;
    downSwipe.enabled = NO;
    [GameplayManager sharedInstance].paused=true;
    PauseScreen *scene=(PauseScreen*)[CCBReader load:@"PauseScreen"];
    [_popoverNode addChild:scene];
    _pauseButton.enabled = NO;
}


-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    selectedObject=nil;
    startLocation = [touch locationInNode:_contentNode];
    if(CGRectContainsPoint([_resumeNode boundingBox], startLocation)){
        selectedObject=_resumeNode;
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    [self fadeResume:touch];
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    CGPoint newLocation = ccp(touchLocation.x/_contentNode.contentSizeInPoints.width,touchLocation.y/_contentNode.contentSizeInPoints.height);
    if(!rulesActive){
        if(selectedObject==_resumeNode){
            selectedObject.position=newLocation;
            float x=newLocation.x-startLocation.x/[self contentSizeInPoints].width;
            float y=newLocation.y-startLocation.y/[self contentSizeInPoints].height;
            selectedObject.position=ccp(.5+x,.5+y);
            if(touchLocation.x<=50){
                [self animateNoBar:true];
            }else if(noBarActive){
                [self animateNoBar:false];
            }
        }
    }
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!rulesActive &&
       selectedObject==_resumeNode){
        CGPoint touchLocation = [touch locationInNode:_contentNode];
        //CGPoint newLocation = ccp(touchLocation.x/,touchLocation.y/_contentNode.contentSizeInPoints.height);
        if(touchLocation.x<=50){
            //select "no" option
            for (int i=0;i<[noArray count];++i){
                if(touchLocation.y>((CCNode*)noArray[i]).position.y*_contentNode.contentSizeInPoints.height-((CCNode*)noArray[i]).contentSize.height/2 && touchLocation.y<((CCNode*)noArray[i]).position.y*_contentNode.contentSizeInPoints.height+((CCNode*)noArray[i]).contentSize.height/2){
                    NSString *s=[NSString stringWithFormat:@"item: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"noSelected"][i]];
                    NSLog(s);
                    
                }
            }
            
            if(_resumeNode.correct==false){
                [self showFeedback:true];
                _correctBarLeft.visible=true;
                NSLog(@"yea");
                ++_resumeNode.correctCount;
            }else
                [self showFeedback:false];
            [self newResume];
        }else if(touchLocation.x>_contentNode.contentSizeInPoints.width-50){
            if(_resumeNode.correct==true){
                [self showFeedback:true];
                _resumeNode.passedCount++;
                _resumeNode.correctCount++;
            }else
                [self showFeedback:false];
            [self newResume];
        }else{
            [self resetResume];
        }
    }
    if(noBarActive){
        [self animateNoBar:false];
    }
}

-(void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    if(noBarActive)
        [self animateNoBar:false];
}

-(void)didSwipe:(UISwipeGestureRecognizer*)sender{
    if(!gameOver){
        [self resetResume];
        UISwipeGestureRecognizerDirection direction=sender.direction;
        if(direction==UISwipeGestureRecognizerDirectionUp && !rulesActive){
            rulesActive=true;
            [_rulebookNode show:true];
        }else if(direction==UISwipeGestureRecognizerDirectionDown && rulesActive){
            self.userInteractionEnabled=true;
            [GameplayManager sharedInstance].paused=false;
            [_rulebookNode show:false];
            if(!ready){
                [self newResume];
                [self newResume];
                ready=true;
            }
            rulesActive=false;
        }
    }
}

-(void)resetResume{
    _tmpResume.opacity=0;
    _resumeNode.position=ccp(.5,.5);
}


#pragma mark Game End

-(void) endGame{
    if([GameplayManager sharedInstance].roundCounter==roundTime*60){
        _pauseButton.enabled = NO;
        self.userInteractionEnabled = false;
        gameOver=true;
        [GameplayManager sharedInstance].paused=true;
        
        ScoreScreen* screen = (ScoreScreen*)[CCBReader load:@"ScoreScreen"];
        if(_resumeNode.correctCount+_tmpResume.correctCount>=10){
            [screen setScreenWithScore:_resumeNode.passedCount+_tmpResume.passedCount message:@"Level Passed" total:_resumeNode.totalCount+_tmpResume.totalCount correct:_resumeNode.correctCount+_tmpResume.correctCount];
            [[NSUserDefaults standardUserDefaults] setInteger:[GameplayManager sharedInstance].level+1 forKey:@"level"];
        }else{
            [screen setScreenWithScore:_resumeNode.passedCount+_tmpResume.passedCount message:@"Level Failed" total:_resumeNode.totalCount+_tmpResume.totalCount correct:_resumeNode.correctCount+_tmpResume.correctCount];
        }
        [_popoverNode addChild:screen];
        ready=false;
    }else
        [GameplayManager sharedInstance].roundCounter++;
}

#pragma mark minigame handling
-(void)minigameYes{
    NSLog(@"minigame pass");
    _bubbleNode.visible=false;
    [GameplayManager sharedInstance].paused=false;
    //[CCBReader load:scene];
    downSwipe.enabled=false;
    upSwipe.enabled=false;
    Minigame* mini;
    switch (minigameCode) {
        case 0:
            mini=(Minigame*)[CCBReader load:@"ShuffleGame"];
            break;
        case 1:
            mini=(Minigame*)[CCBReader load:@"EmailGame"];
            break;
        case 2:
            mini=(Minigame*)[CCBReader load:@"ShuffleGame"];
            break;
    }
    [_popoverNode addChild:mini];
    [mini setGame:minigameCode];
}
-(void)minigameNo{
    minigameNo=true;
    _bubbleNode.visible=false;
    downSwipe.enabled=true;
    [GameplayManager sharedInstance].paused=false;
    NSLog(@"minigame no");
    penaltyChance=arc4random_uniform(10000);
}
-(void)minigamePass{
    minigamePass=true;
    _bubbleNode.visible=false;
    downSwipe.enabled=true;
    [GameplayManager sharedInstance].paused=false;
    NSLog(@"minigame pass");
    penaltyChance=arc4random_uniform(10000);
}

@end
