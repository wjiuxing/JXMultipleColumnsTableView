//
//  NSMutableAttributedString+JXText.m
//  JXMultipleColumnsTableViewExample
//
//  Created by Jiuxing Wang on 20/12/2016.
//  Copyright © 2016 Heroic. All rights reserved.
//

#import "NSMutableAttributedString+JXText.h"
#import <CoreText/CoreText.h>


NSString *const JXHighlightTextAttributeName = @"JXHighlightText";
NSString *const JXTextShadowAttributeName = @"JXTextShadow";
NSString *const JXTextInnerShadowAttributeName = @"JXTextInnerShadow";
NSString *const JXTextBackgroundBorderAttributeName = @"JXTextBackgroundBorder";
NSString *const JXTextBorderAttributeName = @"JXTextBorder";


/**
 Wrapper for CTRunDelegateRef.
 
 Example:
 
 JXTextRunDelegate *delegate = [JXTextRunDelegate new];
 delegate.ascent = 20;
 delegate.descent = 4;
 delegate.width = 20;
 CTRunDelegateRef ctRunDelegate = delegate.CTRunDelegate;
 if (ctRunDelegate) {
 /// add to attributed string
 CFRelease(ctRunDelegate);
 }
 
 */
@interface JXTextRunDelegate : NSObject <NSCopying, NSCoding>

/**
 Creates and returns the CTRunDelegate.
 
 @discussion You need call CFRelease() after used.
 The CTRunDelegateRef has a strong reference to this JXTextRunDelegate object.
 In CoreText, use CTRunDelegateGetRefCon() to get this JXTextRunDelegate object.
 
 @return The CTRunDelegate object.
 */
- (nullable CTRunDelegateRef)CTRunDelegate CF_RETURNS_RETAINED;

/**
 Additional information about the the run delegate.
 */
@property (nullable, nonatomic, strong) NSDictionary *userInfo;

/**
 The typographic ascent of glyphs in the run.
 */
@property (nonatomic) CGFloat ascent;

/**
 The typographic descent of glyphs in the run.
 */
@property (nonatomic) CGFloat descent;

/**
 The typographic width of glyphs in the run.
 */
@property (nonatomic) CGFloat width;

@end


static void DeallocCallback(void *ref)
{
    JXTextRunDelegate *self = (__bridge_transfer JXTextRunDelegate *)(ref);
    self = nil; // release
}

static CGFloat GetAscentCallback(void *ref)
{
    JXTextRunDelegate *self = (__bridge JXTextRunDelegate *)(ref);
    return self.ascent;
}

static CGFloat GetDecentCallback(void *ref)
{
    JXTextRunDelegate *self = (__bridge JXTextRunDelegate *)(ref);
    return self.descent;
}

static CGFloat GetWidthCallback(void *ref)
{
    JXTextRunDelegate *self = (__bridge JXTextRunDelegate *)(ref);
    return self.width;
}



@implementation JXTextRunDelegate

