//
//  JXMultipleColumnsTableViewConfiguration.m
//  JXMultipleColumnsTableViewExample
//
//  Created by Miao Yu on 16/12/20.
//  Copyright © 2016年 Heroic. All rights reserved.
//

#import "JXMultipleColumnsTableViewConfiguration.h"

@implementation JXMultipleColumnsTableViewTouchAction

+ (instancetype)touchActionWithArea:(CGRect)touchArea
                        actionBlock:(void (^)(UIView * _Nonnull containerView, id _Nonnull text, NSRange range, CGRect rect))actionBlock;
{
    JXMultipleColumnsTableViewTouchAction *action = [[JXMultipleColumnsTableViewTouchAction alloc] init];
    action.touchArea = touchArea;
    action.actionBlock = actionBlock;
    
    return action;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p touchArea=%@, actionBlock=%@>", NSStringFromClass([self class]), self, NSStringFromCGRect(_touchArea), _actionBlock];
}

@end


@implementation JXMultipleColumnsTableViewRowConfiguration

- (instancetype)initWithColumnConfigurations:(NSArray<JXMultipleColumnsTableViewColumnConfiguration *> *)columnConfigurations;
{
    self = [super init];
    if (self) {
        _columnConfigurations = [columnConfigurations copy];
    }
    return self;
}

@end


@implementation JXMultipleColumnsTableViewColumnConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showRightSideSplitLine = YES;
    }
    return self;
}

+ (instancetype)columnWithWidthRatio:(CGFloat)widthRatio drawingBlock:(JXMultipleColumnsTableViewTouchAction *(^)(CGContextRef context, CGRect contentRect))drawingBlock;
{
    JXMultipleColumnsTableViewColumnConfiguration *config = [[JXMultipleColumnsTableViewColumnConfiguration alloc] init];
    config.widthRatio = widthRatio;
    config.contentDrawingBlock = drawingBlock;
    
    return config;
}

+ (instancetype)columnWithWidthRatio:(CGFloat)widthRatio
                      attributedText:(NSAttributedString *)attributedText;
{
    JXMultipleColumnsTableViewColumnConfiguration *config = [[JXMultipleColumnsTableViewColumnConfiguration alloc] init];
    config.widthRatio = widthRatio;
    config.attributedText = attributedText;
    
    return config;
}

@end


@implementation JXMultipleColumnsTableViewConfiguration

- (instancetype)initWithRowConfigurations:(NSArray<JXMultipleColumnsTableViewRowConfiguration *> *)rowConfigurations;
{
    self = [super init];
    if (self) {
        _rowConfigurations = [_rowConfigurations copy];
        _lineWidth = 1.f;
        _lineColor = [UIColor blackColor];
    }
    return self;
}

@end
