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
    float framesForClockTick,feedbackTick;
    
    //spritebuilder vars
    Resume *_resumeNode,*_tmpResume;
    RuleBook *_rulebookNode;
    CCNode *_contentNode,*_scoreScreen,*_noBar,*_bubbleNode,*_tutorial1,*_tutorial2,*_pauseScreen,*_popoverNode,*_correctBarLeft,*_correctBarRight;
    CCSprite *_clockhandSprite;
    CCLabelTTF *_bubbleLabel,*_scoreLabel,*_multiplierLabel;
    CCButton *_pauseButton;
    
    bool ready,noBarActive,gameOver,rulesActive,swipeEnabled;
    NSArray *noArray;
    CCNode *selectedObject;
    CGFloat roundTime,randomEventChance,randomEventDelay,multiplierTime;
    NSDictionary *root;
    UISwipeGestureRecognizer *downSwipe,*upSwipe;
    CGPoint startLocation;
    int score,streak,goalScore,minigameCode,correct,c;
    
    CCScene *level;
    PauseScreen *ps;
    Minigame * mini;
}

#pragma mark Setup
-(void) didLoadFromCCB{
    self.userInteractionEnabled = TRUE;
    
    _tmpResume.cascadeOpacityEnabled=true;
    _resumeNode.cascadeOpacityEnabled=true;
    swipeEnabled=true;
    [GameplayManager sharedInstance].roundCounter=0;
    score=0;
    streak=1;
    rulesActive=true;
    ready=false;
    _noBar.zOrder=INT_MAX;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"plist"];
    root = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary* resumeInfo= root[@"ResumeInfo"];
    
    _multiplierLabel.string=@"";
    _multiplierLabel.visible=false;
    
    [_tmpResume setup:resumeInfo rules:_rulebookNode];
    [_resumeNode setup:resumeInfo rules:_rulebookNode];
    
    _rulebookNode.Leveldata=root[@"Levels"][[GameplayManager sharedInstance].level][@"Rules"];
    goalScore=[root[@"Levels"][[GameplayManager sharedInstance].level][@"Score"] intValue];
    NSArray* arr=_rulebookNode.Leveldata;
    [_rulebookNode createRulesWithLevel:[GameplayManager sharedInstance].level resumeData:resumeInfo];
    _rulebookNode.zOrder=INT_MAX-1;
    _popoverNode.zOrder=INT_MAX;
    
    [self setupNoOptions:[[NSUserDefaults standardUserDefaults] integerForKey:@"noNumber"]];
    roundTime=60.f;
    
    [[NSUserDefaults standardUserDefaults] setInteger:9 forKey:@"level"];
    
    [_rulebookNode show:true];
    
    _scoreLabel.string=[NSString stringWithFormat:@"$0 / %d",goalScore];
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
    float f1=2*fabsf([touch locationInNode:self].x-startLocation.x) / [self contentSizeInPoints].width;
    float f2=2*fabsf([touch locationInNode:self].y-startLocation.y) / [self contentSizeInPoints].height;
    _tmpResume.opacity=MAX(f1, f2);
}

