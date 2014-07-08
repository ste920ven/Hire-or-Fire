//
//  Gameplay.m
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Resume.h"

@implementation Gameplay{
    Resume *_resumeNode;
    CCNode *_contentNode;
    CCNode *selectedObject;
    NSMutableArray *resumeArray;
}

#pragma mark Setup
-(void) didLoadFromCCB{
    self.userInteractionEnabled = TRUE;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"plist"];
    NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:path];
    for(int i=0;i<30;++i){
        Resume* r=[[Resume alloc] initWithCurrentDate:components rootDir:root];
        resumeArray[i]=r;
    }
}

#pragma mark Animations Controls
-(void)newResume{
    _resumeNode=resumeArray.lastObject;
    resumeArray.removeLastObject;
}

#pragma mark Touch Controls
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    if(CGRectContainsPoint([_resumeNode boundingBox], touchLocation)){//touch is in _resumeNode
        selectedObject=_resumeNode;
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    selectedObject.position=touchLocation;
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    if(touchLocation.x<=20 || touchLocation.x>_contentNode.contentSizeInPoints.width-20)
        [self newResume];
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{

}



@end
