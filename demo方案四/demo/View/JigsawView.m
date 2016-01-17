//
//  JigsawViewOne.m
//  demo
//
//  Created by ios_zhu on 16/1/14.
//  Copyright © 2016年 ios_zhu. All rights reserved.
//


#import "JigsawView.h"
#import "UIImageView+WebCache.h"


#define TAG_IMAGEVIEW   1001
#define SPLITLINE_WIDTH   1
#define IMAGE_URL   @"imageUrl"


@interface JigsawView ()
{
    BOOL _isInited;
}
@end


@implementation JigsawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _imageControlViews = [NSMutableArray array];
        [self creatImageViews];
        _isInited = YES;
    }
    
    return self;
}

- (void)creatImageViews
{
    for (NSInteger index = 0; index < 9; index++) {
        
        UIControl *imageControl = [[UIControl alloc] init];
        imageControl.hidden = YES;
        [imageControl addTarget:self action:@selector(imageControlClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = TAG_IMAGEVIEW;
        
        [imageControl addSubview:imageView];
        [self addSubview:imageControl];
        [_imageControlViews addObject:imageControl];
    }
}

- (void)setImageFileArray:(NSArray *)imageFileArray
{
    if (imageFileArray.count > 9) {
        _imageFileArray = [imageFileArray subarrayWithRange:NSMakeRange(0, 9)];
    }
    else{
        _imageFileArray = imageFileArray;
    }
    
    _isInited = NO;
    
    [self setNeedsLayout];
}

- (void)free
{
    _isInited = NO;
    _imageFileArray = nil;
    _width = 0;
    
    for (UIControl *imageControl in _imageControlViews) {
        UIImageView *imageView = (UIImageView *)[imageControl viewWithTag:TAG_IMAGEVIEW];
        imageView.image = nil;
        [imageView sd_cancelCurrentImageLoad];
        imageControl.frame = CGRectZero;
        imageControl.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_isInited || (_width == 0)) {
        return;
    }
    
    _isInited = YES;
    //  以下代码为计算imageView的布局
    NSInteger count = _imageFileArray.count;
    NSArray *imagesFrameArray = [[self class] layoutSubviewsCustoms:count withItemWidth:_width];
    
    for (NSInteger i = 0; i < count; i++) {
        NSDictionary *imageDict = _imageFileArray[i];
        
        UIControl *imageControl = _imageControlViews[i];
        UIImageView *imageView = [imageControl viewWithTag:TAG_IMAGEVIEW];
        
        imageControl.frame = [imagesFrameArray[i] CGRectValue];
        imageView.frame = imageControl.bounds;
        
        imageControl.hidden = NO;
        
        NSString *imageUrl = [imageDict objectForKey:IMAGE_URL];
        if ( imageUrl.length > 0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        }
    }
}


#pragma mark - 计算 frame，返回装有 frame 的数组

+ (NSArray *)layoutSubviewsCustoms:(NSInteger )count withItemWidth:(CGFloat)width
{
    if (count == 0) {
        return nil;
    }
    
    CGFloat originY = 0;
    NSMutableArray *array = [NSMutableArray array];
    
    switch (count) {
        case 1:{
            originY = [JigsawView layoutOneStyleView:array withOriginY:0 withItemWidth:width];
            break;
        }
            
        case 2: {
            originY = [JigsawView layoutTwoStyleView:array withOriginY:0 withItemWidth:width];
            break;
        }
            
        case 3: {
            originY = [JigsawView layoutNoEqualStyleView:array withOriginY:0 withItemWidth:width];
            break;
        }
            
        case 4: {
            originY = [JigsawView layoutOneStyleView:array withOriginY:0 withItemWidth:width];
            originY = [JigsawView layoutThreeEqualStyleView:array withOriginY:originY + SPLITLINE_WIDTH withItemWidth:width];
            break;
            
        }
            
        case 5: {
            originY = [JigsawView layoutTwoStyleView:array withOriginY:0 withItemWidth:width];
            originY = [JigsawView layoutThreeEqualStyleView:array withOriginY:originY + SPLITLINE_WIDTH withItemWidth:width];
            break;
        }
            
        case 6: {
            originY = [JigsawView layoutNoEqualStyleView:array withOriginY:0 withItemWidth:width];
            originY = [JigsawView layoutThreeEqualStyleView:array  withOriginY:originY + SPLITLINE_WIDTH withItemWidth:width];
            break;
        }
            
        case 7: {
            originY = [JigsawView layoutOneStyleView:array withOriginY:0 withItemWidth:width];
            originY = [JigsawView layoutThreeEqualStyleView:array withOriginY:originY + SPLITLINE_WIDTH withItemWidth:width];
            originY = [JigsawView layoutThreeEqualStyleView:array withOriginY: originY + SPLITLINE_WIDTH withItemWidth:width];
            break;
        }
            
        case 8: {
            originY = [JigsawView layoutTwoStyleView:array withOriginY:0 withItemWidth:width];
            originY = [JigsawView layoutThreeEqualStyleView:array withOriginY:originY + SPLITLINE_WIDTH withItemWidth:width];
            originY = [JigsawView layoutThreeEqualStyleView:array withOriginY: originY + SPLITLINE_WIDTH withItemWidth:width];
            break;
        }
            
        case 9: {
            originY = [JigsawView layoutNoEqualStyleView:array withOriginY:0 withItemWidth:width];
            originY = [JigsawView layoutThreeEqualStyleView:array withOriginY:originY + SPLITLINE_WIDTH withItemWidth:width];
            originY = [JigsawView layoutThreeEqualStyleView:array withOriginY:originY + SPLITLINE_WIDTH withItemWidth:width];
            break;
        }
            
        default: {
            break;
        }
    }
    
    NSArray *imageFrameArray = [NSArray arrayWithArray:array];
    
    return imageFrameArray;
}

+ (CGFloat)layoutOneStyleView:(NSMutableArray *)array withOriginY:(CGFloat)originY withItemWidth:(CGFloat)width
{
    CGFloat baseWidth = width;
    CGFloat threeWidth = (baseWidth - SPLITLINE_WIDTH * 2) / 3.0;
    CGFloat threeBigWidth = baseWidth - threeWidth - SPLITLINE_WIDTH;
    
    CGRect frame = CGRectMake(0, originY, baseWidth, threeBigWidth);
    [array addObject:[NSValue valueWithCGRect:frame]];
    
    return originY + threeBigWidth;
}

+ (CGFloat)layoutTwoStyleView:(NSMutableArray *)array withOriginY:(CGFloat)originY withItemWidth:(CGFloat)width
{
    CGFloat baseWidth = width;
    CGFloat twoWidth = (baseWidth - SPLITLINE_WIDTH) * 0.5;
    CGRect frame = CGRectMake(0, originY, twoWidth, twoWidth);
    CGRect SecondFrame = CGRectMake(twoWidth + SPLITLINE_WIDTH, originY, twoWidth, twoWidth);
    
    [array addObject:[NSValue valueWithCGRect:frame]];
    [array addObject:[NSValue valueWithCGRect:SecondFrame]];
    
    return originY + twoWidth;
}

+ (CGFloat)layoutThreeEqualStyleView:(NSMutableArray *)array withOriginY:(CGFloat)originY withItemWidth:(CGFloat)width
{
    CGFloat baseWidth = width;
    CGFloat threeWidth = (baseWidth - SPLITLINE_WIDTH*2) / 3.0;
    
    CGRect frame = CGRectMake(0, originY, threeWidth, threeWidth);
    CGRect secondframe = CGRectMake(threeWidth + SPLITLINE_WIDTH, originY, threeWidth, threeWidth);
    CGRect threeFrame = CGRectMake((threeWidth + SPLITLINE_WIDTH) * 2, originY, threeWidth, threeWidth);
    
    [array addObject:[NSValue valueWithCGRect:frame]];
    [array addObject:[NSValue valueWithCGRect:secondframe]];
    [array addObject:[NSValue valueWithCGRect:threeFrame]];
    
    return originY + threeWidth;
}

+ (CGFloat)layoutNoEqualStyleView:(NSMutableArray *)array withOriginY:(CGFloat)originY withItemWidth:(CGFloat)width
{
    CGFloat baseWidth = width;
    CGFloat threeWidth = (baseWidth - SPLITLINE_WIDTH * 2) / 3.0;
    CGFloat threeBigWidth = baseWidth - threeWidth - SPLITLINE_WIDTH;
    
    CGRect frame = CGRectMake(0, originY, threeBigWidth, threeBigWidth);
    CGRect secondeFrame = CGRectMake(threeBigWidth + SPLITLINE_WIDTH, originY, threeWidth, threeWidth);
    CGRect threeFrame = CGRectMake(threeBigWidth + SPLITLINE_WIDTH, threeWidth + SPLITLINE_WIDTH + originY, threeWidth, threeWidth);
    
    [array addObject:[NSValue valueWithCGRect:frame]];
    [array addObject:[NSValue valueWithCGRect:secondeFrame]];
    [array addObject:[NSValue valueWithCGRect:threeFrame]];
    
    return threeBigWidth;
}

+ (NSArray *)sizeArrayFromDataSourceArray:(NSArray *)dataSourceArray withWidth:(CGFloat)width
{
    NSMutableArray *imageHeightArray = [NSMutableArray array];
    
    for (NSArray *imageArray in dataSourceArray) {
        CGSize itemSize = [JigsawView itemSizeFromImageNumber:imageArray.count withItemWidth:width];
        [imageHeightArray addObject:NSStringFromCGSize(itemSize)];
    }
    
    return imageHeightArray;
}

+ (CGSize)itemSizeFromImageNumber:(NSInteger)number withItemWidth:(CGFloat)width
{
    CGFloat baseWidth = width;
    CGFloat splitLineWidth = 1;
    CGFloat twoWidth = (baseWidth - splitLineWidth) * 0.5;
    CGFloat threeWidth = (baseWidth - splitLineWidth * 2) /3.0;
    CGFloat threeBigWidth = baseWidth - threeWidth - splitLineWidth;
    
    CGFloat height;
    switch (number) {
        case 1: {
            height = threeBigWidth;
            break;
        }
            
        case 2: {
            height = twoWidth;
            break;
        }
            
        case 3: {
            height = threeBigWidth;
            break;
        }
            
        case 4: {
            height = threeBigWidth + threeWidth + splitLineWidth;
            break;
        }
            
        case 5: {
            height = twoWidth + threeWidth + splitLineWidth;
            break;
        }
            
        case 6: {
            height = threeBigWidth + threeWidth + splitLineWidth;
            break;
        }
            
        case 7: {
            height = threeBigWidth + threeWidth * 2 + splitLineWidth * 2;
            break;
        }
            
        case 8: {
            height = twoWidth + threeWidth * 2 + splitLineWidth * 2;
            break;
        }
            
        case 9: {
            height = threeBigWidth + threeWidth * 2 + splitLineWidth * 2;
            break;
        }
            
        default: {
            height = 0;
        }
    }
    
    CGSize size = CGSizeMake(width, height);
    return size;
}

- (void)imageControlClicked:(UIControl *)sender
{
    NSUInteger index = [_imageControlViews indexOfObject:sender];
    if (index == NSNotFound) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(jigsawView:didSelectAtIndex:)]) {
        [_delegate jigsawView:self didSelectAtIndex:index];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return [super hitTest:point withEvent:event];
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    return YES;
//}

@end
