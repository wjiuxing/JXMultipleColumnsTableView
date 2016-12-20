//
//  NSMutableAttributedString+JXText.h
//  JXMultipleColumnsTableViewExample
//
//  Created by Jiuxing Wang on 20/12/2016.
//  Copyright © 2016 Heroic. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const JXHighlightTextAttributeName;
UIKIT_EXTERN NSString *const JXTextShadowAttributeName;
UIKIT_EXTERN NSString *const JXTextInnerShadowAttributeName;
UIKIT_EXTERN NSString *const JXTextBackgroundBorderAttributeName;
UIKIT_EXTERN NSString *const JXTextBorderAttributeName;

/**
 Line style in YYText (similar to NSUnderlineStyle).
 */
typedef NS_OPTIONS (NSInteger, JXTextLineStyle) {
    // basic style (bitmask:0xFF)
    JXTextLineStyleNone       = 0x00, ///< (        ) Do not draw a line (Default).
    JXTextLineStyleSingle     = 0x01, ///< (──────) Draw a single line.
    JXTextLineStyleThick      = 0x02, ///< (━━━━━━━) Draw a thick line.
    JXTextLineStyleDouble     = 0x09, ///< (══════) Draw a double line.
    
    // style pattern (bitmask:0xF00)
    JXTextLineStylePatternSolid      = 0x000, ///< (────────) Draw a solid line (Default).
    JXTextLineStylePatternDot        = 0x100, ///< (‑ ‑ ‑ ‑ ‑ ‑) Draw a line of dots.
    JXTextLineStylePatternDash       = 0x200, ///< (— — — —) Draw a line of dashes.
    JXTextLineStylePatternDashDot    = 0x300, ///< (— ‑ — ‑ — ‑) Draw a line of alternating dashes and dots.
    JXTextLineStylePatternDashDotDot = 0x400, ///< (— ‑ ‑ — ‑ ‑) Draw a line of alternating dashes and two dots.
    JXTextLineStylePatternCircleDot  = 0x900, ///< (••••••••••••) Draw a line of small circle dots.
};

/**
 JXTextShadow objects are used by the NSAttributedString class cluster
 as the values for shadow attributes (stored in the attributed string under
 the key named JXTextShadowAttributeName or YYTextInnerShadowAttributeName).
 
 It's similar to `NSShadow`, but offers more options.
 */
@interface JXTextShadow : NSObject <NSCoding, NSCopying>

+ (instancetype)shadowWithColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

@property (nonatomic, strong) UIColor *color; ///< shadow color
@property (nonatomic) CGSize offset;                    ///< shadow offset
@property (nonatomic) CGFloat radius;                   ///< shadow blur radius
@property (nonatomic) CGBlendMode blendMode;            ///< shadow blend mode
@property (nonatomic, strong) JXTextShadow *subShadow;  ///< a sub shadow which will be added above the parent shadow

+ (instancetype)shadowWithNSShadow:(NSShadow *)nsShadow; ///< convert NSShadow to JXTextShadow
- (NSShadow *)nsShadow; ///< convert JXTextShadow to NSShadow
@end


/**
 JXTextBorder objects are used by the NSAttributedString class cluster
 as the values for border attributes (stored in the attributed string under
 the key named YYTextBorderAttributeName or YYTextBackgroundBorderAttributeName).
 
 It can be used to draw a border around a range of text, or draw a background
 to a range of text.
 
 Example:
 ╭──────╮
 │ Text │
 ╰──────╯
 */
@interface JXTextBorder : NSObject <NSCoding, NSCopying>

+ (instancetype)borderWithLineStyle:(JXTextLineStyle)lineStyle lineWidth:(CGFloat)width strokeColor:(UIColor *)color;
+ (instancetype)borderWithFillColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

@property (nonatomic, assign) JXTextLineStyle lineStyle;    ///< border line style
@property (nonatomic, assign) CGFloat strokeWidth;          ///< border line width
@property (nonatomic, strong) UIColor *strokeColor;         ///< border line color
@property (nonatomic, assign) CGLineJoin lineJoin;          ///< border line join
@property (nonatomic, assign) UIEdgeInsets insets;          ///< border insets for text bounds
@property (nonatomic, assign) CGFloat cornerRadius;         ///< border corder radius
@property (nonatomic, strong) JXTextShadow *shadow;         ///< border shadow
@property (nonatomic, strong) UIColor *fillColor;           ///< inner fill color

@end


@class JXTextHighlight;
typedef void(^JXTextAction)(UIView *containerView, JXTextHighlight *highlight, NSRange range, CGRect rect);


@interface JXTextHighlight : NSObject <NSCoding, NSCopying>

/**
 Attributes that you can apply to text in an attributed string when highlight.
 Key:   Same as CoreText Attribute Name.
 Value: Modify attribute value when highlight (NSNull for remove attribute).
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *attributes;

/**
 Creates a highlight object with specified attributes.
 
 @param attributes The attributes which will replace original attributes when highlight,
 If the value is NSNull, it will removed when highlight.
 */
+ (instancetype)highlightWithAttributes:(NSDictionary<NSString *, id> *)attributes;

/**
 Convenience methods to create a default highlight with the specifeid background color.
 
 @param color The background border color.
 */
+ (instancetype)highlightWithBackgroundColor:(UIColor *)color;

// Convenience methods below to set the `attributes`.
- (void)setFont:(UIFont *)font;
- (void)setColor:(UIColor *)color;

/**
 The user information dictionary, default is nil.
 */
@property (nonatomic, copy) NSDictionary *userInfo;

/**
 Tap action when user tap the highlight, default is nil.
 */
@property (nonatomic, copy) JXTextAction tapAction;

@end


@interface NSMutableAttributedString (JXText)

- (void)jx_setTextHighlightRange:(NSRange)range
                           color:(UIColor *)color
                 backgroundColor:(UIColor *)backgroundColor
                       tapAction:(JXTextAction)tapAction;

@end
