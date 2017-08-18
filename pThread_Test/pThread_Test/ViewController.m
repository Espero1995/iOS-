//
//  ViewController.m
//  pThread_Test
//
//  Created by Espero on 2017/8/17.
//  Copyright © 2017年 Espero. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
#import "TicketManager.h"
#import "TestSingle.h"
#import "Person.h"

#import "CustomOperation.h"

@interface ViewController ()


@property(nonatomic,strong)NSOperationQueue *operQueue;

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(150, 100, 100, 30);
    [btn setTitle:@"pThread" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor redColor];
    [btn addTarget:self action:@selector(clickPThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];


    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(150, 150, 100, 30);
    [btn setTitle:@"nsThread" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor redColor];
    [btn addTarget:self action:@selector(clickNSThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    //练习线程同步
//    TicketManager *manager=[[TicketManager alloc]init];
//    [manager startToSale];
    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(150, 200, 100, 30);
    [btn setTitle:@"GCD" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor redColor];
    [btn addTarget:self action:@selector(clickGCD) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //GCD单例
    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(150, 250, 100, 30);
    [btn setTitle:@"单例" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor redColor];
    [btn addTarget:self action:@selector(clickSingle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //GCD延迟执行
    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(150, 300, 100, 30);
    [btn setTitle:@"延迟执行" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor redColor];
    [btn addTarget:self action:@selector(clickTime) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    //NSOperation
    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(125, 350, 150, 30);
    [btn setTitle:@"NSOperation" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor redColor];
    [btn addTarget:self action:@selector(clickNSOperation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

#pragma mark - pThread Test
-(void)clickPThread{
    NSLog(@"我在主线程中执行！！！");
    pthread_t pthread;
    pthread_create(&pthread, NULL,run, NULL);
}

void *run(void *data){
    NSLog(@"我在子线程中执行！！！");
    for (int i=0; i<10; i++) {
        NSLog(@"%d",i);
        sleep(1);//子线程睡眠1s
    }
    return NULL;
}

#pragma mark - NSThread Test
-(void)clickNSThread{
    NSLog(@"主线程执行——NSThread！");
//    NSLog(@"主线程：：=========%@",[NSThread currentThread]);
    
    //1.通过alloc init方式创建并执行线程
    NSThread *thread1=[[NSThread alloc]initWithTarget:self selector:@selector(runThread1) object:nil];
    [thread1 setName:@"Name_Thread1"];//线程名
    [thread1 setThreadPriority:0.2];//给线程设置优先级
    [thread1 start];
    
    NSThread *thread2=[[NSThread alloc]initWithTarget:self selector:@selector(runThread1) object:nil];
    [thread2 setName:@"Name_Thread2"];
    [thread2 setThreadPriority:0.7];//给线程设置优先级
    if (![thread2 isMainThread]) {
        NSLog(@"2不是主线程");
    }
    [thread2 start];
    
    //2.通过detachNewThreadSelector方式创建并执行线程
//    [NSThread detachNewThreadSelector:@selector(runThread1) toTarget:self withObject:nil];

    //3.通过performSelectorInBackground方式创建线程
//    [self performSelectorInBackground:@selector(runThread1) withObject:nil];
}

-(void)runThread1{
     NSLog(@"%@,子线程执行——NSThread！",[NSThread currentThread].name);
//        NSLog(@"子线程：：=========%@",[NSThread currentThread]);
    for (int i=0; i<10; i++) {
        NSLog(@"%d",i);
        sleep(1);
        if (i==9) {
            [self performSelectorOnMainThread:@selector(runMainThread) withObject:nil waitUntilDone:YES]; 
        }
    }
}

-(void)runMainThread{
    NSLog(@"回到主线程执行");
}


#pragma mark - GCD Test
-(void)clickGCD{
    NSLog(@"执行GCD");
    //1、笼统的介绍下GCD
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{//进入子线程
//        NSLog(@"start task 1");
//        //执行耗时任务
//        [NSThread sleepForTimeInterval:2];
//        dispatch_async(dispatch_get_main_queue(), ^{//回到主线程
//                //回到主线程刷新UI
//            NSLog(@"刷新UI");
//        });
//    });
    
    //2、dispatch_get_global_queue(参数一【优先级】, 参数二)介绍
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        NSLog(@"start task 1");
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"end task 1");
//    });
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        NSLog(@"start task 2");
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"end task 2");
//    });
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"start task 3");
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"end task 3");
//    });

    //3、对象;开辟了一个线程，这三个任务按顺序执行（第一个参数是名称）
//    dispatch_queue_t queue=dispatch_queue_create("com.test.gcd.queue", DISPATCH_QUEUE_SERIAL);
//
//    dispatch_async(queue, ^{
//        NSLog(@"start task 1");
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"end task 1");
//    });
//    
//    dispatch_async(queue, ^{
//        NSLog(@"start task 2");
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"end task 2");
//    });
//    
//    dispatch_async(queue, ^{
//        NSLog(@"start task 3");
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"end task 3");
//    });
    
   // 4、GCD_group
    dispatch_queue_t queue=dispatch_queue_create("com.test.gcd.group", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group=dispatch_group_create();

    
    dispatch_group_enter(group);
    [self sendRequest1:^{
        NSLog(@"request1 done");
        dispatch_group_leave(group);//与enter成对出现
    }];
    
    dispatch_group_enter(group);
    [self sendRequest2:^{
        NSLog(@"request2 done");
        dispatch_group_leave(group);//与enter成对出现
    }];
    
    
    //三个参数：1：组，2：队列，3：执行代码块
//    dispatch_group_async(group, queue, ^{
//        [self sendRequest1:^{
//            NSLog(@"request1 done");
//        }];
//
//    });
//    
//    dispatch_group_async(group, queue, ^{
//        [self sendRequest2:^{
//            NSLog(@"request2 done");
//        }];
//        
//    });
    
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"start task 3");
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"end task 3");
//        
//    });
    
    //发送通知全部已经完成了
    dispatch_group_notify(group, queue, ^{
        NSLog(@"All tasks are over!");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程刷新UI ");
        });
    });
}


