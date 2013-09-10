//
//  OFFLINELineCell.m
//  offline_ios
//
//  Created by hauran on 8/19/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINELineCell.h"
#import "OFFLINEViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation OFFLINELineCell


@synthesize darkBorder = _darkBorder;
@synthesize mainViewController = _mainViewController;

NSMutableArray *parentLinesCollection;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.autoresizesSubviews = YES;
        self.label.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                       UIViewAutoresizingFlexibleHeight);
        self.label.font = [UIFont boldSystemFontOfSize:50];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.adjustsFontSizeToFitWidth = YES;
        
        self.label.layer.borderColor = [UIColor clearColor].CGColor;
        self.label.layer.borderWidth = 4.0;
        self.label.layer.cornerRadius = 35;
        
        UITapGestureRecognizer *selectLine = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLine:)];
        selectLine.numberOfTapsRequired = 1;
        [self.label setUserInteractionEnabled:YES];
        [self.label addGestureRecognizer:selectLine];
        [self addSubview:self.label];
        
        [self setLineDetails:@"" bgColor:nil textColor:nil];
    }
    return self;
}

- (void)setLineDetails:(NSString *)line bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor {
    self.label.text = line;
    self.label.layer.backgroundColor = bgColor.CGColor;
    self.label.textColor = textColor;
}

- (NSString *) getRouteLabel {
    return self.label.text;
}

- (void) unselect {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [self.label setAlpha:0.3];
    self.label.layer.borderColor = [UIColor clearColor].CGColor;
    [UIView commitAnimations];
}

- (IBAction)selectLine:(UIGestureRecognizer *)label{
    for(OFFLINELineCell *parentLine in parentLinesCollection){
        [parentLine unselect];
    }
    
    UILabel *line = (UILabel *)label.view.superview;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    label.view.layer.borderColor = _darkBorder.CGColor;
    [label.view setAlpha:1.0];
    [UIView commitAnimations];
    
    /* Is this the correct way? */
    [_mainViewController dismissKeyboard];
    _mainViewController.selectedLine =[(OFFLINELineCell *)line getRouteLabel];
    
    
    NSLog(@"%@",_mainViewController.selectedLine);
}

- (void)setLinesCollectionViewControllers:(NSMutableArray *)linesCollection; {
    parentLinesCollection = linesCollection;
}

- (UIColor *)darkerColor:(UIColor *)c
{
    float r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}

@end
