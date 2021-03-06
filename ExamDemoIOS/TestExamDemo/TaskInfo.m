//
//  TaskInfo.m
//  TestExamDemo
//
//  Created by George She on 2018/6/15.
//  Copyright © 2018年 cmcc. All rights reserved.
//

#import "TaskInfo.h"

@implementation TaskInfo

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, nodeId: %d, taskId: %d", NSStringFromClass([self class]), self, self.nodeId, self.taskId];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.taskId = 0;
        self.nodeId = 0;
        self.consumption = 0;
    }
    return self;
}
@end