-(void)update:(CCTime)delta{
    if(![GameplayManager sharedInstance].minigame){
        if(![GameplayManager sharedInstance].paused){
            _pauseButton.enabled = YES;
            swipeEnabled=true;
            self.userInteractionEnabled = TRUE;
            if(ready){
                //clock
                
                [self animateClock:delta];
                [self endGame];
                [GameplayManager sharedInstance].roundCounter+=delta;
                
                //multiplier handling
                if(multiplierTime<=0){
                    if(streak>2){
                        _multiplierLabel.visible=false;
                        streak=1;
                    }
                }else
                    multiplierTime-=delta;
                
                //feedback handling
                if(feedbackTick>0)
                    feedbackTick-=delta;
                else{
                    _correctBarLeft.visible=false;
                    _correctBarRight.visible=false;
                }
                //minigame handling
                int i=c%10;
                if(i>5 && arc4random_uniform(10)<=(i-5)*2){
                    //if(c==1){
                    c=0;
                    NSString *msg;
                    
                    //constant
                    minigameCode=1;
                    
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
                    _bubbleNode.zOrder=INT_MAX-2;
                    [self performSelector:@selector(minigameYes) withObject:self afterDelay:2.0];
                }
            }
        }
    } else{
        score+=[mini getScore];
        _scoreLabel.string=[NSString stringWithFormat:@"$%d / %d",score,goalScore];
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
    _clockhandSprite.rotation=[GameplayManager sharedInstance].roundCounter/roundTime*360-90;
}

-(void)showFeedback:(BOOL)b{
    feedbackTick=.3;
    if(b)
        [self.animationManager runAnimationsForSequenceNamed:@"correct"];
    else{
        streak=1;
        _multiplierLabel.visible=false;
        [self.animationManager runAnimationsForSequenceNamed:@"wrong"];
    }
    _correctBarLeft.visible=true;
    _correctBarRight.visible=true;
}

#pragma mark Touch Controls
-(void) pause{
    [[OALSimpleAudio sharedInstance] playBg:@"Assets/click1.wav"];
    swipeEnabled=false;
    [GameplayManager sharedInstance].paused=true;
    PauseScreen *scene=(PauseScreen*)[CCBReader load:@"PauseScreen"];
    [_popoverNode addChild:scene];
    _pauseButton.enabled = NO;
}


-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    [MGWU logEvent:@"test" withParams:nil];
    selectedObject=nil;
    startLocation = [touch locationInNode:_contentNode];
    if(CGRectContainsPoint([_resumeNode boundingBox], startLocation)){
        selectedObject=_resumeNode;
        [[OALSimpleAudio sharedInstance] playBg:@"Assets/click.wav"];
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
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    if(!rulesActive &&
       selectedObject==_resumeNode){
        //CGPoint newLocation = ccp(touchLocation.x/,touchLocation.y/_contentNode.contentSizeInPoints.height);
        if(touchLocation.x<=50){
            //select "no" option
            for (int i=0;i<[noArray count];++i){
                if(touchLocation.y>((CCNode*)noArray[i]).position.y*_contentNode.contentSizeInPoints.height-((CCNode*)noArray[i]).contentSize.height/2 && touchLocation.y<((CCNode*)noArray[i]).position.y*_contentNode.contentSizeInPoints.height+((CCNode*)noArray[i]).contentSize.height/2){
                    NSString *s=[NSString stringWithFormat:@"Assets/%@.wav",[[NSUserDefaults standardUserDefaults] objectForKey:@"noSelected"][i]];
                    [[OALSimpleAudio sharedInstance] playBg:s];
                }
            }
            
            if(_resumeNode.correct==false){
                _correctBarLeft.visible=true;
                [self correctResume];
            }else
                [self showFeedback:false];
            [self newResume];
        }else if(touchLocation.x>_contentNode.contentSizeInPoints.width-50){
            if(_resumeNode.correct==true){
                _resumeNode.passedCount++;
                [self correctResume];
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
    
    //rulebook handling
    if(swipeEnabled){
        if(startLocation.y<[self contentSizeInPoints].height/3 && touchLocation.y-startLocation.y>50 && !rulesActive){
            rulesActive=true;
            [_rulebookNode show:true];
        }else if(touchLocation.y-startLocation.y<-50 && rulesActive){
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

-(void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    if(noBarActive)
        [self animateNoBar:false];
}

-(void)resetResume{
    _tmpResume.opacity=0;
    _resumeNode.position=ccp(.5,.5);
}

-(void)correctResume{
    [self showFeedback:true];
    ++correct;
    ++c;
    if(streak>1){
        multiplierTime=3.f;
        _multiplierLabel.string=[NSString stringWithFormat:@"x%d",streak/2];
        _multiplierLabel.visible=true;
    }else{
        _multiplierLabel.visible=false;
    }
    score+=(10*(streak/2));
    _scoreLabel.string=[NSString stringWithFormat:@"$%d / %d",score,goalScore];
    if(streak<10)
        ++streak;
}

#pragma mark Game End

-(void) endGame{
    if([GameplayManager sharedInstance].roundCounter>=roundTime){
        _pauseButton.enabled = NO;
        self.userInteractionEnabled = false;
        gameOver=true;
        [GameplayManager sharedInstance].paused=true;
        
        ScoreScreen* screen = (ScoreScreen*)[CCBReader load:@"ScoreScreen"];
        if(correct>=10){
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:[GameplayManager sharedInstance].level ], @"level", [NSNumber numberWithInt:score], @"score", nil];
            [MGWU logEvent:@"levelcomplete" withParams:params];
            [screen setScreenWithScore:score message:true total:_resumeNode.totalCount+_tmpResume.totalCount correct:correct];
            [[NSUserDefaults standardUserDefaults] setInteger:[GameplayManager sharedInstance].level+1 forKey:@"level"];
        }else{
            [screen setScreenWithScore:score message:false total:_resumeNode.totalCount+_tmpResume.totalCount correct:correct];
        }
        [_popoverNode addChild:screen];
        ready=false;
    }
}

#pragma mark minigame handling
-(void)minigameYes{
    _bubbleNode.visible=false;
    [GameplayManager sharedInstance].paused=false;
    [GameplayManager sharedInstance].minigame=true;
    swipeEnabled=false;
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
    [mini setGame:minigameCode multiplier:streak];
}

@end