- (CTRunDelegateRef)CTRunDelegate CF_RETURNS_RETAINED
{
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = DeallocCallback;
    callbacks.getAscent = GetAscentCallback;
    callbacks.getDescent = GetDecentCallback;
    callbacks.getWidth = GetWidthCallback;
    return CTRunDelegateCreate(&callbacks, (__bridge_retained void *)(self.copy));
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(_ascent) forKey:@"ascent"];
    [aCoder encodeObject:@(_descent) forKey:@"descent"];
    [aCoder encodeObject:@(_width) forKey:@"width"];
    [aCoder encodeObject:_userInfo forKey:@"userInfo"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _ascent = ((NSNumber *)[aDecoder decodeObjectForKey:@"ascent"]).floatValue;
        _descent = ((NSNumber *)[aDecoder decodeObjectForKey:@"descent"]).floatValue;
        _width = ((NSNumber *)[aDecoder decodeObjectForKey:@"width"]).floatValue;
        _userInfo = [aDecoder decodeObjectForKey:@"userInfo"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    __typeof(self) one = [self.class new];
    one.ascent = self.ascent;
    one.descent = self.descent;
    one.width = self.width;
    one.userInfo = self.userInfo;
    
    return one;
}

@end



/**
 Wrapper for CTRubyAnnotationRef.
 
 Example:
 
 JXTextRubyAnnotation *ruby = [JXTextRubyAnnotation new];
 ruby.textBefore = @"zhù yīn";
 CTRubyAnnotationRef ctRuby = ruby.CTRubyAnnotation;
 if (ctRuby) {
 /// add to attributed string
 CFRelease(ctRuby);
 }
 
 */
@interface JXTextRubyAnnotation : NSObject <NSCopying, NSCoding>

/// Specifies how the ruby text and the base text should be aligned relative to each other.
@property (nonatomic) CTRubyAlignment alignment;

/// Specifies how the ruby text can overhang adjacent characters.
@property (nonatomic) CTRubyOverhang overhang;

/// Specifies the size of the annotation text as a percent of the size of the base text.
@property (nonatomic) CGFloat sizeFactor;


/// The ruby text is positioned before the base text;
/// i.e. above horizontal text and to the right of vertical text.
@property (nullable, nonatomic, copy) NSString *textBefore;

/// The ruby text is positioned after the base text;
/// i.e. below horizontal text and to the left of vertical text.
@property (nullable, nonatomic, copy) NSString *textAfter;

/// The ruby text is positioned to the right of the base text whether it is horizontal or vertical.
/// This is the way that Bopomofo annotations are attached to Chinese text in Taiwan.
@property (nullable, nonatomic, copy) NSString *textInterCharacter;

/// The ruby text follows the base text with no special styling.
@property (nullable, nonatomic, copy) NSString *textInline;


/**
 Create a ruby object from CTRuby object.
 
 @param ctRuby  A CTRuby object.
 
 @return A ruby object, or nil when an error occurs.
 */
+ (instancetype)rubyWithCTRubyRef:(CTRubyAnnotationRef)ctRuby NS_AVAILABLE_IOS(8_0);

/**
 Create a CTRuby object from the instance.
 
 @return A new CTRuby object, or NULL when an error occurs.
 The returned value should be release after used.
 */
- (nullable CTRubyAnnotationRef)CTRubyAnnotation CF_RETURNS_RETAINED NS_AVAILABLE_IOS(8_0);

@end

@implementation JXTextRubyAnnotation

- (instancetype)init
{
    self = super.init;
    if (self) {
        self.alignment = kCTRubyAlignmentAuto;
        self.overhang = kCTRubyOverhangAuto;
        self.sizeFactor = 0.5;
    }
    return self;
}

+ (instancetype)rubyWithCTRubyRef:(CTRubyAnnotationRef)ctRuby
{
    if (!ctRuby) return nil;
    JXTextRubyAnnotation *one = [self new];
    one.alignment = CTRubyAnnotationGetAlignment(ctRuby);
    one.overhang = CTRubyAnnotationGetOverhang(ctRuby);
    one.sizeFactor = CTRubyAnnotationGetSizeFactor(ctRuby);
    one.textBefore = (__bridge NSString *)(CTRubyAnnotationGetTextForPosition(ctRuby, kCTRubyPositionBefore));
    one.textAfter = (__bridge NSString *)(CTRubyAnnotationGetTextForPosition(ctRuby, kCTRubyPositionAfter));
    one.textInterCharacter = (__bridge NSString *)(CTRubyAnnotationGetTextForPosition(ctRuby, kCTRubyPositionInterCharacter));
    one.textInline = (__bridge NSString *)(CTRubyAnnotationGetTextForPosition(ctRuby, kCTRubyPositionInline));
    return one;
}

- (CTRubyAnnotationRef)CTRubyAnnotation CF_RETURNS_RETAINED
{
    if (((long)CTRubyAnnotationCreate + 1) == 1) {
        return NULL; // system not support
    }
    
    CFStringRef text[kCTRubyPositionCount];
    text[kCTRubyPositionBefore] = (__bridge CFStringRef)(_textBefore);
    text[kCTRubyPositionAfter] = (__bridge CFStringRef)(_textAfter);
    text[kCTRubyPositionInterCharacter] = (__bridge CFStringRef)(_textInterCharacter);
    text[kCTRubyPositionInline] = (__bridge CFStringRef)(_textInline);
    CTRubyAnnotationRef ruby = CTRubyAnnotationCreate(_alignment, _overhang, _sizeFactor, text);
    return ruby;
}

- (id)copyWithZone:(NSZone *)zone
{
    JXTextRubyAnnotation *one = [self.class new];
    one.alignment = _alignment;
    one.overhang = _overhang;
    one.sizeFactor = _sizeFactor;
    one.textBefore = _textBefore;
    one.textAfter = _textAfter;
    one.textInterCharacter = _textInterCharacter;
    one.textInline = _textInline;
    return one;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(_alignment) forKey:@"alignment"];
    [aCoder encodeObject:@(_overhang) forKey:@"overhang"];
    [aCoder encodeObject:@(_sizeFactor) forKey:@"sizeFactor"];
    [aCoder encodeObject:_textBefore forKey:@"textBefore"];
    [aCoder encodeObject:_textAfter forKey:@"textAfter"];
    [aCoder encodeObject:_textInterCharacter forKey:@"textInterCharacter"];
    [aCoder encodeObject:_textInline forKey:@"textInline"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        _alignment = ((NSNumber *)[aDecoder decodeObjectForKey:@"alignment"]).intValue;
        _overhang = ((NSNumber *)[aDecoder decodeObjectForKey:@"overhang"]).intValue;
        _sizeFactor = ((NSNumber *)[aDecoder decodeObjectForKey:@"sizeFactor"]).intValue;
        _textBefore = [aDecoder decodeObjectForKey:@"textBefore"];
        _textAfter = [aDecoder decodeObjectForKey:@"textAfter"];
        _textInterCharacter = [aDecoder decodeObjectForKey:@"textInterCharacter"];
        _textInline = [aDecoder decodeObjectForKey:@"textInline"];
    }
    return self;
}

