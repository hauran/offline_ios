//
//  OFFLINEYelp.m
//  offline_ios
//
//  Created by Richard on 9/17/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINEYelp.h"

@implementation OFFLINEYelp

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        
        UILabel *yelpDetails = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 80)];
        yelpDetails.font = [UIFont systemFontOfSize:15];
        yelpDetails.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
        yelpDetails.textAlignment = NSTextAlignmentLeft;
        yelpDetails.text = @"YELP";
        
        [self addSubview:yelpDetails];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
