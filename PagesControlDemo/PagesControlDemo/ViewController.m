//
//  ViewController.m
//  PagesControlDemo
//
//  Created by wudi on 16/9/9.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "ViewController.h"
#import "PagesView.h"

static NSInteger pagesNum = 5;

@interface ViewController ()<PagesViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PagesView *view = [PagesView pagesView];
    
    [self.view addSubview:view];
    
    // 设置frame
    view.frame = CGRectMake(20, 40, self.view.bounds.size.width - 40, 150);
    
    // 添加数据
    NSMutableArray *images = [NSMutableArray array];
    
    for (NSInteger i = 0; i < pagesNum; i++) {
        
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"img_0%lu", i]]];
    }
    
    view.timeInterval = 1;
    view.images = images;
    view.delegate = self;
}


#pragma mark - <PagesViewDelegate>
- (void)pagesView:(PagesView *)pagesView didSelectPage:(NSInteger)pageIndex{
    
//    NSLog(@"%s -- %lu", __func__, pageIndex);
}

@end
