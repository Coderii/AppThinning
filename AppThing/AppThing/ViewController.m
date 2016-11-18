//
//  ViewController.m
//  AppThing
//
//  Created by Cheng on 16/8/30.
//  Copyright © 2016年 meitu. All rights reserved.
//

#import "ViewController.h"
#import "MTOneClass.h"

@interface ViewController ()

@property (nonatomic, strong) NSBundleResourceRequest *tagTwoRequest;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MTOneClass *one = [[MTOneClass alloc] init];
    one.myImage = [UIImage imageNamed:@"two"];
    NSLog(@"one image = %@", one.myImage);
    
    // 初始化集合
    NSSet *set = [NSSet setWithObject:@"two"];

    // 根据set初始化NSBundleResourceRequest对象
    self.tagTwoRequest = [[NSBundleResourceRequest alloc] initWithTags:set];
    
    // 获取当前request请求的App路径
    NSLog(@"local path = %@", self.tagTwoRequest.bundle);
    
    // 判断请求的资源是否存在当前设备上
    [self.tagTwoRequest conditionallyBeginAccessingResourcesWithCompletionHandler:^(BOOL resourcesAvailable) {
        if (resourcesAvailable) {
            // 获取加载资源的路径
            NSLog(@"设备存在该资源");
        }
        else {
            NSLog(@"设备不存在该资源");
            
            // 请求加载资源
//            [self loadResources];
        }
    }];
}

// 加载资源
- (void)loadResources {
    __weak typeof(self) weakSelf = self;
    [self.tagTwoRequest beginAccessingResourcesWithCompletionHandler:^(NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            NSLog(@"加载资源出现错误%@", error);
        }
        else {
            NSLog(@"加载资资源成功");
            
            // 结束对tag的访问
            [strongSelf.tagTwoRequest endAccessingResources];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