@end


#pragma mark -
#pragma mark JXCGImage

@interface JXCGColor : NSObject <NSCopying, NSCoding>

@property (nonatomic, assign) CGColorRef CGColor;
+ (instancetype)colorWithCGColor:(CGColorRef)CGColor;

@end

@implementation JXCGColor

+ (instancetype)colorWithCGColor:(CGColorRef)CGColor
{
    JXCGColor *color = [self new];
    color.CGColor = CGColor;
    return color;
}

- (void)dealloc
{
    if (_CGColor) CFRelease(_CGColor);
    _CGColor = NULL;
}


#pragma mark -
#pragma mark Setters

- (void)setCGColor:(CGColorRef)CGColor
{
    if (_CGColor != CGColor) {
        if (CGColor) CGColor = (CGColorRef)CFRetain(CGColor);
        if (_CGColor) CFRelease(_CGColor);
        _CGColor = CGColor;
    }
}


#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    JXCGColor *color = [self.class new];
    color.CGColor = self.CGColor;
    return color;
}


#pragma mark -
#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    UIColor *color = [UIColor colorWithCGColor:_CGColor];
    [aCoder encodeObject:color forKey:@"color"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    UIColor *color = [aDecoder decodeObjectForKey:@"color"];
    self.CGColor = color.CGColor;
    return self;
}

@end


#pragma mark -
#pragma mark JXCGImage

/**
 A wrapper for CGImageRef. Used for Archive/Unarchive/Copy.
 */
