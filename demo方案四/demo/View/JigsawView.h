//
//  JigsawViewOne.h
//  demo
//
//  Created by ios_zhu on 16/1/14.
//  Copyright © 2016年 ios_zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JigsawView;

@protocol JigsawViewDelegate <NSObject>

@optional
- (void)jigsawView:(JigsawView *)jigsawView didSelectAtIndex:(NSUInteger)index;

@end


@interface JigsawView : UIView

@property (nonatomic, weak) id<JigsawViewDelegate> delegate;

@property (nonatomic, strong) NSArray *imageFileArray;

@property (nonatomic, readonly) NSMutableArray *imageControlViews;

@property (nonatomic, assign)CGFloat width;

+ (NSArray *)sizeArrayFromDataSourceArray:(NSArray *)dataSourceArray withWidth:(CGFloat)width;

- (void)free;

@end
