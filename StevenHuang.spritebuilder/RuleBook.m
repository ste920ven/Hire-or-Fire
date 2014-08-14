//
//  RuleBook.m
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RuleBook.h"
#import "GameplayManager.h"


@implementation RuleBook{
    CCLabelTTF *_rulesLabel;
    NSString *rulesText,*tutorial;
    int unlockedNum;
    CCSprite *_tutorialNode;
    bool inUse;
    CGPoint startlocation;
}

-(void)didLoadFromCCB{
    self.userInteractionEnabled=true;
    
    tutorial=@"HELP";
    self.currPage=RULES;
    
    unlockedNum=2;
    
    //show tutorial
    if([GameplayManager sharedInstance].level==0){
        _rulesLabel.string=tutorial;
        self.currPage=TUTORIAL;
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    startlocation=[touch locationInWorld];
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if([touch locationInWorld].y-startlocation.y<-[self contentSizeInPoints].height/4){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Swipe Down" object:self];
    }
    self.currPage=(++self.currPage)%unlockedNum;
    int i=arc4random_uniform(3)+1;
    NSString *s=[NSString stringWithFormat:@"Assets/bookFlip%d.wav",i];
    [[OALSimpleAudio sharedInstance] playBg:s];
    [self updatePage];
}


-(void)updatePage{
    if(inUse){
        _tutorialNode.visible=false;
        switch (self.currPage) {
            case RULES:
                _rulesLabel.string=rulesText;
                break;
            case TUTORIAL:
                _rulesLabel.string=tutorial;
                _tutorialNode.visible=true;
                break;
        }
    }
}

-(void)show:(bool)b{
    inUse=b;
    [self updatePage];
    CCActionScaleTo *translation;
    if(b){
        translation = [CCActionMoveTo actionWithDuration:0.3f position:ccp(.5,0)];
    }else{
        self.currPage=RULES;
        translation = [CCActionMoveTo actionWithDuration:0.3f position:ccp(.5,-360)];
    }
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[translation]];
    [self runAction:sequence];
}

-(void)createRulesWithLevel:(int)level resumeData:(NSDictionary*)data{
    self.rules=[[NSMutableDictionary alloc] init];
    int counter=0;
    NSMutableString *tmp =[NSMutableString string];
    [tmp appendFormat:@"REQUIREMENTS\n\n"];
    for (NSString* ruleType in self.Leveldata){
        counter++;
        [tmp appendFormat:@"%d. ",counter];
        NSString *entry;
        int num=[ruleType intValue]%100;
        int b=[ruleType intValue]/100;
        
        switch (num) {
            case EDUCATION:{ //0
                entry=data[@"Schools"][arc4random_uniform(SCHOOL_SIZE)];
                if(b==0)
                    [tmp appendFormat:@"Must have attended to a %@ school\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Accept all who have attended %@\n",entry];
                if(b==2)
                    [tmp appendFormat:@"Deny all who attended %@\n",entry];
                break;
            }
            case PHONE:{ //1
                entry=[NSString stringWithFormat:@"%03d",arc4random_uniform(1000)];
                if(b==0)
                    [tmp appendFormat:@"Must be from this areacode (%3@)\n", entry];
                if(b==1)
                    [tmp appendFormat:@"Accept all who have the areacode (%3@)\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Deny all who have  the areacode (%3@)\n", entry];
                break;
            }
            case EXPERIENCE_FIELD:{ //2
                NSArray* keys = [data[@"Experiences"] allKeys];
                entry = keys[arc4random_uniform(EXPERIENCE_SIZE)];
                if(b==0)
                    [tmp appendFormat:@"Must have worked in the field of %@\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Accept all who have worked in the field of %@\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Deny all who have worked in the field of %@\n", entry];
                break;
            }
            case EXPERIENCE_JOB:{  //3
                NSDictionary* tmpDict=data[@"Experiences"];
                NSArray* keys = [tmpDict allKeys];
                NSArray* key = keys[arc4random_uniform(EXPERIENCE_SIZE)];
                entry = tmpDict[key][arc4random_uniform([tmpDict[key] count])];
                if(b==0)
                    [tmp appendFormat:@"Must have worked as a %@\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Accept all who have worked as a %@\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Deny all who have worked as a %@\n", entry];
                break;
            }
            case EXPERIENCE_LOCATION:{  //4
                entry=data[@"Locations"][arc4random_uniform(LOCATION_SIZE)];
                if(b==0)
                    [tmp appendFormat:@"Must have worked at %@\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Accept all who have worked at %@\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Deny all who have worked at %@\n", entry];
                
                break;
            }
            case ADDRESS_TYPE:{  //5
                entry=data[@"Address2"][arc4random_uniform(ADDRESS_END_SIZE)];
                if(b==0)
                    [tmp appendFormat:@"Must live on a %@\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Accept all who live on a %@\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Deny all who live on a %@\n", entry];
                break;
            }
            case EDUCATION_LEVEL:{  //6
                entry=data[@"SchoolLevel"][arc4random_uniform(3)+1];
                if(b==0)
                    [tmp appendFormat:@"Must have obtained at least a %@ degree\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Acecept all who have attended at least a %@\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Deny all who have attended at least a %@\n", entry];
                break;
            }
            case EXPERIENCE_LENGTH:{  //7
                entry=[NSString stringWithFormat:@"%d",arc4random_uniform(EXPERIENCE_LENGTH_MAX)+1 ];
                if(b==0)
                    [tmp appendFormat:@"Must have %@ yrs of experience\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Accept all who have %@ years of experience\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Deny all who have %@ years of experience\n", entry];
                break;
            }
            case ACTIVITIES:{  //8
                entry=data[@"Activities"][arc4random_uniform(ACTIVITIES_SIZE)];
                if(b==0)
                    [tmp appendFormat:@"Must be interested in %@\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Accept all who like %@\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Deny all who like %@\n", entry];
            }
        }
        [self.rules setValue:entry forKey:[NSString stringWithFormat:@"%@",ruleType]];
        [tmp appendFormat:@"\n"];
    }
    rulesText=tmp;
}

@end