@interface JXCGImage : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) CGImageRef CGImage;
+ (instancetype)imageWithCGImage:(CGImageRef)CGImage;

@end

@implementation JXCGImage

+ (instancetype)imageWithCGImage:(CGImageRef)CGImage
{
    JXCGImage *image = [self new];
    image.CGImage = CGImage;
    return image;
}

- (void)setCGImage:(CGImageRef)CGImage
{
    if (_CGImage != CGImage) {
        if (CGImage) CGImage = (CGImageRef)CFRetain(CGImage);
        if (_CGImage) CFRelease(_CGImage);
        _CGImage = CGImage;
    }
}

- (void)dealloc
{
    if (_CGImage) CFRelease(_CGImage);
    _CGImage = NULL;
}

- (id)copyWithZone:(NSZone *)zone
{
    JXCGImage *image = [self.class new];
    image.CGImage = self.CGImage;
    return image;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    UIImage *image = [UIImage imageWithCGImage:_CGImage];
    [aCoder encodeObject:image forKey:@"image"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    UIImage *image = [aDecoder decodeObjectForKey:@"image"];
    self.CGImage = image.CGImage;
    return self;
}

@end


static CFTypeID CTRunDelegateTypeID() {
    static CFTypeID typeID;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /*
         if ((long)CTRunDelegateGetTypeID + 1 > 1) { //avoid compiler optimization
         typeID = CTRunDelegateGetTypeID();
         }
         */
        JXTextRunDelegate *delegate = [JXTextRunDelegate new];
        CTRunDelegateRef ref = delegate.CTRunDelegate;
        typeID = CFGetTypeID(ref);
        CFRelease(ref);
    });
    return typeID;
}

static CFTypeID CTRubyAnnotationTypeID() {
    static CFTypeID typeID;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ((long)CTRubyAnnotationGetTypeID + 1 > 1) { //avoid compiler optimization
            typeID = CTRunDelegateGetTypeID();
        } else {
            typeID = kCFNotFound;
        }
    });
    return typeID;
}


#pragma mark -
#pragma mark JXTextArchiver

/**
 A subclass of `NSKeyedArchiver` which implement `NSKeyedArchiverDelegate` protocol.
 
 The archiver can encode the object which contains
 CGColor/CGImage/CTRunDelegateRef/.. (such as NSAttributedString).
 */
@interface JXTextArchiver : NSKeyedArchiver <NSKeyedArchiverDelegate>
@end

@implementation JXTextArchiver

+ (NSData *)archivedDataWithRootObject:(id)rootObject
{
    if (nil == rootObject) {
        return nil;
    }
    
    NSMutableData *data = [NSMutableData data];
    JXTextArchiver *archiver = [[[self class] alloc] initForWritingWithMutableData:data];
    [archiver encodeRootObject:rootObject];
    [archiver finishEncoding];
    
    return data;
}

