//
//  CustomOperation.m
//  pThread_Test
//
//  Created by Espero on 2017/8/18.
//  Copyright © 2017年 Espero. All rights reserved.
//

#import "CustomOperation.h"

@interface CustomOperation ()

@property(nonatomic,copy)NSString *operName;

@property BOOL over;

@end

@implementation CustomOperation

-(instancetype)initWithName:(NSString *)name{
    if (self=[super init]) {
        self.operName=name;
    }
    return self;
}

-(void)main{
//    for (int i=0; i<3; i++) {
//        NSLog(@"%@  %d",self.operName,i);
//        [NSThread sleepForTimeInterval:1];
//    }

        //模拟网络请求
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1];
        if (self.cancelled) {
            return ;
        }
        self.over=YES;
        NSLog(@"%@",self.operName);
    });

    while (!self.over&&!self.cancelled) {
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
}

@end
