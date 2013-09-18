//
//  OFFLINEStopDetails.m
//  offline_ios
//
//  Created by Richard on 9/10/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINEStopDetails.h"
#import "UIBorderLabel.h"
#import "OFFLINEPlaceCell.h"
#import "OFFLINESearchResultsViewController.h"
#import "fontawesome/NSString+FontAwesome.m"

@implementation OFFLINEStopDetails

@synthesize stopLabel = _stopLabel;
@synthesize placesTable = _placesTable;
@synthesize places = _places;
@synthesize colorRect = _colorRect;
@synthesize dot = _dot;
@synthesize placeDetails = _placeDetails;
@synthesize height = _height;
@synthesize stopIndex = _stopIndex;
@synthesize lineStopsController = _lineStopsController;

NSString *const MOREINFO_SERVER = @"http://dev-offline.jit.su";
NSInteger const SELECTED_PLACE_HEIGHT_DIFF = 385;
UITableView *selectedPlacesTable;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1.0f];
       
        _stopLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, self.bounds.size.width-30, 45)];
        _stopLabel.font = [UIFont systemFontOfSize:18];
        _stopLabel.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
        _stopLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_stopLabel];
        
        _colorRect = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, self.bounds.size.height)];
        _colorRect.backgroundColor = [UIColor blackColor];
        [self addSubview:_colorRect];
        
        _dot = [[UILabel alloc]initWithFrame:CGRectMake(4, 15, 15, 15)];
        _dot.font = [UIFont fontWithName:kFontAwesomeFamilyName size:13.f];
        _dot.textColor = [UIColor whiteColor];
        _dot.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-circle"];
        [self addSubview:_dot];
    }
    return self;
}

- (void)setDetails:(NSDictionary *)stopResults lineStopsController:(OFFLINESearchResultsViewController *)lineStopsController {
    self.stopLabel.text = [stopResults objectForKey:@"stop"];
    _colorRect.backgroundColor = [stopResults objectForKey:@"color"];
    _places = [stopResults objectForKey:@"places"];
    _lineStopsController = lineStopsController;
    
    _height =([_places count] * 45.0) + 45.0;
    CGRect frame = self.frame;
    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, _height)];
    
    frame = _colorRect.frame;
    [_colorRect setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, _height)];
    
    if (_places == nil || [_places count] == 0) {
        self.alpha = 0.4f;
    }
    else {
        self.alpha = 1.0f;
        int cnt = 0, y;
        OFFLINEPlaceCell *placeView;
        for(NSDictionary *place in _places){
            y = (cnt * 45) + 35;
            placeView = [[OFFLINEPlaceCell alloc] initWithFrame:CGRectMake(28, y, self.frame.size.width-35, 42)];
            placeView.tag = (_stopIndex * 100) + cnt;
            [placeView setDetails: place];
            placeView.stopIndex = _stopIndex;
            placeView.stop = self;
            [self addSubview:placeView];
            cnt++;
        }
    }
}

- (void)selectedPlace:(NSInteger)selectedTag stopIndex:(int)stopIndex {
    [_lineStopsController selected: stopIndex placeTag: selectedTag];
    // push down other places
    CGRect nextFrame;
    for(OFFLINEPlaceCell *nextPlace in [self subviews]){
        if(nextPlace.tag > selectedTag){
            nextFrame = nextPlace.frame;
            [nextPlace setFrame:CGRectMake(nextFrame.origin.x, nextFrame.origin.y+SELECTED_PLACE_HEIGHT_DIFF, nextFrame.size.width, nextFrame.size.height)];
        }
    }
}

-(void) resetPlaces {
    int cnt = 0, y;
    CGRect nextFrame;
    for(OFFLINEPlaceCell *nextPlace in [self subviews]){
        if([nextPlace isKindOfClass:[OFFLINEPlaceCell class]]){
            nextFrame = nextPlace.frame;
            y = (cnt * 45) + 35;
            [nextPlace setFrame:CGRectMake(28, y, self.frame.size.width-35, 42)];
            nextPlace.isSelected = NO;
            nextPlace.backgroundColor = [UIColor whiteColor];
            nextPlace.nameLabel.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
            nextPlace.addressLabel.textColor = [UIColor colorWithRed:127/255.0f green:140/255.0f blue:141/255.0f alpha:1.0f];
            nextPlace.yelpView.hidden = YES;
            nextPlace.mapView.hidden = YES;
            cnt++;
        }
    }
}


@end
