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
    NSInteger birthdate;
    NSString *birthmonth;
    NSInteger birthyear;
    NSString * addressEnd;
    NSString * addressBegin;
    
    int correctFactor;
    RuleBook * rulebook;
    NSDictionary* root;
    NSDateComponents* now;
    CCLabelTTF *_nameLabel,*_addressLabel,*_birthdateLabel,*_phoneNumberLabel,*_experience1Label,*_experience2Label,*_educationLabel;
    
    CCLabelTTF *_debug;
    int debugInt;
}

-(void)setup:(NSDateComponents*)_now rootDir:(NSDictionary*)_root rules:(CCNode *)_rules{
    
#pragma mark TODO temp
    
    correctFactor=5000;
    
    self.correctCount=0;
    self.totalCount=-1;
    self.passedCount=0;
    now=_now;
    root=_root;
    rulebook=(RuleBook*)_rules;
    experience1=[[Tuple alloc] init];
    experience2=[[Tuple alloc] init];
}

-(void)createDay:(int) maxDays{
    birthdate=arc4random_uniform(maxDays+1);
}

-(void)createNew{
    self.zOrder=1;
    
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
    
    //generate random birthday
    NSInteger year = [now year];
    birthyear=year-(arc4random_uniform(BIRTHDAY_RANGE+5));
    int month=arc4random_uniform(12);
    switch(month){
        case 0:
            birthmonth=@"January";
            [self createDay:31];
            break;
        case 1:
            birthmonth=@"February";
            [self createDay:28];
            break;
        case 2:
            birthmonth=@"March";
            [self createDay:31];
            break;
        case 3:
            birthmonth=@"April";
            [self createDay:30];
            break;
        case 4:
            birthmonth=@"May";
            [self createDay:31];
            break;
        case 5:
            birthmonth=@"June";
            [self createDay:30];
            break;
        case 6:
            birthmonth=@"July";
            [self createDay:31];
            break;
        case 7:
            birthmonth=@"August";
            [self createDay:31];
            break;
        case 8:
            birthmonth=@"September";
            [self createDay:30];
            break;
        case 9:
            birthmonth=@"October";
            [self createDay:31];
            break;
        case 10:
            birthmonth=@"Novemeber";
            [self createDay:30];
            break;
        case 11:
            birthmonth=@"December";
            [self createDay:31];
            break;
    }
    
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
    
    //calculate age
    age=year-birthyear;
    if([now month]==month+1){
        if([now day]<birthdate)
            --age;
    }else if([now month]<month)
        --age;
    
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
        switch ([ruleType intValue]) {
            case MAXAGE:{
                if(wrong){
                    if(age>[rule intValue])
                        birthyear=year-(arc4random_uniform(BIRTHDAY_RANGE-[rule intValue]-5)+[rule intValue]);
                }else if(age>[rule intValue])
                    birthyear=year-(arc4random_uniform([rule intValue]-5)+5);
                break;
            }
            case MINAGE:{
                if(wrong){
                    if(age>[rule intValue])
                        birthyear=year-(arc4random_uniform([rule intValue]-5)+5);
                }else if(age>[rule intValue])
                    birthyear=year-(arc4random_uniform(BIRTHDAY_RANGE-[rule intValue]-5)+[rule intValue]);
                break;
            }
            case NAME:
                break;
            case ADDRESS:
                break;
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
        }
        ++i;
    }
    
    //display all info
    _birthdateLabel.string=[NSString stringWithFormat:@"%@ %d, %d",birthmonth,birthdate,birthyear];
    _nameLabel.string=name;
    _addressLabel.string=[NSString stringWithFormat:@"%@ %@",addressBegin,addressEnd];
    _phoneNumberLabel.string=phoneNumber;
    _educationLabel.string=[NSString stringWithFormat:@"%@ %@",education,educationLevel];
    
    NSNumberFormatter * formatter =  [[NSNumberFormatter alloc] init];
    [formatter setUsesSignificantDigits:YES];
    [formatter setMinimumSignificantDigits:2];
    
    _experience1Label.string=[NSString stringWithFormat:@"%@, %@ -%@yrs\n%@",experience1.first,experience1.second,[formatter stringFromNumber:[NSNumber numberWithFloat:experience1.num]],experience1.third];
    
    _experience2Label.string=[NSString stringWithFormat:@"%@, %@ -%@yrs\n%@",experience2.first,experience2.second,[formatter stringFromNumber:[NSNumber numberWithFloat:experience2.num]],experience2.third];
    
    //move new resume to position
    self.position=ccp(.6,1.5);
    //CCActionDelay *delay = [CCActionDelay actionWithDuration:0.3f];
	CCActionScaleTo *translation = [CCActionMoveTo actionWithDuration:0.3f position:ccp(.5,.5)];
	CCActionSequence *sequence = [CCActionSequence actionWithArray:@[translation]];
	[self runAction:sequence];
    
    //debuging info
    _debug.string=[NSString stringWithFormat:@"correctness: %d, %d",self.correct,debugInt];
    
}



@end
