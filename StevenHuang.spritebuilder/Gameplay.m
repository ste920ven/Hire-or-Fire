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

@implementation Gameplay{
    //timer vars
    int framesForClockTick,minigameCode;
    
    //spritebuilder vars
    Resume *_resumeNode;
    RuleBook *_rulebookNode;
    CCNode *_contentNode,*_scoreScreen,*_noBar,*_bubbleNode,*_tutorial1,*_tutorial2,*_pauseScreen;
    CCSprite *_clockhandSprite;
    CCLabelTTF *_currDateLabel,*_bubbleLabel;
    CCButton *_pauseButton;
    
    bool ready,noBarActive,gameOver,rulesActive,minigameNo,minigamePass,pushedScene;
    NSArray *noArray;
    CCNode *selectedObject;
    CGFloat roundTime,randomEventChance,penaltyChance,penaltyDelay,randomEventDelay;
    NSDictionary *root;
    NSDateComponents *components;
    UISwipeGestureRecognizer *downSwipe,*upSwipe;
    
    CCScene *level;
    ScoreScreen *ss;
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
    
    randomEventDelay=5.f;
    
    [GameplayManager sharedInstance].roundCounter=0;
    ready=false;
    _noBar.zOrder=INT_MAX;
    components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    _currDateLabel.string=[NSString stringWithFormat:@"Today is %d/%d/%d",[components month],[components day],[components year]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"plist"];
    root = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary* resumeInfo= root[@"ResumeInfo"];
    [_resumeNode setup:components rootDir:resumeInfo rules:_rulebookNode];
    _rulebookNode.Leveldata=root[@"Levels"][[GameplayManager sharedInstance].level];
    [_rulebookNode createRulesWithLevel:[GameplayManager sharedInstance].level resumeData:resumeInfo];
    
#pragma mark TODO currently set as constants
    //    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"noNumber"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setupNoOptions:[[NSUserDefaults standardUserDefaults] integerForKey:@"noNumber"]];
    roundTime=60.f;
    
#pragma mark Tutorial
    
    if([GameplayManager sharedInstance].level==0){
        _tutorial1.visible=true;
    }
    
    [_rulebookNode show:true];
    
    //choose random event delay
    
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
    if(![GameplayManager sharedInstance].paused){
        _pauseButton.enabled = YES;
        upSwipe.enabled = YES;
        downSwipe.enabled = YES;
        self.userInteractionEnabled = TRUE;
        if(ready){
            //clock
            [self animateClock:roundTime];
            [self endGame];
            if(randomEventDelay*60==[GameplayManager sharedInstance].roundCounter){
                NSString *msg;
                minigameCode=arc4random_uniform(2);
                switch (minigameCode) {
                    case 0:
                        msg=@"I need you to sign some documents for me";
                        break;
                    case 1:
                        msg=@"Quick, delete your emails. The boss is coming to check them";
                        break;
                }
                _bubbleLabel.string=msg;
                _bubbleNode.visible=true;
                _bubbleNode.zOrder=INT_MAX;
            }
        }
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
-(void) pause{
    upSwipe.enabled = NO;
    downSwipe.enabled = NO;
    [GameplayManager sharedInstance].paused=true;
    _pauseButton.enabled = NO;
    _pauseScreen.visible=true;
    self.userInteractionEnabled = false;
}


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
    //if(ready)
    if(!gameOver){
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
                [_tutorial1 removeFromParent];
            }
            rulesActive=false;
        }
    }
}

-(void)resetResume{
    _resumeNode.position=ccp(.5,.5);
}


#pragma mark Game End

-(void) endGame{
    if([GameplayManager sharedInstance].roundCounter==roundTime*60){
        _pauseButton.enabled = NO;
        self.userInteractionEnabled = false;
        gameOver=true;
        
        ScoreScreen* screen = (ScoreScreen*)[CCBReader load:@"screens/scoreScreen"];
        screen.positionType = CCPositionTypeNormalized;
        screen.position = ccp(0.5, 0.5);
        screen.zOrder = INT_MAX;
        [screen setScreenWithScore:_resumeNode.passedCount message:@"Level Passed" total:_resumeNode.totalCount correct:_resumeNode.correctCount];
        [_contentNode addChild:screen];
        ready=false;
    }else
        [GameplayManager sharedInstance].roundCounter++;
}

#pragma mark minigame handling
-(void)minigameYes{
    NSLog(@"minigame pass");
    Minigame *scene = (Minigame*)[CCBReader loadAsScene:@"Minigame"];
    [scene setGame:minigameCode];
    [[CCDirector sharedDirector] pushScene:scene];
}
-(void)minigameNo{
    minigameNo=true;
    _bubbleNode.visible=false;
    NSLog(@"minigame no");
    penaltyChance=arc4random_uniform(10000);
}
-(void)minigamePass{
    minigamePass=true;
    _bubbleNode.visible=false;
    NSLog(@"minigame pass");
    penaltyChance=arc4random_uniform(10000);
}

#pragma mark pause
-(void)LevelSelect{
    self.userInteractionEnabled = true;
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)Resume{
    self.userInteractionEnabled=true;
    [_pauseScreen removeFromParent];
    [GameplayManager sharedInstance].paused=false;
}

@end
