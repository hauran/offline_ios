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
#import "fontawesome/NSString+FontAwesome.m"

@implementation OFFLINEStopDetails

@synthesize stopLabel = _stopLabel;
@synthesize places = _places;
@synthesize cellView = _cellView;
@synthesize colorRect = _colorRect;
@synthesize dot = _dot;
@synthesize stopRowIndex = _stopRowIndex;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellView = [[UIView alloc] initWithFrame:CGRectMake(5, 3, self.bounds.size.width-10, self.bounds.size.height)];
        _cellView.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1.0f];
        
        self.stopLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, self.bounds.size.width-30, 45)];
//        self.autoresizesSubviews = YES;
//        self.stopLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.stopLabel.font = [UIFont systemFontOfSize:18];
        self.stopLabel.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
        self.stopLabel.textAlignment = NSTextAlignmentLeft;
        [_cellView addSubview:self.stopLabel];
        
        _colorRect = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, self.bounds.size.height)];
        _colorRect.backgroundColor = [UIColor blackColor];
        [_cellView addSubview:_colorRect];
        
        _dot = [[UILabel alloc]initWithFrame:CGRectMake(4, 15, 15, 15)];
        _dot.font = [UIFont fontWithName:kFontAwesomeFamilyName size:13.f];
        _dot.textColor = [UIColor whiteColor];
        _dot.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-circle"];
        [_cellView addSubview:_dot];

        
        [self addSubview:_cellView];
    }
    return self;
}


- (void)setDetails:(NSDictionary *)stopResults index:(NSInteger)index {
    self.stopLabel.text = [stopResults objectForKey:@"stop"];
    _colorRect.backgroundColor = [stopResults objectForKey:@"color"];
    _places = (NSArray *)[stopResults objectForKey:@"places"];
    _stopRowIndex = index;
    
    
    NSInteger height =([_places count] * 45.0) + 45.0;
    CGRect frame = _cellView.frame;
    [_cellView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height)];
    
    frame = _colorRect.frame;
    [_colorRect setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height)];
    
    if (_places == nil || [_places count] == 0) {
        _cellView.alpha = 0.4f;
//      TODO: REMOVE BY TAG
        for (NSObject *isPlacesTable in [_cellView subviews]) {
            if([isPlacesTable isKindOfClass:[UITableView class]]){
                [(UITableView *)isPlacesTable removeFromSuperview];
            }
        }
    }
    else {
        _cellView.alpha = 1.0f;
         NSLog(@"places: %D",[_places count]);
//        for (NSArray *place in _places) {
//            NSLog(@"%@",place);
//            OFFLINEPlaceViewController *place = [[OFFLINEPlaceViewController alloc] init];
//            [_cellView addSubview:place.view];
//        }
        UITableView *placesTable = [[UITableView alloc] initWithFrame:CGRectMake(30, 40, self.bounds.size.width-45, height-48) style:UITableViewStylePlain];
        placesTable.tag = _stopRowIndex;
        placesTable.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1.0f];
        [placesTable registerClass:[OFFLINEPlaceCell class] forCellReuseIdentifier:@"cell"];
        [placesTable setDataSource:self];
        [placesTable setDelegate:self];        
        [_cellView addSubview:placesTable];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"cell";
    OFFLINEPlaceCell *cell = (OFFLINEPlaceCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [cell setDetails:[_places objectAtIndex:indexPath.row] stopRowIndex:_stopRowIndex];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}



@end
