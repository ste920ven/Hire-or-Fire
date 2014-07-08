//
//  Resume.h
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Resume : CCNode

@property (nonatomic,strong) NSString *name;
@property (nonatomic) NSInteger birthdate;
@property (nonatomic) NSString *birthmonth;
@property (nonatomic) NSInteger birthyear;
@property (assign) bool male;
@property (nonatomic) NSString * address;

-(id)initWithCurrentDate:(NSDateComponents*)now rootDir:(NSDictionary*)root;

@end