-(void)sendRequest1:(void(^)())block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start task 1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 1");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    });
}


-(void)sendRequest2:(void(^)())block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start task 2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 2");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    });
}


#pragma mark -Single
-(void)clickSingle{
    TestSingle *single=[TestSingle instance];
    NSLog(@"Single:%@",single);
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSLog(@"excute only one");
//    });


}


#pragma mark -Time Test
-(void)clickTime{
    NSLog(@"----begin------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"delay excute");
    });
}


#pragma mark -NSOperation Test
-(void)clickNSOperation{
    NSLog(@"main thread");
    
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSInvocationOperation *invocationOper=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(invocationAction) object:nil];
//        [invocationOper start];
//        NSLog(@"end");
//    });
//    
//    
//    NSBlockOperation *blockOper=[NSBlockOperation blockOperationWithBlock:^{
//        for (int i=0; i<3; i++) {
//            NSLog(@"invocation:%d",i);
//            [NSThread sleepForTimeInterval:1];
//        }
//    }];

    
    
    
    //判断NSOperationQueue是否为空，是——创建queue
    if (!self.operQueue) {
        self.operQueue=[[NSOperationQueue alloc]init];
    }
    
    [self.operQueue setMaxConcurrentOperationCount:4];//设置最大并发数。
    
    
    CustomOperation *customOperA=[[CustomOperation alloc]initWithName:@"OperA"];
    CustomOperation *customOperB=[[CustomOperation alloc]initWithName:@"OperB"];
    CustomOperation *customOperC=[[CustomOperation alloc]initWithName:@"OperC"];
    CustomOperation *customOperD=[[CustomOperation alloc]initWithName:@"OperD"];
   
    //操作依赖问题（不能循环，否则会死锁）
    [customOperD addDependency:customOperA];
    [customOperA addDependency:customOperC];
    [customOperC addDependency:customOperB];
    
    //添加到operQueue
    [self.operQueue addOperation:customOperA];
     [self.operQueue addOperation:customOperB];
    [self.operQueue addOperation:customOperC];
    [self.operQueue addOperation:customOperD];
    
    
//    [self.operQueue addOperation:blockOper];
//    [blockOper start];
       NSLog(@"end");
}

-(void)invocationAction{
    for (int i=0; i<3; i++) {
        NSLog(@"invocation:%d",i);
        [NSThread sleepForTimeInterval:1];
    }
}


@end
