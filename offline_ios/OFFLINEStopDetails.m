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
@synthesize places = _places;
@synthesize cellView = _cellView;
@synthesize mainViewController = _mainViewController;

UIBorderLabel *colorRect;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _cellView = [[UIView alloc] initWithFrame:CGRectMake(5, 3, self.bounds.size.width-10, self.bounds.size.height)];
        _cellView.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1.0f];
        
        self.stopLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, self.bounds.size.width-30, self.bounds.size.height)];
        self.autoresizesSubviews = YES;
        self.stopLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                  UIViewAutoresizingFlexibleHeight);
        self.stopLabel.font = [UIFont systemFontOfSize:18];
        self.stopLabel.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
        self.stopLabel.textAlignment = NSTextAlignmentLeft;
        [_cellView addSubview:self.stopLabel];
        
        colorRect = [[UIBorderLabel alloc]initWithFrame:CGRectMake(0, 0, 20, self.bounds.size.height)];
        colorRect.backgroundColor = [UIColor blackColor];
        
        colorRect.font = [UIFont fontWithName:kFontAwesomeFamilyName size:13.f];
        colorRect.textColor = [UIColor whiteColor];
        colorRect.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-circle"];
        colorRect.leftInset = 4;
        [_cellView addSubview:colorRect];
                            
        [self addSubview:_cellView];
    }
    return self;
}


- (void)setDetails:(NSDictionary *)stopResults {
    self.stopLabel.text = [stopResults objectForKey:@"stop"];
    colorRect.backgroundColor = [stopResults objectForKey:@"color"];
    _places = (NSArray *)[stopResults objectForKey:@"places"];
    if (_places == nil || [_places count] == 0) {
        _cellView.alpha = 0.4f;
    }
    else {
        _cellView.alpha = 1.0f;
         NSLog(@"places: %D",[_places count]);
        for (NSArray *place in _places) {
            NSLog(@"%@",place);
        }
        
    }
}


@end
