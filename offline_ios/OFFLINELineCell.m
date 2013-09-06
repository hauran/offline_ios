//
//  OFFLINELineCell.m
//  offline_ios
//
//  Created by hauran on 8/19/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINELineCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation OFFLINELineCell
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
        
        self.label.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        self.label.layer.borderColor = [UIColor clearColor].CGColor;
        self.label.layer.borderWidth = 4.0;
        self.label.layer.cornerRadius = 40;
        
        
        UITapGestureRecognizer *selectLine = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLine:)];
        selectLine.numberOfTapsRequired = 1;
        [self.label setUserInteractionEnabled:YES];
        [self.label addGestureRecognizer:selectLine];
        [self addSubview:self.label];
        
        [self setRouteLabel:@""];
    }
    return self;
}

- (void)setRouteLabel:(NSString *) route {
    self.label.text = route;
}

- (NSString *) getRouteLabel {
    return self.label.text;
}

- (IBAction)selectLine:(UIGestureRecognizer *)label{
    UILabel *line = (UILabel *)label.view.superview;
    NSLog(@"%@", [(OFFLINELineCell *)line getRouteLabel]);
}
@end