+ (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path
{
    NSData *data = [self archivedDataWithRootObject:rootObject];
    if (!data) return NO;
    return [data writeToFile:path atomically:YES];
}

- (instancetype)init {
    self = [super init];
    self.delegate = self;
    return self;
}

- (instancetype)initForWritingWithMutableData:(NSMutableData *)data {
    self = [super initForWritingWithMutableData:data];
    self.delegate = self;
    return self;
}

- (id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object {
    CFTypeID typeID = CFGetTypeID((CFTypeRef)object);
    if (typeID == CTRunDelegateTypeID()) {
        CTRunDelegateRef runDelegate = (__bridge CFTypeRef)(object);
        id ref = CTRunDelegateGetRefCon(runDelegate);
        if (ref) return ref;
    } else if (typeID == CTRubyAnnotationTypeID()) {
        CTRubyAnnotationRef ctRuby = (__bridge CFTypeRef)(object);
        JXTextRubyAnnotation *ruby = [JXTextRubyAnnotation rubyWithCTRubyRef:ctRuby];
        if (ruby) return ruby;
    } else if (typeID == CGColorGetTypeID()) {
        return [JXCGColor colorWithCGColor:(CGColorRef)object];
    } else if (typeID == CGImageGetTypeID()) {
        return [JXCGImage imageWithCGImage:(CGImageRef)object];
    }
    return object;
}

@end


#pragma mark -
#pragma mark JXTextUnarchiver

/**
 A subclass of `NSKeyedUnarchiver` which implement `NSKeyedUnarchiverDelegate`
 protocol. The unarchiver can decode the data which is encoded by
 `JXTextArchiver` or `NSKeyedArchiver`.
 */
@interface JXTextUnarchiver : NSKeyedUnarchiver <NSKeyedUnarchiverDelegate>
@end

@implementation JXTextUnarchiver

+ (id)unarchiveObjectWithData:(NSData *)data
{
    if (data.length == 0) return nil;
    JXTextUnarchiver *unarchiver = [[self alloc] initForReadingWithData:data];
    return [unarchiver decodeObject];
}

+ (id)unarchiveObjectWithFile:(NSString *)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self unarchiveObjectWithData:data];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    
    return self;
}

- (instancetype)initForReadingWithData:(NSData *)data
{
    self = [super initForReadingWithData:data];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (id)unarchiver:(NSKeyedUnarchiver *)unarchiver didDecodeObject:(id) NS_RELEASES_ARGUMENT object NS_RETURNS_RETAINED
{
    if ([object class] == [JXTextRunDelegate class]) {
        JXTextRunDelegate *runDelegate = object;
        CTRunDelegateRef ct = runDelegate.CTRunDelegate;
        id ctObj = (__bridge id)ct;
        if (ct) CFRelease(ct);
        return ctObj;
    } else if ([object class] == [JXTextRubyAnnotation class]) {
        JXTextRubyAnnotation *ruby = object;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8) {
            CTRubyAnnotationRef ct = ruby.CTRubyAnnotation;
            id ctObj = (__bridge id)(ct);
            if (ct) CFRelease(ct);
            return ctObj;
        } else {
            return object;
        }
    } else if ([object class] == [JXCGColor class]) {
        JXCGColor *color = object;
        return (id)color.CGColor;
    } else if ([object class] == [JXCGImage class]) {
        JXCGImage *image = object;
        return (id)image.CGImage;
    }
    return object;
}

@end


#pragma mark -
#pragma mark JXTextShadow

@implementation JXTextShadow

+ (instancetype)shadowWithColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius
{
    JXTextShadow *one = [self new];
    one.color = color;
    one.offset = offset;
    one.radius = radius;
    
    return one;
}

+ (instancetype)shadowWithNSShadow:(NSShadow *)nsShadow
{
    if (nil == nsShadow) {
        return nil;
    }
    
    JXTextShadow *shadow = [self new];
    shadow.offset = nsShadow.shadowOffset;
    shadow.radius = nsShadow.shadowBlurRadius;
    
    id color = nsShadow.shadowColor;
    if (color) {
        if (CGColorGetTypeID() == CFGetTypeID((__bridge CFTypeRef)(color))) {
            color = [UIColor colorWithCGColor:(__bridge CGColorRef)(color)];
        }
        if ([color isKindOfClass:[UIColor class]]) {
            shadow.color = color;
        }
    }
    return shadow;
}

- (NSShadow *)nsShadow
{
    NSShadow *shadow = [NSShadow new];
    shadow.shadowOffset = self.offset;
    shadow.shadowBlurRadius = self.radius;
    shadow.shadowColor = self.color;
    
    return shadow;
}


