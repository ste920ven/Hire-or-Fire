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
}

-(void)setup:(NSDateComponents*)_now rootDir:(NSDictionary*)_root rules:(CCNode *)_rules{
    
#pragma mark TODO temp
    correctFactor=10000;
    
    self.correctCount=0;
    self.totalCount=0;
    self.passedCount=0;
    now=_now;
    root=_root;
    rulebook=(RuleBook*)_rules;
}

-(void)createDay:(int) maxDays{
    birthdate=arc4random_uniform(maxDays+1);
}

-(void)createNew{
    self.zOrder=1;
    
    //increment total counter
    ++self.totalCount;
    
    //generate random school
    education=[NSString stringWithFormat:@"%@ Univeristy",root[@"Schools"][arc4random_uniform(SCHOOL_SIZE) ]];
    
    //generate random phone number
    
    phoneNumber=[NSString stringWithFormat:@"%.3d-%.3d-%.4d",arc4random_uniform(1000),arc4random_uniform(1000),arc4random_uniform(10000)];
    
    //generate random address
    addressBegin=[NSString stringWithFormat:@"%d %@",arc4random_uniform(ADDRESS_NUM_SIZE+1),root[@"Address1"][arc4random_uniform(ADDRESS_BODY_SIZE)]];
    addressEnd=root[@"Address2"][arc4random_uniform(ADDRESS_END_SIZE)];
    
    //generate random name
    name=[NSString stringWithFormat:@"%@ %@",root[@"firstNames"][arc4random_uniform(FIRSTNAME_SIZE)]
          ,root[@"lastNames"][arc4random_uniform(LASTNAME_SIZE)] ];
    
    //    //generate random gender
    //    int gender=arc4random_uniform()%2;
    //    if(gender)
    //        self.male=true;
    
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
    
    experience1=[[Tuple alloc] init];
    experience1.first=key;
    experience1.second=tmpDict[key][arc4random_uniform([tmpDict[key] count])];
    
    key = keys[arc4random_uniform([keys count])];
    experience2=[[Tuple alloc] init];
    experience2.first=key;
    experience2.second=tmpDict[key][arc4random_uniform([tmpDict[key] count])];;
    
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
        ++self.correctCount;
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
        NSString* rule=rulebook.rules[ruleType];
        switch ([ruleType intValue]) {
            case MAXAGE:
                if(wrong){
                    if(age>[rule intValue])
                        birthyear=year-(arc4random_uniform(BIRTHDAY_RANGE-[rule intValue]-5)+[rule intValue]);
                }else if(age>[rule intValue])
                    birthyear=year-(arc4random_uniform([rule intValue]-5)+5);
                break;
            case MINAGE:
                if(wrong){
                    if(age>[rule intValue])
                        birthyear=year-(arc4random_uniform([rule intValue]-5)+5);
                }else if(age>[rule intValue])
                    birthyear=year-(arc4random_uniform(BIRTHDAY_RANGE-[rule intValue]-5)+[rule intValue]);
                break;
            case NAME:
                break;
            case ADDRESS:
                break  ;
            case EDUCATION:
                if(wrong){
                    while([education rangeOfString:rule].location != NSNotFound)
                        education=[NSString stringWithFormat:@"%@ Univeristy",root[@"Schools"][arc4random_uniform(SCHOOL_SIZE) ]];
                }else if([education rangeOfString:rule].location == NSNotFound)
                    education=[NSString stringWithFormat:@"%@ Univeristy",rule];
                break;
            case PHONE:
                if(wrong){
                    while([phoneNumber rangeOfString:rule].location == 0)
                        phoneNumber=[NSString stringWithFormat:@"%.3d-%.3d-%.4d",arc4random_uniform(1000),arc4random_uniform(1000),arc4random_uniform(10000)];
                }else if([phoneNumber rangeOfString:rule].location != 0)
                    phoneNumber=[NSString stringWithFormat:@"%@-%.3d-%.4d",rule,arc4random_uniform(1000),arc4random_uniform(10000)];
                break;
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
                        experience1.second=root[@"Experiences"][experience1.first][arc4random_uniform([root[@"Experiences"][rule] count])];
                        experience1.boolean=NO;
                    }if(experience2.boolean==YES){
                         NSArray* keys = [root[@"Experiences"] allKeys];
                        while([experience2.first isEqualToString:rule])
                            experience2.first=keys[arc4random_uniform(EXPERIENCE_SIZE)];
                        experience2.second=root[@"Experiences"][experience2.first][arc4random_uniform([root[@"Experiences"][rule] count])];
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
            }case EXPERIENCE_JOB:
#pragma mark TODO
                if([experience1.second isEqualToString:rule])
                    experience1.boolean=true;
                if([experience2.second isEqualToString:rule])
                    experience2.boolean=true;
                if(wrong){
                    
                }else {
                    if(experience1.boolean==false){
                        
                    }if(experience2.boolean==false){
                        
                    }
                }
                break;
            case EXPERIENCE_LOCATION:
                
                break;
            case ADDRESS_TYPE:
                if(wrong){
                    while([addressEnd isEqualToString:rule])
                        addressEnd=root[@"Address2"][arc4random_uniform(ADDRESS_END_SIZE)];
                }else
                    if(![addressEnd isEqualToString:rule])
                        addressEnd=rule;
                break;
            case EDUCATION_LEVEL:
                
                break;
                
        }
        ++i;
    }
    
    //display all info
    _birthdateLabel.string=[NSString stringWithFormat:@"%@ %d, %d",birthmonth,birthdate,birthyear];
    _nameLabel.string=name;
    _addressLabel.string=[NSString stringWithFormat:@"%@ %@",addressBegin,addressEnd];
    _phoneNumberLabel.string=phoneNumber;
    _educationLabel.string=education;
    
    _experience1Label.string=[NSString stringWithFormat:@"%@, %@",experience1.first,experience1.second];
    _experience2Label.string=[NSString stringWithFormat:@"%@, %@",experience2.first,experience2.second];
    
    //move new resume to position
    self.position=ccp(.6,1.5);
    //CCActionDelay *delay = [CCActionDelay actionWithDuration:0.3f];
	CCActionScaleTo *translation = [CCActionMoveTo actionWithDuration:0.3f position:ccp(.5,.6)];
	CCActionSequence *sequence = [CCActionSequence actionWithArray:@[translation]];
	[self runAction:sequence];
    
}



@end
