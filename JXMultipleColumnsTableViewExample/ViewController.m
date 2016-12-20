//
//  ViewController.m
//  JXMultipleColumnsTableViewExample
//
//  Created by Miao Yu on 16/12/20.
//  Copyright © 2016年 Heroic. All rights reserved.
//

#import "ViewController.h"
#import "JXMultipleColumnsTableView.h"
#import "NSMutableAttributedString+JXText.h"

@interface ViewController ()

@property (nonatomic, strong) JXMultipleColumnsTableView *multipleColumnsTableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = (CGRect) {.origin.x = 0.f, .origin.y = 100.f, .size.width = self.view.bounds.size.width, .size.height = 400.f};
    JXMultipleColumnsTableView *tableView = [[JXMultipleColumnsTableView alloc] initWithFrame:frame];
    tableView.backgroundColor = [UIColor whiteColor];
    
    self.multipleColumnsTableView = tableView;
    
    [self.view addSubview:tableView];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:@"style #1" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(__styelButtonTouched1:) forControlEvents:UIControlEventTouchUpInside];
    
    button1.frame = (CGRect) {
        .origin.x = self.view.center.x - 120.f,
        .origin.y = tableView.frame.origin.y - 40.f,
        .size.width = 100.f,
        .size.height = 40.f
    };
    
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"style #2" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(__styelButtonTouched2:) forControlEvents:UIControlEventTouchUpInside];
    
    button2.frame = (CGRect) {
        .origin.x = self.view.center.x + 20.f,
        .origin.y = tableView.frame.origin.y - 40.f,
        .size.width = 100.f,
        .size.height = 40.f
    };
    
    [self.view addSubview:button2];
    
    [button1 sendActionsForControlEvents:UIControlEventTouchUpInside];
}


#pragma mark -
#pragma mark __Private

