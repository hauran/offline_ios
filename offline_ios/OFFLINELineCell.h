//
//  OFFLINELineCell.h
//  offline_ios
//
//  Created by hauran on 8/19/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFFLINELineCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIColor *darkBorder;

- (void)setLineDetails:(NSString *)line bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor;
- (void)setLinesCollectionViewControllers:(NSMutableArray *)linesCollection;

@end

