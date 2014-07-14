//
//  Resume.h
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Resume : CCNode


@property (assign) bool correct;
@property (nonatomic) NSInteger passedCount;
@property (nonatomic) NSInteger totalCount;
@property (nonatomic) NSInteger correctCount;

-(void)setup:(NSDateComponents*)_now rootDir:(NSDictionary*)_root rules:(CCNode *)_rules;
-(void)createNew;

@end
