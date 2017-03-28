//
//  JXMultipleColumnsTableView.m
//  JXMultipleColumnsTableViewExample
//
//  Created by Jiuxing Wang on 16/12/20.
//  Copyright © 2016年 Heroic. All rights reserved.
//

#import "JXMultipleColumnsTableView.h"
#import "NSMutableAttributedString+JXText.h"

@interface JXMultipleColumnsTableView ()

@property (nonatomic, strong) NSMutableArray *touchActions;

@end

@implementation JXMultipleColumnsTableView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (nil != _configuration) {
        [self __drawTableInRect:rect];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    [_touchActions enumerateObjectsUsingBlock:^(JXMultipleColumnsTableViewTouchAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!CGRectContainsPoint(action.touchArea, touchPoint)) {
            return;
        }
        
        NULL == action.actionBlock ?: action.actionBlock(self, action.value, action.range, action.touchArea);
    }];
}


#pragma mark -
#pragma mark Getters

- (NSMutableArray *)touchActions
{
    if (nil == _touchActions) {
        _touchActions = [NSMutableArray array];
    }
    
    return _touchActions;
}


#pragma mark -
#pragma mark Setters

- (void)setConfiguration:(JXMultipleColumnsTableViewConfiguration *)configuration
{
    _configuration = configuration;
    
    [self setNeedsDisplay];
}


#pragma mark -
#pragma mark __Private

