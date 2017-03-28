//
//  JXMultipleColumnsTableViewConfiguration.h
//  JXMultipleColumnsTableViewExample
//
//  Created by Jiuxing Wang on 16/12/20.
//  Copyright © 2016年 Heroic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JXMultipleColumnsTableViewTouchAction : NSObject

@property (nonatomic, assign) CGRect touchArea;
@property (nonatomic, copy) void (^actionBlock)(UIView *containerView, id text, NSRange range, CGRect rect);
@property (nonatomic, strong) id value;
@property (nonatomic, assign) NSRange range;

+ (instancetype)touchActionWithArea:(CGRect)touchArea
                        actionBlock:(void (^)(UIView * containerView, id text, NSRange range, CGRect rect))actionBlock;

@end


@class JXMultipleColumnsTableViewColumnConfiguration;

@interface JXMultipleColumnsTableViewRowConfiguration : NSObject

@property (nonatomic, assign) CGFloat heightRatio;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIColor *bottomSplitLineColor;

@property (nonatomic, assign) BOOL sameWidthForColumns;

@property (nonatomic, copy) NSArray<JXMultipleColumnsTableViewColumnConfiguration *> *columnConfigurations;

- (instancetype)initWithColumnConfigurations:(NSArray<JXMultipleColumnsTableViewColumnConfiguration *> *)columnConfigurations;

@end


@interface JXMultipleColumnsTableViewColumnConfiguration : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) CGFloat widthRatio;

@property (nonatomic, copy) JXMultipleColumnsTableViewTouchAction *(^contentDrawingBlock)(CGContextRef context, CGRect contentRect);

@property (nonatomic, copy) NSAttributedString *attributedText;

/**
 Default is YES.
 */
@property (nonatomic, assign) BOOL showRightSideSplitLine;
@property (nonatomic, strong) UIColor *rightSideSplitLineColor;

+ (instancetype)columnWithWidthRatio:(CGFloat)widthRatio
                        drawingBlock:(JXMultipleColumnsTableViewTouchAction *(^)(CGContextRef context, CGRect contentRect))drawingBlock;

+ (instancetype)columnWithWidthRatio:(CGFloat)widthRatio
                      attributedText:(NSAttributedString *)attributedText;

@end


@interface JXMultipleColumnsTableViewConfiguration : NSObject

@property (nonatomic, assign) UIEdgeInsets contentInsets;

/**
 Default is black color.
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 Default is 1.f.
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 Default is NO.
 */
@property (nonatomic, assign) BOOL sameHeightRatio;

@property (nonatomic, copy) NSArray<JXMultipleColumnsTableViewRowConfiguration *> *rowConfigurations;

- (instancetype)initWithRowConfigurations:(NSArray<JXMultipleColumnsTableViewRowConfiguration *> *)rowConfigurations;

@end
