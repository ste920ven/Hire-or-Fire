//
//  Resume.m
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Resume.h"
#import "RuleBook.h"
#import "Tuple.h"

@implementation Resume{
    NSString *phoneNumber;
    NSString *education;
    NSString *educationLevel;
    Tuple *experience1;
    Tuple *experience2;
    NSInteger age;
    NSString *name;
    NSString * addressEnd;
    NSString * addressBegin;
    int actAmt;
    NSMutableArray *activities;
    
    int correctFactor;
    RuleBook * rulebook;
    NSDictionary* root;
    CCLabelTTF *_nameLabel,*_addressLabel,*_birthdateLabel,*_phoneNumberLabel,*_experience1Label,*_experience2Label,*_educationLabel,*_activitiesLabel;
    
    CCLabelTTF *_debug;
    int debugInt;
}

-(void)setup:(NSDictionary*)_root rules:(CCNode *)_rules{
    
#pragma mark TODO temp
    
    correctFactor=6000;
    
    self.totalCount=-1;
    self.passedCount=0;
    root=_root;
    rulebook=(RuleBook*)_rules;
    experience1=[[Tuple alloc] init];
    experience2=[[Tuple alloc] init];
    activities=[NSMutableArray array];
}

-(void)createNew{
    
    //increment total counter
    ++self.totalCount;
    
    //generate random school
    education=[NSString stringWithFormat:@"%@",root[@"Schools"][arc4random_uniform(SCHOOL_SIZE) ]];
    educationLevel=[NSString stringWithFormat:@"%@",root[@"SchoolLevel"][arc4random_uniform(4)]];
    
    //generate random phone number
    
    phoneNumber=[NSString stringWithFormat:@"%.3d-%.3d-%.4d",arc4random_uniform(1000),arc4random_uniform(1000),arc4random_uniform(10000)];
    
    //generate random address
    addressBegin=[NSString stringWithFormat:@"%d %@",arc4random_uniform(ADDRESS_NUM_SIZE+1),root[@"Address1"][arc4random_uniform(ADDRESS_BODY_SIZE)]];
    addressEnd=root[@"Address2"][arc4random_uniform(ADDRESS_END_SIZE)];
    
    //generate random name
    name=[NSString stringWithFormat:@"%@ %@",root[@"firstNames"][arc4random_uniform(FIRSTNAME_SIZE)]
          ,root[@"lastNames"][arc4random_uniform(LASTNAME_SIZE)] ];
    
    //randomly generate experiences
    NSDictionary *tmpDict=root[@"Experiences"];
    NSArray* keys = [tmpDict allKeys];
    NSString* key = keys[arc4random_uniform(EXPERIENCE_SIZE)];
    
    experience1.first=key;
    experience1.second=tmpDict[key][arc4random_uniform([tmpDict[key] count])];
    experience1.third=root[@"Locations"][arc4random_uniform(LOCATION_SIZE)];
    experience1.num=(arc4random_uniform(EXPERIENCE_LENGTH_MAX*2)+1)/2.0;
    
    key = keys[arc4random_uniform([keys count]-1)];
    experience2.first=key;
    experience2.second=tmpDict[key][arc4random_uniform([tmpDict[key] count])];
    experience2.third=root[@"Locations"][arc4random_uniform(LOCATION_SIZE)];
    experience2.num=(arc4random_uniform(EXPERIENCE_LENGTH_MAX*2)+1)/2.0;
    
    //create activities
    actAmt=arc4random_uniform(5)+1;
    [activities removeAllObjects];
    for(int i=0;i<actAmt;++i){
        NSString *tmp=root[@"Activities"][arc4random_uniform(ACTIVITIES_SIZE)];
        if(![activities containsObject:tmp])
            [activities addObject:tmp];
    }
    
    //choose if resume will be correct or incorrect
    if(arc4random_uniform(10000)>correctFactor){
        self.correct=false;
    }else{
        self.correct=true;
    }
    
    //apply rules
    int wrongRuleIndex;
    if(self.correct)
        wrongRuleIndex=INT_MAX;
    else{
        int numRules = [rulebook.rules count];//counts keys
        wrongRuleIndex = arc4random_uniform(numRules);
    }
    int i=0;
    for(NSString* ruleType in rulebook.rules){
        bool wrong=false;
        if(i==wrongRuleIndex)
            wrong=true;
#pragma mark DEBUGGING
        if(wrong){
            debugInt=[ruleType intValue];
        }
        NSString* rule=rulebook.rules[ruleType];
        
        //calculate for special rules
        int num=[ruleType intValue]%100;
        int b=[ruleType intValue]/100;
        if(b==1){
            if(arc4random_uniform(100)<10){
                wrong=false;
                debugInt=[ruleType intValue];
                self.correct=true;
            }else{
                wrong=true;
            }
        }
        else if(b==2){
            if(arc4random_uniform(100)<10){
                wrong=false;
                debugInt=[ruleType intValue];
                self.correct=false;
            }else{
                wrong=true;
            }
        }
        [self applyRules:num b:wrong str:rule];
        ++i;
    }
    
    //display all info
    _nameLabel.string=name;
    _addressLabel.string=[NSString stringWithFormat:@"%@ %@",addressBegin,addressEnd];
    _phoneNumberLabel.string=phoneNumber;
    _educationLabel.string=[NSString stringWithFormat:@"%@ %@",education,educationLevel];
    NSMutableString *tmp=[NSMutableString stringWithString:@"Likes "];
    for(NSString *item in activities){
        [tmp appendFormat:@"%@, ",item];
    }
    NSString *s=[tmp substringToIndex:[tmp length]-2];
    _activitiesLabel.string=s;
    
    NSNumberFormatter * formatter =  [[NSNumberFormatter alloc] init];
    [formatter setUsesSignificantDigits:YES];
    [formatter setMinimumSignificantDigits:2];
    
    _experience1Label.string=[NSString stringWithFormat:@"%@, %@\n%@ - %@yrs",experience1.first,experience1.second,experience1.third,[formatter stringFromNumber:[NSNumber numberWithFloat:experience1.num]]];
    
    _experience2Label.string=[NSString stringWithFormat:@"%@, %@\n%@ - %@yrs",experience2.first,experience2.second,experience2.third,[formatter stringFromNumber:[NSNumber numberWithFloat:experience2.num]]];
    
    self.position=ccp(.5,.5);
    
    //debuging info
    //_debug.string=[NSString stringWithFormat:@"correctness: %d, %d",self.correct,debugInt];
    
}