- (void)__drawTableInRect:(CGRect)rect
{
    [self.touchActions removeAllObjects];
    
    const CGFloat lineWidth = _configuration.lineWidth ?: 1.f;
    UIColor *lineColor = _configuration.lineColor ?: [UIColor blackColor];
    
    const CGFloat leftTopX = _configuration.contentInsets.left;
    const CGFloat leftTopY = _configuration.contentInsets.top;
    
    const CGFloat rightTopX = self.frame.size.width - _configuration.contentInsets.right;
    
    const CGFloat contentWidth = self.frame.size.width - _configuration.contentInsets.left - _configuration.contentInsets.right;
    const CGFloat contentHeight = self.frame.size.height - _configuration.contentInsets.top - _configuration.contentInsets.bottom;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw the outline rect
    [self __drawRect:(CGRect) {leftTopX, leftTopY, contentWidth, contentHeight}
           inContext:context
           lineWidth:lineWidth
           lineColor:lineColor];
    
    CGFloat topY = leftTopY + lineWidth * 0.5;
    
    for (int row = 0; row < _configuration.rowConfigurations.count; ++row) {
        JXMultipleColumnsTableViewRowConfiguration *rowConfiguration = _configuration.rowConfigurations[row];
        
        CGFloat leftX = leftTopX + lineWidth * 0.5;
        CGFloat columnHeight = (_configuration.sameHeightRatio
                                ? (contentHeight - (_configuration.rowConfigurations.count) * lineWidth) / _configuration.rowConfigurations.count
                                : (contentHeight - (_configuration.rowConfigurations.count) * lineWidth) * rowConfiguration.heightRatio);
        
        for (int column = 0; column < rowConfiguration.columnConfigurations.count; ++column) {
            JXMultipleColumnsTableViewColumnConfiguration *columnConfiguration = rowConfiguration.columnConfigurations[column];
            
            CGFloat columnWidth = (rowConfiguration.sameWidthForColumns
                                   ? (contentWidth - (rowConfiguration.columnConfigurations.count) * lineWidth) / rowConfiguration.columnConfigurations.count
                                   : (contentWidth - (rowConfiguration.columnConfigurations.count) * lineWidth) * columnConfiguration.widthRatio);
            
            CGRect columnRect = (CGRect) {.origin.x = leftX, .origin.y = topY, .size.width = columnWidth, .size.height = columnHeight};
            
            if (nil != columnConfiguration.backgroundColor) {
                [columnConfiguration.backgroundColor setFill];
                CGContextFillRect(context, columnRect);
            }
            
            if (NULL != columnConfiguration.contentDrawingBlock) {
                JXMultipleColumnsTableViewTouchAction *action = columnConfiguration.contentDrawingBlock(context, columnRect);
                
                if (nil != action) {
                    [self.touchActions addObject:action];
                }
            } else {
                if (nil != columnConfiguration.attributedText) {
                    NSAttributedString *attributedText = columnConfiguration.attributedText;
                    
                    CGSize maxTextSize = columnRect.size;
                    CGSize textSize = [attributedText boundingRectWithSize:maxTextSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                    
                    CGRect textFrame = (CGRect) {
                        .origin.x = columnRect.origin.x + (columnRect.size.width - textSize.width) / 2.f,
                        .origin.y = columnRect.origin.y + (columnRect.size.height - textSize.height) / 2.f,
                        .size = textSize
                    };
                    [attributedText drawInRect:textFrame];
                    
                    NSLayoutManager *textLayout = [[NSLayoutManager alloc] init];
                    
                    // Create a text container
                    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:textSize];
                    textContainer.lineFragmentPadding = 0.f;
                    
                    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedText];
                    
                    // Add text container to text layout manager
                    [textLayout addTextContainer:textContainer];
                    
                    // Add layout manager to text storage object
                    [textStorage addLayoutManager:textLayout];
                    
                    [attributedText enumerateAttribute:JXHighlightTextAttributeName inRange:(NSRange) {0, attributedText.length} options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                        if (![value isKindOfClass:[JXTextHighlight class]]) {
                            return;
                        }
                        
                        JXTextHighlight *highLight = (JXTextHighlight *)(value);
                        if (NULL == highLight.tapAction) {
                            return;
                        }
                        
                        CGRect touchArea = [textLayout boundingRectForGlyphRange:range inTextContainer:textContainer];
                        touchArea.origin.x += textFrame.origin.x;
                        touchArea.origin.y += textFrame.origin.y;
                        
                        JXMultipleColumnsTableViewTouchAction *action = [JXMultipleColumnsTableViewTouchAction touchActionWithArea:touchArea actionBlock:highLight.tapAction];
                        action.value = value;
                        action.range = range;
                        
                        [self.touchActions addObject:action];
                        
                        NSLog(@"columnRect: %@, touchAreaInTalbe: %@", NSStringFromCGRect(columnRect), NSStringFromCGRect(touchArea));
                    }];
                }
            }
            
            // Draw the vertical line on the RHS of the column.
            if (columnConfiguration.showRightSideSplitLine && column + 1 < rowConfiguration.columnConfigurations.count) {
                UIColor *splitLineColor = columnConfiguration.rightSideSplitLineColor ?: lineColor;
                
                [self __drawLineInContext:context
                               startPoint:(CGPoint) {.x = leftX + columnWidth + lineWidth * 0.5f, .y = topY}
                                 endPoint:(CGPoint) {.x = leftX + columnWidth + lineWidth * 0.5f, .y = topY + columnHeight}
                                lineWidth:lineWidth
                                lineColor:splitLineColor];
            }
            
            leftX += columnWidth + lineWidth;
        }
        
        topY += columnHeight + lineWidth * 0.5f;
        
        if (row + 1 < _configuration.rowConfigurations.count) {
            UIColor *color = rowConfiguration.bottomSplitLineColor ?: lineColor;
            [self __drawLineInContext:context
                           startPoint:(CGPoint) {leftTopX, topY}
                             endPoint:(CGPoint) {rightTopX, topY}
                            lineWidth:lineWidth
                            lineColor:color];
        }
        
        topY += lineWidth * 0.5f;
    }
}

- (void)__drawRect:(CGRect)rect
         inContext:(CGContextRef)context
         lineWidth:(CGFloat)lineWidth
         lineColor:(UIColor *)lineColor
{
    CGContextSaveGState(context);
    {
        [lineColor setStroke];
        CGContextSetLineWidth(context, lineWidth);
        
        CGContextStrokeRect(context, rect);
        
        CGContextDrawPath(context, kCGPathStroke);
    }
    CGContextRestoreGState(context);
}

- (void)__drawLineInContext:(CGContextRef)context
                 startPoint:(CGPoint)start
                   endPoint:(CGPoint)end
                  lineWidth:(CGFloat)lineWidth
                  lineColor:(UIColor *)lineColor
{
    CGContextSaveGState(context);
    {
        [lineColor setStroke];
        CGContextSetLineWidth(context, lineWidth);
        
        CGContextMoveToPoint(context, start.x, start.y);
        CGContextAddLineToPoint(context, end.x, end.y);
        
        CGContextDrawPath(context, kCGPathStroke);
    }
    CGContextRestoreGState(context);
}

@end
