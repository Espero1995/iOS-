//
//  TestSingle.m
//  pThread_Test
//
//  Created by Espero on 2017/8/18.
//  Copyright © 2017年 Espero. All rights reserved.
//

#import "TestSingle.h"

@implementation TestSingle

//单例模式：在整个程序生命周期中只执行一次：全局的数据存储，代码控制【如果不销毁，将一直在内存中】
+(instancetype)instance{
    static dispatch_once_t onceToken;
    static TestSingle  *ins=nil;
    dispatch_once(&onceToken, ^{
        NSLog(@"init the TestSingle");
        ins=[[TestSingle alloc]init];
    });
    return ins;
}

@end
