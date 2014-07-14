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

-(void)createRulesWithLevel:(int)level resumeData:(NSDictionary*)data{
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
            }case MINAGE:{ //1
                entry=[NSString stringWithFormat:@"%d",arc4random_uniform(50)+10];
                [tmp appendFormat:@"Must be atleast %@ years old\n",entry];
                break;
            }case NAME:{ //2
                [tmp appendFormat:@""];
                break;
            }case ADDRESS:{ //3
                
                [tmp appendFormat:@"Must live in this zipcode: %5@", entry];
                break;
            }case EDUCATION:{ //4
                NSString* rule=data[@"Schools"][arc4random_uniform(14)];
                [tmp appendFormat:@"Must have gone to %@\n",rule];
                break;
            }case PHONE:{ //5
                [tmp appendFormat:@"Must be from this areacode (%3d)\n", arc4random_uniform(1000)];
                break;
            }case EXPERIENCE:{ //6
                [tmp appendFormat:@""];
                break;
            }
        }
        [self.rules setValue:entry forKey:[NSString stringWithFormat:@"%@",ruleType]];
        _rulesLabel.string=tmp;
    }
}

    @end