#pragma mark -
#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.color forKey:@"color"];
    [aCoder encodeObject:@(self.radius) forKey:@"radius"];
    [aCoder encodeObject:[NSValue valueWithCGSize:self.offset] forKey:@"offset"];
    [aCoder encodeObject:self.subShadow forKey:@"subShadow"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _color = [aDecoder decodeObjectForKey:@"color"];
        _radius = ((NSNumber *)[aDecoder decodeObjectForKey:@"radius"]).floatValue;
        _offset = ((NSValue *)[aDecoder decodeObjectForKey:@"offset"]).CGSizeValue;
        _subShadow = [aDecoder decodeObjectForKey:@"subShadow"];
    }
    
    return self;
}


#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    __typeof(self) one = [self.class new];
    one.color = self.color;
    one.radius = self.radius;
    one.offset = self.offset;
    one.subShadow = self.subShadow.copy;
    
    return one;
}

@end


#pragma mark -
#pragma mark JXTextBorder

@implementation JXTextBorder

+ (instancetype)borderWithLineStyle:(JXTextLineStyle)lineStyle lineWidth:(CGFloat)width strokeColor:(UIColor *)color
{
    JXTextBorder *one = [self new];
    one.lineStyle = lineStyle;
    one.strokeWidth = width;
    one.strokeColor = color;
    
    return one;
}

+ (instancetype)borderWithFillColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    JXTextBorder *one = [self new];
    one.fillColor = color;
    one.cornerRadius = cornerRadius;
    one.insets = UIEdgeInsetsMake(-2, 0, 0, -2);
    
    return one;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lineStyle = JXTextLineStyleSingle;
    }
    
    return self;
}


#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _lineStyle = ((NSNumber *)[aDecoder decodeObjectForKey:@"lineStyle"]).unsignedIntegerValue;
        _strokeWidth = ((NSNumber *)[aDecoder decodeObjectForKey:@"strokeWidth"]).doubleValue;
        _strokeColor = [aDecoder decodeObjectForKey:@"strokeColor"];
        _lineJoin = (CGLineJoin)((NSNumber *)[aDecoder decodeObjectForKey:@"join"]).unsignedIntegerValue;
        _insets = ((NSValue *)[aDecoder decodeObjectForKey:@"insets"]).UIEdgeInsetsValue;
        _cornerRadius = ((NSNumber *)[aDecoder decodeObjectForKey:@"cornerRadius"]).doubleValue;
        _shadow = [aDecoder decodeObjectForKey:@"shadow"];
        _fillColor = [aDecoder decodeObjectForKey:@"fillColor"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.lineStyle) forKey:@"lineStyle"];
    [aCoder encodeObject:@(self.strokeWidth) forKey:@"strokeWidth"];
    [aCoder encodeObject:self.strokeColor forKey:@"strokeColor"];
    [aCoder encodeObject:@(self.lineJoin) forKey:@"lineJoin"];
    [aCoder encodeObject:[NSValue valueWithUIEdgeInsets:self.insets] forKey:@"insets"];
    [aCoder encodeObject:@(self.cornerRadius) forKey:@"cornerRadius"];
    [aCoder encodeObject:self.shadow forKey:@"shadow"];
    [aCoder encodeObject:self.fillColor forKey:@"fillColor"];
}


#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    __typeof(self) one = [self.class new];
    one.lineStyle = self.lineStyle;
    one.strokeWidth = self.strokeWidth;
    one.strokeColor = self.strokeColor;
    one.lineJoin = self.lineJoin;
    one.insets = self.insets;
    one.cornerRadius = self.cornerRadius;
    one.shadow = self.shadow.copy;
    one.fillColor = self.fillColor;
    
    return one;
}

@end


#pragma mark -
#pragma mark JXTextHighlight

@implementation JXTextHighlight

@synthesize attributes = _attributes;

+ (instancetype)highlightWithAttributes:(NSDictionary *)attributes
{
    JXTextHighlight *one = [self new];
    one.attributes = [attributes mutableCopy];
    
    return one;
}