- (void)__styelButtonTouched1:(UIButton *)button
{
    JXMultipleColumnsTableViewConfiguration *tableViewConfiguration = [[JXMultipleColumnsTableViewConfiguration alloc] init];
    tableViewConfiguration.lineWidth = .5f;
    tableViewConfiguration.lineColor = [UIColor lightGrayColor];
    tableViewConfiguration.contentInsets = (UIEdgeInsets) {10.f, 10.f, 10.f, 10.f};
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    JXMultipleColumnsTableViewColumnConfiguration *headerColumn = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:1.f drawingBlock:^JXMultipleColumnsTableViewTouchAction *(CGContextRef context, CGRect contentRect) {
        NSDictionary *headerTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.f],
                                               NSForegroundColorAttributeName: [UIColor blackColor],
                                               NSParagraphStyleAttributeName: paragraphStyle};
        
        NSMutableAttributedString *headerText = [[NSMutableAttributedString alloc] initWithString:@"我的月考成绩" attributes:headerTextAttributes];
        
        CGSize maxTextSize = contentRect.size;
        CGSize textSize = [headerText boundingRectWithSize:maxTextSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        CGPoint textOriginPoint = (CGPoint) {
            .x = contentRect.origin.x + 20.f, //(contentRect.size.width - textSize.width) / 2.f,
            .y = contentRect.origin.y + (contentRect.size.height - textSize.height) / 2.f,
        };
        [headerText drawAtPoint:textOriginPoint];
        
        return nil;
    }];
    //    headerColumn.backgroundColor = [UIColor lightGrayColor];
    
    JXMultipleColumnsTableViewRowConfiguration *headerRow = [[JXMultipleColumnsTableViewRowConfiguration alloc] initWithColumnConfigurations:@[headerColumn]];
    headerRow.heightRatio = 0.15;
    
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f],
                                     NSForegroundColorAttributeName: [UIColor blackColor],
                                     NSParagraphStyleAttributeName: paragraphStyle};
    
    void (^columnDrawingBlock)(CGContextRef, CGRect, NSAttributedString *) = ^(CGContextRef context, CGRect contentRect, NSAttributedString *text) {
        CGSize maxTextSize = contentRect.size;
        CGSize textSize = [text boundingRectWithSize:maxTextSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        CGRect textFrame = (CGRect) {
            .origin.x = contentRect.origin.x + (contentRect.size.width - textSize.width) / 2.f,
            .origin.y = contentRect.origin.y + (contentRect.size.height - textSize.height) / 2.f,
            .size = textSize
        };
        
        [text drawInRect:textFrame];
    };
    
    JXMultipleColumnsTableViewColumnConfiguration *column11 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f drawingBlock:^JXMultipleColumnsTableViewTouchAction *(CGContextRef context, CGRect contentRect) {
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"考试\n日" attributes:textAttributes];
        columnDrawingBlock(context, contentRect, text);
        
        return nil;
    }];
    
    JXMultipleColumnsTableViewColumnConfiguration *column12 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f drawingBlock:^JXMultipleColumnsTableViewTouchAction *(CGContextRef context, CGRect contentRect) {
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"语文\n成绩" attributes:textAttributes];
        columnDrawingBlock(context, contentRect, text);
        
        return nil;
    }];
    
    JXMultipleColumnsTableViewColumnConfiguration *column13 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f drawingBlock:^JXMultipleColumnsTableViewTouchAction *(CGContextRef context, CGRect contentRect) {
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"数学\n成绩" attributes:textAttributes];
        columnDrawingBlock(context, contentRect, text);
        
        return nil;
    }];
    
    JXMultipleColumnsTableViewColumnConfiguration *column14 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f drawingBlock:^JXMultipleColumnsTableViewTouchAction *(CGContextRef context, CGRect contentRect) {
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"英语\n成绩" attributes:textAttributes];
        columnDrawingBlock(context, contentRect, text);
        
        return nil;
    }];
    
    JXMultipleColumnsTableViewColumnConfiguration *column15 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f drawingBlock:^JXMultipleColumnsTableViewTouchAction *(CGContextRef context, CGRect contentRect) {
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"物理\n成绩" attributes:textAttributes];
        columnDrawingBlock(context, contentRect, text);
        
        return nil;
    }];
    
    JXMultipleColumnsTableViewColumnConfiguration *column16 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f drawingBlock:^JXMultipleColumnsTableViewTouchAction *(CGContextRef context, CGRect contentRect) {
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"化学\n成绩" attributes:textAttributes];
        columnDrawingBlock(context, contentRect, text);
        
        return nil;
    }];
    
    JXMultipleColumnsTableViewColumnConfiguration *column17 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f drawingBlock:^JXMultipleColumnsTableViewTouchAction *(CGContextRef context, CGRect contentRect) {
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"生物\n分" attributes:textAttributes];
        columnDrawingBlock(context, contentRect, text);
        
        return nil;
    }];
    
    JXMultipleColumnsTableViewColumnConfiguration *column18 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f drawingBlock:^JXMultipleColumnsTableViewTouchAction *(CGContextRef context, CGRect contentRect) {
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"X\n成绩" attributes:textAttributes];
        columnDrawingBlock(context, contentRect, text);
        
        return nil;
    }];
    
    
    //    column11.backgroundColor = [UIColor orangeColor];
    //    column12.backgroundColor = [UIColor blueColor];
    //    column13.backgroundColor = [UIColor blueColor];
    //    column14.backgroundColor = [UIColor blueColor];
    //    column15.backgroundColor = [UIColor blueColor];
    //    column16.backgroundColor = [UIColor blueColor];
    //    column17.backgroundColor = [UIColor blueColor];
    //    column18.backgroundColor = [UIColor blueColor];
    
    NSArray *columns = @[column11, column12, column13, column14, column15, column16, column17, column18];
    [columns makeObjectsPerformSelector:@selector(setShowRightSideSplitLine:) withObject:@NO];
    
    JXMultipleColumnsTableViewRowConfiguration *row1 = [[JXMultipleColumnsTableViewRowConfiguration alloc] initWithColumnConfigurations:columns];
    row1.heightRatio = 0.15;
    
    NSMutableArray *rowConfigurations = [NSMutableArray arrayWithObjects:headerRow, row1, nil];
    
    for (int i = 0; i < 7; ++i) {
        
        NSMutableArray *columns = [NSMutableArray array];
        
        JXMultipleColumnsTableViewColumnConfiguration *columnX1 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f drawingBlock:^JXMultipleColumnsTableViewTouchAction *(CGContextRef context, CGRect contentRect) {
            NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f],
                                             NSForegroundColorAttributeName: [UIColor blackColor],
                                             NSParagraphStyleAttributeName: paragraphStyle};
            
            NSString *dateString = [@"10/" stringByAppendingFormat:@"%0d", i + 1];
            NSAttributedString *text = [[NSAttributedString alloc] initWithString:dateString attributes:textAttributes];
            columnDrawingBlock(context, contentRect, text);
            
            return nil;
        }];
        
        [columns addObject:columnX1];
        
        NSDictionary *riseTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f],
                                             NSForegroundColorAttributeName: [UIColor colorWithRed:237.f/255.f green:50.f/255.f blue:50.f/255.f alpha:1.f],
                                             NSParagraphStyleAttributeName: paragraphStyle};
        
        NSDictionary *fallTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f],
                                             NSForegroundColorAttributeName: [UIColor colorWithRed:55.f/255.f green:186.f/255.f blue:74.f/255.f alpha:1.f],
                                             NSParagraphStyleAttributeName: paragraphStyle};
        
        NSArray *attributesTemplates = @[riseTextAttributes, fallTextAttributes];
        
        for (int j = 0; j < 7; ++j) {
            JXMultipleColumnsTableViewColumnConfiguration *columnX = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f drawingBlock:^JXMultipleColumnsTableViewTouchAction *(CGContextRef context, CGRect contentRect) {
                NSString *t = [NSString stringWithFormat:@"%d", arc4random_uniform(100)];
                NSAttributedString *text = [[NSAttributedString alloc] initWithString:t attributes:attributesTemplates[random() % 2]];
                columnDrawingBlock(context, contentRect, text);
                
                return nil;
            }];
            
            [columns addObject:columnX];
        }
        
        JXMultipleColumnsTableViewRowConfiguration *rowX = [[JXMultipleColumnsTableViewRowConfiguration alloc] initWithColumnConfigurations:columns];
        rowX.heightRatio = 0.1;
        
        [rowConfigurations addObject:rowX];
    }
    
    tableViewConfiguration.rowConfigurations = rowConfigurations;
    
    self.multipleColumnsTableView.configuration = tableViewConfiguration;
}

