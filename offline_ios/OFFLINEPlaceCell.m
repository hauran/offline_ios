//
//  OFFLINEPlaceCell.m
//  offline_ios
//
//  Created by Richard on 9/12/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINEPlaceCell.h"
#import "OFFLINEYelp.h"

@implementation OFFLINEPlaceCell

@synthesize nameLabel = _nameLabel;
@synthesize addressLabel = _addressLabel;
@synthesize stop = _stop;
@synthesize stopIndex = _stopIndex;
@synthesize isSelected = _isSelected;
@synthesize yelpView = _yelpView;
@synthesize mapView = _mapView;

NSInteger const SELECTED_HEIGHT_DIFF_PLACE = 385;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isSelected = NO;
        self.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1.0f];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, self.frame.size.width-30, 22)];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 21, self.frame.size.width-30, 20)];
        _addressLabel.font = [UIFont systemFontOfSize:13];
        _addressLabel.textColor = [UIColor colorWithRed:127/255.0f green:140/255.0f blue:141/255.0f alpha:1.0f];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_addressLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selected)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setDetails:(NSMutableDictionary *)placesInfo {
    _nameLabel.text = [placesInfo objectForKey:@"name"];
    
    NSString *address=[placesInfo objectForKey:@"vicinity"];
    NSRange range = [address rangeOfString:@"," ];
    if(range.location!=NSNotFound){
        address = [address substringToIndex:range.location];
    }
    _addressLabel.text = address;
}


- (void) selected {
    if(!_isSelected) {
        _isSelected = YES;

        [_stop selectedPlace:self.tag stopIndex:_stopIndex];
        CGRect frame = self.frame;
    
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + SELECTED_HEIGHT_DIFF_PLACE)];
        self.backgroundColor = [UIColor colorWithRed:161/255.0f green:187/255.0f blue:205/255.0f alpha:1.0f];
        _nameLabel.textColor = [UIColor whiteColor];
        _addressLabel.textColor = [UIColor whiteColor];
    
        if(_mapView){
            _yelpView.hidden = NO;
            _mapView.hidden = NO;
        }
        else {
            _mapView = [[OFFLINEMap alloc] initWithFrame:CGRectMake(5, 45, self.bounds.size.width-10, 220)];
            _yelpView = [[OFFLINEYelp alloc] initWithFrame:CGRectMake(5, 270, self.bounds.size.width-10, 150)];
            [self addSubview: _mapView];
            [self addSubview: _yelpView];
        }
        
    }
}
@end
