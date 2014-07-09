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

@implementation Gameplay{
    Resume *_resumeNode;
    RuleBook *_rulebookNode;
    CCNode *_contentNode;
    CCNode *selectedObject;
    CCSprite *_clockhandSprite;
    NSMutableArray *documentArray;
    
    NSDictionary *root;
    NSDateComponents *components;
}

#pragma mark Setup
-(void) didLoadFromCCB{
    self.userInteractionEnabled = TRUE;
    documentArray=[NSMutableArray array];
    documentArray[0]=_rulebookNode;
    documentArray[1]=_resumeNode;
    components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"plist"];
    root = [NSDictionary dictionaryWithContentsOfFile:path][@"ResumeInfo"];
    [_resumeNode setup:components rootDir:root];
    [self newResume];
}

#pragma mark Animations Controls
-(void)newResume{
    [_resumeNode createNew];
}

-(void)update:(CCTime)delta{
    _clockhandSprite.rotation++;
}

#pragma mark Touch Controls
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    selectedObject=nil;
    //item on top get priority
    for(CCNode* documentNode in documentArray){
        if(CGRectContainsPoint([documentNode boundingBox], touchLocation)){
            selectedObject=documentNode;
            break;
        }
    }
    selectedObject.zOrder=1;
    [documentArray removeObject:selectedObject];
    [documentArray insertObject:selectedObject atIndex:0];
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



@end
