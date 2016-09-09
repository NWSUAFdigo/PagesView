//
//  PagesView.h
//  3 scrollView图片轮播
//
//  Created by wudi on 16/9/8.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PagesView;
@protocol PagesViewDelegate <NSObject>

@optional
- (void)pagesView:(PagesView *)pagesView didSelectPage:(NSInteger)pageIndex;

@end

@interface PagesView : UIView

+ (instancetype)pagesView;
/** 图片数组 */
@property (nonatomic,strong) NSArray<UIImage *> *images;
/** 页码指示器颜色 */
@property (nonatomic,strong) UIColor *pageIndicatorTintColor;
@property (nonatomic,strong) UIColor *currentPageIndicatorTintColor;
/** 图片轮播时间间隔 */
@property (nonatomic,assign) NSTimeInterval timeInterval; // 图片数组之前设置该属性,否则无效
/** 代理 */
@property (nonatomic,weak) id<PagesViewDelegate> delegate;

@end