- (void)__styelButtonTouched2:(UIButton *)button
{
    JXMultipleColumnsTableViewConfiguration *tableViewConfiguration = [[JXMultipleColumnsTableViewConfiguration alloc] init];
    tableViewConfiguration.lineWidth = 0.5f;
    tableViewConfiguration.lineColor = [UIColor lightGrayColor];
    tableViewConfiguration.contentInsets = (UIEdgeInsets) {10.f, -0.25f, 10.f, -0.25f};
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *headerTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.f],
                                           NSForegroundColorAttributeName: [UIColor blackColor],
                                           NSParagraphStyleAttributeName: paragraphStyle};
    NSMutableAttributedString *headerText = [[NSMutableAttributedString alloc] initWithString:@"我的月考成绩（红绿随机）" attributes:headerTextAttributes];
    
    [headerText jx_setTextHighlightRange:(NSRange) {0, 1} color:[UIColor blueColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, JXTextHighlight *highlight, NSRange range, CGRect rect) {
        NSLog(@"tapped: text: %@", [headerText attributedSubstringFromRange:range]);
    }];
    
    [headerText setAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} range:(NSRange) {7, 1}];
    [headerText setAttributes:@{NSForegroundColorAttributeName: [UIColor greenColor]} range:(NSRange) {8, 1}];
    
    JXMultipleColumnsTableViewColumnConfiguration *headerColumn = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.8f attributedText:headerText];
    headerColumn.rightSideSplitLineColor = [UIColor greenColor];
    headerColumn.showRightSideSplitLine = NO;
    
    //    headerColumn.backgroundColor = [UIColor lightGrayColor];
    
    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
    imageAttachment.image = [UIImage imageNamed:@"test"];
    NSMutableAttributedString *headerText2 = [[NSAttributedString attributedStringWithAttachment:imageAttachment] mutableCopy];
    
    [headerText2 jx_setTextHighlightRange:(NSRange) {0, 1} color:[UIColor blueColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, JXTextHighlight *highlight, NSRange range, CGRect rect) {
        NSLog(@"tapped: text: %@", highlight);
    }];
    
    JXMultipleColumnsTableViewColumnConfiguration *headerColumn2 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.2f attributedText:headerText2];
    //    headerColumn2.backgroundColor = [UIColor lightGrayColor];
    
    JXMultipleColumnsTableViewRowConfiguration *headerRow = [[JXMultipleColumnsTableViewRowConfiguration alloc] initWithColumnConfigurations:@[headerColumn, headerColumn2]];
    headerRow.heightRatio = 0.15;
    
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f],
                                     NSForegroundColorAttributeName: [UIColor blackColor],
                                     NSParagraphStyleAttributeName: paragraphStyle};
    NSAttributedString *text11 = [[NSAttributedString alloc] initWithString:@"考试\n日期" attributes:textAttributes];
    JXMultipleColumnsTableViewColumnConfiguration *column11 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:text11];
    
    NSAttributedString *text12 = [[NSAttributedString alloc] initWithString:@"语文\n成绩" attributes:textAttributes];
    JXMultipleColumnsTableViewColumnConfiguration *column12 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:text12];
    
    NSAttributedString *text13 = [[NSAttributedString alloc] initWithString:@"数学\n成绩" attributes:textAttributes];
    JXMultipleColumnsTableViewColumnConfiguration *column13 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:text13];
    
    NSAttributedString *text14 = [[NSAttributedString alloc] initWithString:@"英语\n成绩" attributes:textAttributes];
    JXMultipleColumnsTableViewColumnConfiguration *column14 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:text14];
    
    NSAttributedString *text15 = [[NSAttributedString alloc] initWithString:@"物理\n成绩" attributes:textAttributes];
    JXMultipleColumnsTableViewColumnConfiguration *column15 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:text15];
    
    NSAttributedString *text16 = [[NSAttributedString alloc] initWithString:@"化学\n成绩" attributes:textAttributes];
    JXMultipleColumnsTableViewColumnConfiguration *column16 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:text16];
    
    NSAttributedString *text17 = [[NSAttributedString alloc] initWithString:@"生物\n分" attributes:textAttributes];
    JXMultipleColumnsTableViewColumnConfiguration *column17 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:text17];
    
    NSAttributedString *text18 = [[NSAttributedString alloc] initWithString:@"总\n成绩" attributes:textAttributes];
    JXMultipleColumnsTableViewColumnConfiguration *column18 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:text18];
    
    //    column11.backgroundColor = [UIColor orangeColor];
    //    column12.backgroundColor = [UIColor blueColor];
    //    column13.backgroundColor = [UIColor blueColor];
    //    column14.backgroundColor = [UIColor blueColor];
    //    column15.backgroundColor = [UIColor blueColor];
    //    column16.backgroundColor = [UIColor blueColor];
    //    column17.backgroundColor = [UIColor blueColor];
    //    column18.backgroundColor = [UIColor blueColor];
    
    NSArray *columns = @[column11, column12, column13, column14, column15, column16, column17, column18];
    [columns makeObjectsPerformSelector:@selector(setShowRightSideSplitLine:) withObject:@NO];
    
    JXMultipleColumnsTableViewRowConfiguration *row1 = [[JXMultipleColumnsTableViewRowConfiguration alloc] initWithColumnConfigurations:columns];
    row1.heightRatio = 0.15;
    
    NSMutableArray *rowConfigurations = [NSMutableArray arrayWithObjects:headerRow, row1, nil];
    
    for (int i = 0; i < 7; ++i) {
        NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f],
                                         NSForegroundColorAttributeName: [UIColor blackColor],
                                         NSParagraphStyleAttributeName: paragraphStyle};
        
        NSString *dateString = [NSString stringWithFormat:@"%d/%0d", 3 + i, i + 1];
        NSAttributedString *textX1 = [[NSAttributedString alloc] initWithString:dateString attributes:textAttributes];
        JXMultipleColumnsTableViewColumnConfiguration *columnX1 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:textX1];
        
        NSDictionary *riseTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f],
                                             NSForegroundColorAttributeName: [UIColor colorWithRed:237.f/255.f green:50.f/255.f blue:50.f/255.f alpha:1.f],
                                             NSParagraphStyleAttributeName: paragraphStyle};
        
        NSDictionary *fallTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f],
                                             NSForegroundColorAttributeName: [UIColor colorWithRed:55.f/255.f green:186.f/255.f blue:74.f/255.f alpha:1.f],
                                             NSParagraphStyleAttributeName: paragraphStyle};
        
        NSArray *attributesTemplates = @[riseTextAttributes, fallTextAttributes];
        
        int textX2 = arc4random_uniform(40) + 60;
        NSAttributedString *attributedTextX2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", textX2] attributes:attributesTemplates[random() % 2]];
        JXMultipleColumnsTableViewColumnConfiguration *columnX2 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:attributedTextX2];
        
        int textX3 = arc4random_uniform(40) + 60;
        NSAttributedString *attributedTextX3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", textX3] attributes:attributesTemplates[random() % 2]];
        JXMultipleColumnsTableViewColumnConfiguration *columnX3 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:attributedTextX3];
        
        int textX4 = arc4random_uniform(40) + 60;
        NSAttributedString *attributedTextX4 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", textX4] attributes:attributesTemplates[random() % 2]];
        JXMultipleColumnsTableViewColumnConfiguration *columnX4 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:attributedTextX4];
        
        int textX5 = arc4random_uniform(40) + 60;
        NSAttributedString *attributedTextX5 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", textX5] attributes:attributesTemplates[random() % 2]];
        JXMultipleColumnsTableViewColumnConfiguration *columnX5 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:attributedTextX5];
        
        int textX6 = arc4random_uniform(40) + 60;
        NSAttributedString *attributedTextX6 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", textX6] attributes:attributesTemplates[random() % 2]];
        JXMultipleColumnsTableViewColumnConfiguration *columnX6 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:attributedTextX6];
        
        int textX7 = arc4random_uniform(40) + 60;
        NSAttributedString *attributedTextX7 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", textX7] attributes:attributesTemplates[random() % 2]];
        JXMultipleColumnsTableViewColumnConfiguration *columnX7 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:attributedTextX7];
        
        int textX8 = textX2 + textX3 + textX4 + textX5 + textX6 + textX7;
        NSAttributedString *attributedTextX8 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", textX8] attributes:attributesTemplates[random() % 2]];
        JXMultipleColumnsTableViewColumnConfiguration *columnX8 = [JXMultipleColumnsTableViewColumnConfiguration columnWithWidthRatio:.125f attributedText:attributedTextX8];
        
        //        columnX1.backgroundColor = [UIColor orangeColor];
        //        columnX2.backgroundColor = [UIColor blueColor];
        //        columnX3.backgroundColor = [UIColor blueColor];
        //        columnX4.backgroundColor = [UIColor blueColor];
        //        columnX5.backgroundColor = [UIColor blueColor];
        //        columnX6.backgroundColor = [UIColor blueColor];
        //        columnX7.backgroundColor = [UIColor blueColor];
        //        columnX8.backgroundColor = [UIColor blueColor];
        
        JXMultipleColumnsTableViewRowConfiguration *rowX = [[JXMultipleColumnsTableViewRowConfiguration alloc] initWithColumnConfigurations:@[columnX1, columnX2, columnX3, columnX4, columnX5, columnX6, columnX7, columnX8]];
        rowX.heightRatio = 0.1;
        
        [rowConfigurations addObject:rowX];
    }
    
    tableViewConfiguration.rowConfigurations = rowConfigurations;
    
    self.multipleColumnsTableView.configuration = tableViewConfiguration;
}


@end
