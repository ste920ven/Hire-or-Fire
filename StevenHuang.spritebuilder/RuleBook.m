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
    NSString *rulesText,*tutorial,*minigameTutorial;
    int unlockedNum;
    bool inUse;
}

-(void)didLoadFromCCB{
    self.userInteractionEnabled=true;
    
    tutorial=@"HELP\n\t\t\t Hire at least 10 people in one day\n\n\n<----Put here for No\t\t\t Put her for Yes----->\n\n\n\n\n\n\t\t\tClick to cycle through the rules\n\t\t\t\tSwipe down when ready";
    minigameTutorial=@"MINIGAMES\n\nNo: Don't do it and risk getting a penalty at the end of the day\n\nBuddy!: Pass it onto a coworker and reduce your chance of getting caught but increasing your penalty if you do\n\nDo it: Complete a minigame before you can go back to your normal work";
    self.currPage=RULES;
    
    unlockedNum=2;
    if([GameplayManager sharedInstance].level>8)
        unlockedNum++;
    
    //show tutorial
    if([GameplayManager sharedInstance].level==0){
        _rulesLabel.string=tutorial;
        self.currPage=TUTORIAL;
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    self.currPage=(++self.currPage)%unlockedNum;
    [self updatePage];
}


-(void)updatePage{
    if(inUse){
        switch (self.currPage) {
            case RULES:
                _rulesLabel.string=rulesText;
                break;
            case TUTORIAL:
                _rulesLabel.string=tutorial;
                break;
            case MINIGAME_TUTORIAL:
                _rulesLabel.string=minigameTutorial;
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
    [tmp appendFormat:@"RULES\n\n"];
    for (NSString* ruleType in self.Leveldata){
        counter++;
        [tmp appendFormat:@"%d. ",counter];
        NSString *entry;
        int num=[ruleType intValue]%100;
        int b=[ruleType intValue]/100;
        
        switch (num) {
            case MAXAGE:{ //0
                entry=[NSString stringWithFormat:@"%d",arc4random_uniform(50)+10];
                if(b==0)
                    [tmp appendFormat:@"Must be at most %@ years old\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Applicants that are %@ years old or younger are automatically in\n",entry];
                if(b==2)
                    [tmp appendFormat:@"Applicants that are %@ years old or younger are automatically out\n",entry];
                break;
            }
            case MINAGE:{ //1
                entry=[NSString stringWithFormat:@"%d",arc4random_uniform(50)+10];
                if(b==0)
                    [tmp appendFormat:@"Must be atleast %@ years old\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Applicants that are %@ years old or older are automatically in\n",entry];
                if(b==2)
                    [tmp appendFormat:@"Applicants that are %@ years old or older are automatically out\n",entry];
                break;
            }
            case NAME:{ //2
                [tmp appendFormat:@""];
                break;
            }case ADDRESS:{ //3
                [tmp appendFormat:@"Must live in this zipcode: %5@", entry];
                break;
            }
            case EDUCATION:{ //4
                entry=data[@"Schools"][arc4random_uniform(SCHOOL_SIZE)];
                if(b==0)
                    [tmp appendFormat:@"Must have attended to a %@ school\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Applicants who attended %@ are automatically in\n",entry];
                if(b==2)
                    [tmp appendFormat:@"Applicants who attended %@ are automatically out\n",entry];
                break;
            }
            case PHONE:{ //5
                entry=[NSString stringWithFormat:@"%03d",arc4random_uniform(1000)];
                if(b==0)
                    [tmp appendFormat:@"Must be from this areacode (%3@)\n", entry];
                if(b==1)
                    [tmp appendFormat:@"Applicants with the areacode (%3@) are automatically in\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Applicants with the areacode (%3@) are automatically out\n", entry];
                break;
            }
            case EXPERIENCE_FIELD:{ //6
                NSArray* keys = [data[@"Experiences"] allKeys];
                entry = keys[arc4random_uniform(EXPERIENCE_SIZE)];
                if(b==0)
                    [tmp appendFormat:@"Must have worked in the field of %@\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Applicants who have worked in the field of %@ are automatically in\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Applicants who have worked in the field of %@ are automatically out\n", entry];
                break;
            }
            case EXPERIENCE_JOB:{
                NSDictionary* tmpDict=data[@"Experiences"];
                NSArray* keys = [tmpDict allKeys];
                NSArray* key = keys[arc4random_uniform(EXPERIENCE_SIZE)];
                entry = tmpDict[key][arc4random_uniform([tmpDict[key] count])];
                if(b==0)
                    [tmp appendFormat:@"Must have worked as a %@\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Applicants who have worked as a %@ are automatically in\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Applicants who have worked as a %@ are automatically out\n", entry];
                break;
            }
            case EXPERIENCE_LOCATION:{
                entry=data[@"Locations"][arc4random_uniform(LOCATION_SIZE)];
                if(b==0)
                    [tmp appendFormat:@"Must have worked at %@\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Applicants who have worked at %@ are automatically in\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Applicants who have worked at %@ are automatically out\n", entry];
                
                break;
            }
            case ADDRESS_TYPE:{
                entry=data[@"Address2"][arc4random_uniform(ADDRESS_END_SIZE)];
                if(b==0)
                    [tmp appendFormat:@"Must live on a %@\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Applicants who live on a %@ are automatically in\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Applicants who live on a %@ are automatically out\n", entry];
                break;
            }
            case EDUCATION_LEVEL:{
                entry=data[@"SchoolLevel"][arc4random_uniform(3)+1];
                if(b==0)
                    [tmp appendFormat:@"Must have attened a minimum level of %@\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Applicants who have attended a %@ are automatically in\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Applicants who have attended a %@ are automatically out\n", entry];
                break;
            }
            case EXPERIENCE_LENGTH:{
                entry=[NSString stringWithFormat:@"%d",arc4random_uniform(EXPERIENCE_LENGTH_MAX)+1 ];
                if(b==0)
                    [tmp appendFormat:@"Must have %@ yrs of experience\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Applicants who have %@ years of experience are automatically in\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Applicants who have %@ years of experience are automatically out\n", entry];
                break;
            }
            case ACTIVITIES:{
                entry=data[@"Activities"][arc4random_uniform(ACTIVITIES_SIZE)];
                if(b==0)
                    [tmp appendFormat:@"Must be interested in %@\n",entry];
                if(b==1)
                    [tmp appendFormat:@"Applicants who like %@ are automatically in\n", entry];
                if(b==2)
                    [tmp appendFormat:@"Applicants who like %@ are automatically out\n", entry];
            }
        }
        [self.rules setValue:entry forKey:[NSString stringWithFormat:@"%@",ruleType]];
        [tmp appendFormat:@"\n"];
    }
    rulesText=tmp;
}

@end