-(void)applyRules:(int)num b:(bool)wrong str:(NSString*)rule{
    switch (num) {
        case EDUCATION:{
            if(wrong){
                while([education rangeOfString:rule].location != NSNotFound)
                    education=root[@"Schools"][arc4random_uniform(SCHOOL_SIZE)];
            }else if([education rangeOfString:rule].location == NSNotFound)
                education=rule;
            break;
        }
        case PHONE:{
            if(wrong){
                while([phoneNumber rangeOfString:rule].location == 0)
                    phoneNumber=[NSString stringWithFormat:@"%.3d-%.3d-%.4d",arc4random_uniform(1000),arc4random_uniform(1000),arc4random_uniform(10000)];
            }else if([phoneNumber rangeOfString:rule].location != 0)
                phoneNumber=[NSString stringWithFormat:@"%@-%.3d-%.4d",rule,arc4random_uniform(1000),arc4random_uniform(10000)];
            break;
        }
        case EXPERIENCE_FIELD:{
            if([experience1.first isEqualToString:rule])
                experience1.boolean=YES;
            if([experience2.first isEqualToString:rule])
                experience2.boolean=YES;
            if(wrong){
                if(experience1.boolean==YES){
                    NSArray* keys = [root[@"Experiences"] allKeys];
                    while([experience1.first isEqualToString:rule])
                        experience1.first=keys[arc4random_uniform(EXPERIENCE_SIZE)];
                    experience1.second=root[@"Experiences"][experience1.first][arc4random_uniform([root[@"Experiences"][experience1.first] count])];
                    experience1.boolean=NO;
                }if(experience2.boolean==YES){
                    NSArray* keys = [root[@"Experiences"] allKeys];
                    while([experience2.first isEqualToString:rule])
                        experience2.first=keys[arc4random_uniform(EXPERIENCE_SIZE)];
                    experience2.second=root[@"Experiences"][experience2.first][arc4random_uniform([root[@"Experiences"][experience2.first] count])];
                    experience2.boolean=NO;
                }
            }else{
                if(experience1.boolean==NO){
                    experience1.first=rule;
                    experience1.second=root[@"Experiences"][rule][arc4random_uniform([root[@"Experiences"][rule] count])];
                    experience1.boolean=YES;
                }if(experience2.boolean==NO){
                    experience2.first=rule;
                    experience2.second=root[@"Experiences"][rule][arc4random_uniform([root[@"Experiences"][rule] count])];
                    experience2.boolean=YES;
                }
            }
            break;
        }
        case EXPERIENCE_JOB:{
            if([experience1.second isEqualToString:rule])
                experience1.boolean=YES;
            if([experience2.second isEqualToString:rule])
                experience2.boolean=YES;
            NSDictionary *tmpDict=root[@"Experiences"];
            NSArray* keys = [tmpDict allKeys];
            NSString *field=keys[0];
            for(NSString * key in root[@"Experiences"] ){
                if([root[@"Experiences"][key] indexOfObject:rule]!=NSNotFound)
                    field=key;
            }
            if(wrong){
                if(experience1.boolean==YES){
                    while([experience1.second isEqualToString:rule])
                        experience1.second=root[@"Experiences"][experience1.first][arc4random_uniform([root[@"Experiences"][experience1.first] count])];
                    experience1.boolean=NO;
                }
                if(experience2.boolean==YES){
                    while([experience2.second isEqualToString:rule])
                        experience2.second=root[@"Experiences"][experience2.first][arc4random_uniform([root[@"Experiences"][experience2.first] count])];
                    experience2.boolean=NO;
                }
            }else {
                if(experience1.boolean==NO){
                    experience1.first=field;
                    experience1.second=rule;
                }if(experience2.boolean==NO){
                    experience2.first=field;
                    experience2.second=rule;
                }
            }
            break;
        }
        case EXPERIENCE_LOCATION:{
            if(wrong){
                while([experience1.third isEqualToString:rule])
                    experience1.third=root[@"Locations"][arc4random_uniform(LOCATION_SIZE)];
                while([experience2.third isEqualToString:rule])
                    experience2.third=root[@"Locations"][arc4random_uniform(LOCATION_SIZE)];
            }else
                if(![experience1.third isEqualToString:rule])
                    experience1.third=rule;
            //randomize which experience has the correct location
            if(arc4random()%2==0){
                Tuple* tmp=experience1;
                experience1=experience2;
                experience2=tmp;
            }
            break;
        }
        case ADDRESS_TYPE:{
            if(wrong){
                while([addressEnd isEqualToString:rule])
                    addressEnd=root[@"Address2"][arc4random_uniform(ADDRESS_END_SIZE)];
            }else
                if(![addressEnd isEqualToString:rule])
                    addressEnd=rule;
            break;
        }
        case EDUCATION_LEVEL:{
            if(wrong){
                if([root[@"SchoolLevel"] indexOfObject:rule]<[root[@"SchoolLevel"] indexOfObject:educationLevel])
                    educationLevel=root[@"SchoolLevel"][arc4random_uniform([root[@"SchoolLevel"] indexOfObject:rule])];
            }else{
                if([root[@"SchoolLevel"] indexOfObject:rule]>[root[@"SchoolLevel"] indexOfObject:educationLevel])
                    educationLevel=rule;
            }
            break;
        }
        case EXPERIENCE_LENGTH:{
            float tmp = [rule floatValue];
            if(wrong){
                if(experience1.num>=tmp)
                    experience1.num=(arc4random_uniform(tmp*2)+1)/2.0;
                if(experience2.num>=tmp)
                    experience2.num=(arc4random_uniform(tmp*2)+1)/2.0;
            }else
                if(experience1.num < tmp)
                    experience1.num=tmp;
            //randomize which experience has the correct location
            if(arc4random()%2==0){
                Tuple* tmp=experience1;
                experience1=experience2;
                experience2=tmp;
            }
            
            break;
        }
        case ACTIVITIES:{
            if(wrong){
                int index=[activities indexOfObject:rule];
                while([activities containsObject:rule])
                    [activities replaceObjectAtIndex:index withObject:root[@"Activities"][arc4random_uniform(ACTIVITIES_SIZE)]];
            }else
                if(![activities containsObject:rule])
                    [activities replaceObjectAtIndex:arc4random_uniform(actAmt) withObject:rule];
            break;
        }
    }
}


@end
