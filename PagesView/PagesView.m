//
//  PagesView.m
//  3 scrollView图片轮播
//
//  Created by wudi on 16/9/8.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "PagesView.h"

// 定义scrollView中imageView的个数
static NSInteger imageViewsCount = 3;
// 页码指示器默认颜色
#define defaultTintColor [UIColor redColor]
#define defaultCurrentPageColor [UIColor yellowColor]

@interface PagesView ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic,weak) NSTimer *timer;
@property (nonatomic,assign) NSInteger currentOffsetIndex;

@end

@implementation PagesView
@synthesize pageIndicatorTintColor = _pageIndicatorTintColor;
@synthesize currentPageIndicatorTintColor = _currentPageIndicatorTintColor;

+ (instancetype)pagesView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}


- (void)awakeFromNib{
    
    // 初始化设置
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    
    self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;

    // 添加imageView到scrollView上面
    for (NSInteger i = 0; i < imageViewsCount; i++) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        [self.scrollView addSubview:imageV];
        
        // 给中间的imageView添加手势
        if (i == 1) {
            
            imageV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)];
            
            [imageV addGestureRecognizer:tap];
        }
    }
}


- (void)tapImageView{
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(pagesView:didSelectPage:)]) {
        
        [self.delegate pagesView:self didSelectPage:self.pageControl.currentPage];
    }
}


- (void)setImages:(NSArray<UIImage *> *)images{
    
    _images = images;
    
    self.pageControl.numberOfPages = images.count;
    
    [self layoutIfNeeded];
    
    [self setupScrollView];
    
    // 创建定时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(imageChange) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * imageViewsCount, 0);
    
    for (NSInteger i = 0; i < imageViewsCount; i++) {
        
        UIView *view = self.scrollView.subviews[i];
        
        CGFloat x = i * self.scrollView.bounds.size.width;
        CGFloat width = self.scrollView.bounds.size.width;
        CGFloat height = self.scrollView.bounds.size.height;
        
        view.frame = CGRectMake(x, 0, width, height);
    }
}


/** 核心算法: 每次图片滚动结束后,让scrollView的第二个imageView始终显示在屏幕上 */
- (void)setupScrollView{
    
    NSInteger currentPage = self.pageControl.currentPage;
    
    NSInteger lastPage = currentPage - 1;
    NSInteger nextPage = currentPage + 1;
    
    // 判断页码是否越界
    if (lastPage < 0) {
        lastPage = self.images.count - 1;
    }
    if (nextPage >= self.images.count) {
        nextPage = 0;
    }
    
    // 赋值
    UIImageView *lastImageV = self.scrollView.subviews[0];
    UIImageView *currentImageV = self.scrollView.subviews[1];
    UIImageView *nextImageV = self.scrollView.subviews[2];
    
    lastImageV.image = self.images[lastPage];
    currentImageV.image = self.images[currentPage];
    nextImageV.image = self.images[nextPage];
    
    self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width, 0);
}


/** 定时器回调方法 */
- (void)imageChange{
   
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width * 2, 0) animated:YES];
}


#pragma mark - getter&setter
- (UIColor *)pageIndicatorTintColor{
    
    return _pageIndicatorTintColor ? _pageIndicatorTintColor : defaultTintColor;
}


- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    
    _pageIndicatorTintColor = pageIndicatorTintColor;
    
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}


- (UIColor *)currentPageIndicatorTintColor{
    
    return _currentPageIndicatorTintColor ? _currentPageIndicatorTintColor : defaultCurrentPageColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (NSTimeInterval)timeInterval{
    
    return _timeInterval ? _timeInterval : 2;
}


#pragma mark - <UIScrollViewDelegate>
/** 本方法中修改pageControl的currentPage */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index = self.pageControl.currentPage;
    
    CGFloat offsetScale = scrollView.contentOffset.x / scrollView.bounds.size.width - 1;
    
    NSInteger offsetIndex = 0;
    
    if (offsetScale > 0)
        offsetIndex = (NSInteger)(offsetScale + 0.5);
    else if (offsetScale < 0)
        offsetIndex = (NSInteger)(offsetScale - 0.5);
    
    
    if (offsetIndex != self.currentOffsetIndex) {
        
        self.currentOffsetIndex = offsetIndex;
        
        NSInteger currentPage = index + offsetIndex;
        
        // 越界处理
        if (currentPage < 0)
            currentPage = self.images.count - 1;
        else if (currentPage >= self.images.count)
            currentPage = 0;
        
        self.pageControl.currentPage = currentPage;
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.timer.fireDate = [NSDate distantFuture];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self setupScrollView];
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.timeInterval];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self setupScrollView];
}

@end
