//
//  RuleBook.m
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RuleBook.h"

@implementation RuleBook{
    CCLabelTTF *_rulesLabel;
}

-(void)show:(bool)b{
    CCActionScaleTo *translation;
    if(b){
         translation = [CCActionMoveTo actionWithDuration:0.3f position:ccp(.05,0)];
    }else{
         translation = [CCActionMoveTo actionWithDuration:0.3f position:ccp(.05,-60)];
    }
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[translation]];
    [self runAction:sequence];
}

-(void)createRulesWithLevel:(int)level resumeData:(NSDictionary*)data{
    self.rules=[[NSMutableDictionary alloc] init];
    int counter=0;
    NSMutableString *tmp =[NSMutableString string];
    for (NSString* ruleType in self.Leveldata){
        counter++;
        [tmp appendFormat:@"%d. ",counter];
        NSString *entry;
        switch ([ruleType intValue]) {
            case MAXAGE:{ //0
                entry=[NSString stringWithFormat:@"%d",arc4random_uniform(50)+10];
                [tmp appendFormat:@"Must be at most %@ years old\n",entry];
                break;
            }
            case MINAGE:{ //1
                entry=[NSString stringWithFormat:@"%d",arc4random_uniform(50)+10];
                [tmp appendFormat:@"Must be atleast %@ years old\n",entry];
                break;
            }
            case NAME:{ //2
                [tmp appendFormat:@""];
                break;
            }case ADDRESS:{ //3
#pragma mark TODO
                [tmp appendFormat:@"Must live in this zipcode: %5@", entry];
                break;
            }
            case EDUCATION:{ //4
                NSString* rule=data[@"Schools"][arc4random_uniform(SCHOOL_SIZE)];
                [tmp appendFormat:@"Must have attended to %@ University\n",rule];
                break;
            }
            case PHONE:{ //5
                entry=[NSString stringWithFormat:@"%03d",arc4random_uniform(1000)];
                [tmp appendFormat:@"Must be from this areacode (%3@)\n", entry];
                break;
            }
            case EXPERIENCE_FIELD:{ //6
                NSArray* keys = [data[@"Experiences"] allKeys];
                entry = keys[arc4random_uniform(EXPERIENCE_SIZE)];
                [tmp appendFormat:@"Must have worked in the field of %@\n",entry];
                break;
            }
            case EXPERIENCE_JOB:{
                NSDictionary* tmpDict=data[@"Experiences"];
                NSArray* keys = [tmpDict allKeys];
                NSArray* key = keys[arc4random_uniform(EXPERIENCE_SIZE)];
                entry = tmpDict[key][arc4random_uniform([tmpDict[key] count])];
                [tmp appendFormat:@"Must have worked as a %@\n",entry];
                break;
            }
            case EXPERIENCE_LOCATION:{
                entry=data[@"Locations"][arc4random_uniform(LOCATION_SIZE)];
                [tmp appendFormat:@"Must have worked at %@\n",entry];
                break;
            }
            case ADDRESS_TYPE:{
                entry=data[@"Address2"][arc4random_uniform(ADDRESS_END_SIZE)];
                [tmp appendFormat:@"Must live on a %@",entry];
                break;
            }
            case EDUCATION_LEVEL:{
                
                break;
            }
            case EXPERIENCE_LENGTH:{
                entry=[NSString stringWithFormat:@"%d",arc4random_uniform(EXPERIENCE_LENGTH_MAX)+1 ];
                [tmp appendFormat:@"Must have %@ yrs of experience\n",entry];
                break;
            }
        }
        [self.rules setValue:entry forKey:[NSString stringWithFormat:@"%@",ruleType]];
    }
    _rulesLabel.string=tmp;
}

@end
