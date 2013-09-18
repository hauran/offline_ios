//
//  OFFLINEMap.m
//  offline_ios
//
//  Created by Richard on 9/17/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINEMap.h"

@implementation OFFLINEMap

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        
        UILabel *mapDetails = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 80)];
        mapDetails.font = [UIFont systemFontOfSize:15];
        mapDetails.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
        mapDetails.textAlignment = NSTextAlignmentLeft;
        mapDetails.text = @"MAP";
        
        [self addSubview:mapDetails];
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
