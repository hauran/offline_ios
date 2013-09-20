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
        
        UILabel *loading = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.bounds.size.width, 20)];
        loading.font = [UIFont systemFontOfSize:15];
        loading.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
        loading.textAlignment = NSTextAlignmentLeft;
        loading.text = @"Loading Map...";
        
        [self addSubview:loading];
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