+ (instancetype)highlightWithBackgroundColor:(UIColor *)color
{
    JXTextHighlight *one = [self new];
    
    [one setBackgroundBorder:({
        JXTextBorder *highlightBorder = [JXTextBorder new];
        highlightBorder.insets = UIEdgeInsetsMake(-2, -1, -2, -1);
        highlightBorder.cornerRadius = 3;
        highlightBorder.fillColor = color;
        highlightBorder;
    })];
    
    return one;
}


#pragma mark -
#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSData *data = nil;
    @try {
        data = [JXTextArchiver archivedDataWithRootObject:self.attributes];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    [aCoder encodeObject:data forKey:@"attributes"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        NSData *data = [aDecoder decodeObjectForKey:@"attributes"];
        
        @try {
            self.attributes = [JXTextUnarchiver unarchiveObjectWithData:data];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
    }
    return self;
}


#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    __typeof(self) one = [self.class new];
    one.attributes = self.attributes;
    return one;
}


#pragma mark -
#pragma mark Getters

- (NSMutableDictionary<NSString *,id> *)attributes
{
    if (nil == _attributes) {
        _attributes = [NSMutableDictionary dictionary];
    }
    
    return _attributes;
}


#pragma mark -
#pragma mark Setters

- (void)setAttributes:(NSDictionary *)attributes
{
    _attributes = attributes.mutableCopy;
}

- (void)setFont:(UIFont *)font
{
    if (nil == font || (id)[NSNull null] == font) {
        self.attributes[(id)kCTFontAttributeName] = [NSNull null];
    } else {
        CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
        if (ctFont) {
            self.attributes[(id)kCTFontAttributeName] = (__bridge id)(ctFont);
            CFRelease(ctFont);
        }
    }
}

- (void)setColor:(UIColor *)color
{
    if (color == (id)[NSNull null] || color == nil) {
        self.attributes[(id)kCTForegroundColorAttributeName] = [NSNull null];
        self.attributes[NSForegroundColorAttributeName] = [NSNull null];
    } else {
        self.attributes[(id)kCTForegroundColorAttributeName] = (__bridge id)(color.CGColor);
        self.attributes[NSForegroundColorAttributeName] = color;
    }
}

- (void)setTextAttribute:(NSString *)attribute value:(id)value
{
    if (value == nil) {
        value = [NSNull null];
    }
    
    self.attributes[attribute] = value;
}

- (void)setShadow:(JXTextShadow *)shadow
{
    [self setTextAttribute:JXTextShadowAttributeName value:shadow];
}

- (void)setInnerShadow:(JXTextShadow *)shadow
{
    [self setTextAttribute:JXTextInnerShadowAttributeName value:shadow];
}

- (void)setBackgroundBorder:(JXTextBorder *)border
{
    [self setTextAttribute:JXTextBackgroundBorderAttributeName value:border];
}

- (void)setBorder:(JXTextBorder *)border
{
    [self setTextAttribute:JXTextBorderAttributeName value:border];
}

@end


#pragma mark -
#pragma mark NSMutableAttributedString (JXText)

@implementation NSMutableAttributedString (JXText)

- (void)jx_setTextHighlightRange:(NSRange)range
                           color:(UIColor *)color
                 backgroundColor:(UIColor *)backgroundColor
                       tapAction:(JXTextAction)tapAction;
{
    JXTextHighlight *highlight = [JXTextHighlight highlightWithBackgroundColor:backgroundColor];
    highlight.userInfo = nil;
    highlight.tapAction = tapAction;
    
    if (nil != color) {
        [self jx_setColor:color range:range];
    }
    
    [self jx_setAttribute:JXHighlightTextAttributeName value:highlight range:range];
}

- (void)jx_setColor:(UIColor *)color range:(NSRange)range
{
    [self jx_setAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
    [self jx_setAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)jx_setAttribute:(NSString *)name value:(id)value range:(NSRange)range
{
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) [self addAttribute:name value:value range:range];
    else [self removeAttribute:name range:range];
}

@end
