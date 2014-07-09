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
@property (nonatomic,strong) NSString *name;
@property (nonatomic) NSInteger birthdate;
@property (nonatomic) NSString *birthmonth;
@property (nonatomic) NSInteger birthyear;
@property (assign) bool male;
@property (nonatomic) NSString * address;
@property (nonatomic) NSInteger totalCount;
@property (nonatomic) NSInteger correctCount;

-(void)setup:(NSDateComponents*)_now rootDir:(NSDictionary*)_root;
-(void)createNew;

@end
