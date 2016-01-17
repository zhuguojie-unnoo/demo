//
//  MapTableViewCell.m
//  demo
//
//  Created by ios_zhu on 16/1/13.
//  Copyright © 2016年 ios_zhu. All rights reserved.
//

#import "MapTableViewCell.h"
#import "JigsawView.h"


@interface MapTableViewCell()<JigsawViewDelegate>

@end


@implementation MapTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _jigsawView = [[JigsawView alloc] init];
        _jigsawView.delegate = self;
        [self.contentView addSubview:_jigsawView];
    }
    
    return self;
}

-(void)jigsawView:(JigsawView *)jigsawView didSelectAtIndex:(NSUInteger)index
{
    NSLog(@"%zi",index);
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _jigsawView.frame = self.bounds;
}

@end
