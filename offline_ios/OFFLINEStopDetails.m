//
//  OFFLINEStopDetails.m
//  offline_ios
//
//  Created by Richard on 9/10/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINEStopDetails.h"
#import "UIBorderLabel.h"
#import "fontawesome/NSString+FontAwesome.m"

@implementation OFFLINEStopDetails

@synthesize stopLabel = _stopLabel;
@synthesize color = _color;
@synthesize mainViewController = _mainViewController;

UIBorderLabel *colorRect;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(5, 3, self.bounds.size.width-10, self.bounds.size.height)];
        cellView.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1.0f];
        
        self.stopLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, self.bounds.size.width-30, self.bounds.size.height)];
        self.autoresizesSubviews = YES;
        self.stopLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                  UIViewAutoresizingFlexibleHeight);
        self.stopLabel.font = [UIFont boldSystemFontOfSize:20];
        self.stopLabel.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
        self.stopLabel.textAlignment = NSTextAlignmentLeft;
        [cellView addSubview:self.stopLabel];
        
        colorRect = [[UIBorderLabel alloc]initWithFrame:CGRectMake(0, 0, 30, self.bounds.size.height)];
        colorRect.backgroundColor = [UIColor blackColor];
        
        colorRect.font = [UIFont fontWithName:kFontAwesomeFamilyName size:15.f];
        colorRect.textColor = [UIColor whiteColor];
        colorRect.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-circle"];
        colorRect.leftInset = 8;
        [cellView addSubview:colorRect];
                            
        [self addSubview:cellView];

        
    }
    return self;
}

- (void)setDetails:(NSString *)name color:(UIColor *)color {
    self.stopLabel.text = name;
    colorRect.backgroundColor = color;
    
}
@end
