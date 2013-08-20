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
        
        self.label.layer.borderColor = [UIColor blueColor].CGColor;
        self.label.layer.borderWidth = 4.0;
        self.label.layer.cornerRadius = 40;
        
        [self addSubview:self.label];
        
        [self setRouteLabel:@""];
    }
    return self;
}

- (void)setRouteLabel:(NSString *) route {
    self.label.text = route;
}
@end