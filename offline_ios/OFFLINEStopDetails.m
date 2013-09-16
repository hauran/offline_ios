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
@synthesize placesTable = _placesTable;
@synthesize places = _places;
@synthesize cellView = _cellView;
@synthesize colorRect = _colorRect;
@synthesize dot = _dot;
@synthesize placeDetails = _placeDetails;
@synthesize height = _height;
@synthesize stopRowIndex = _stopRowIndex;
@synthesize lineStopsController = _lineStopsController;
@synthesize selectedPlace = _selectedPlace;

NSString *const MOREINFO_SERVER = @"http://dev-offline.jit.su";
NSInteger const SELECTED_PLACE_HEIGHT_DIFF = 100;
UITableView *selectedPlacesTable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellView = [[UIView alloc] initWithFrame:CGRectMake(5, 3, self.bounds.size.width-10, self.bounds.size.height)];
        _cellView.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1.0f];
        
        self.stopLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, self.bounds.size.width-30, 45)];
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

        [self.contentView addSubview:_cellView];
    }
    return self;
}


- (void)setDetails:(NSDictionary *)stopResults index:(NSIndexPath *)index lineStopsController:(OFFLINESearchResultsViewController *)lineStopsController {
    
    self.stopLabel.text = [stopResults objectForKey:@"stop"];
    _colorRect.backgroundColor = [stopResults objectForKey:@"color"];
    _places = (NSArray *)[stopResults objectForKey:@"places"];
    _stopRowIndex = index;
    _lineStopsController = lineStopsController;
    
    _height =([_places count] * 45.0) + 45.0;
    CGRect frame = _cellView.frame;
    [_cellView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, _height)];
    
    frame = _colorRect.frame;
    [_colorRect setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, _height)];
    
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
//         NSLog(@"places: %D",[_places count]);
//        for (NSArray *place in _places) {
//            NSLog(@"%@",place);
//            OFFLINEPlaceViewController *place = [[OFFLINEPlaceViewController alloc] init];
//            [_cellView addSubview:place.view];
//        }
        
        _placesTable = [[UITableView alloc] initWithFrame:CGRectMake(30, 40, self.bounds.size.width-45, _height-48) style:UITableViewStylePlain];
        _placesTable.bounces = NO;
//        _placesTable.tag = _stopRowIndex;
        _placesTable.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1.0f];
        [_placesTable registerClass:[OFFLINEPlaceCell class] forCellReuseIdentifier:@"placeCell"];
        [_placesTable setDataSource:self];
        [_placesTable setDelegate:self];
        [_cellView addSubview:_placesTable];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_places count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"placeCell";

    
    OFFLINEPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
        NSLog(@"nil - create new place cell");
        cell = [[OFFLINEPlaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
    else {
        NSLog(@"reuse place cell");
    }
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    bool selected = (_selectedPlace == cell);
    
    [cell setDetails:[_places objectAtIndex:indexPath.row] selected:selected];
    cell.userInteractionEnabled=YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _placeDetails = [NSMutableData data];
    OFFLINEPlaceCell *placeCell = (OFFLINEPlaceCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(_selectedPlace != placeCell) {
        NSLog(@"PLACE SELECTED");
        NSDictionary *place = [_places objectAtIndex:indexPath.row];
        NSDictionary *latlng = [[place objectForKey:@"geometry"] objectForKey:@"location"];
        NSDictionary *address = [place objectForKey:@"vicinity"];
        NSDictionary *name = [place objectForKey:@"name"];

        NSString *rawURL = [NSString stringWithFormat :@"%@/moreInfo?address=%@&lat=%@&lng=%@&name=%@", MOREINFO_SERVER, address, [latlng objectForKey:@"lat"], [latlng objectForKey:@"lng"], name];
        NSString *url = [rawURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:url]];
        NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn start];
        
        [self getPlaceDetails:tableView indexPath:indexPath];
    }
}


- (void)getPlaceDetails:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    OFFLINEPlaceCell *placeCell = (OFFLINEPlaceCell *)[tableView cellForRowAtIndexPath:indexPath];
    _selectedPlace = placeCell;
    [placeCell selected];
    
//    [_lineStopsController selected: _stopRowIndex];
//    if(selectedPlace != nil) {
//        [selectedPlace unselected];
//        [self pullOtherPlacesBackUp];
//    }
//    [self pushOtherPlacesDown:tableView indexPath:indexPath];
//    selectedPlace = placeCell;
}


- (void)pushOtherPlacesDown:(UITableView *)placesTable indexPath:(NSIndexPath *)rowIndex{
    NSIndexPath *nextRowIndex;
    CGRect nextFrame;
    selectedPlacesTable = placesTable;
    for (int inc = 1; inc < [placesTable numberOfRowsInSection:0] - rowIndex.row; inc++) {
        NSInteger newLast = [rowIndex indexAtPosition:rowIndex.length-1]+inc;
        nextRowIndex = [[rowIndex indexPathByRemovingLastIndex] indexPathByAddingIndex:newLast];
        OFFLINEPlaceCell *nextPlace = (OFFLINEPlaceCell *)[placesTable cellForRowAtIndexPath:nextRowIndex];
        nextFrame = nextPlace.frame;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [nextPlace setFrame:CGRectMake(nextFrame.origin.x, nextFrame.origin.y+SELECTED_PLACE_HEIGHT_DIFF, nextFrame.size.width, nextFrame.size.height)];
        [UIView commitAnimations];
    }
   
}

- (void)pullOtherPlacesBackUp {
//    NSArray *cells = [selectedPlacesTable visibleCells];
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [selectedPlacesTable numberOfRowsInSection:0]; ++i)
    {
        [cells addObject:(OFFLINEPlaceCell * )[selectedPlacesTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
    }
    
    int cnt = 0;
    int y = 0;
    CGRect placeFrame;
    for (OFFLINEPlaceCell *cell in cells)
    {
        y = (cnt * 45);
        if(cnt > 0){
            y = y + (cnt*3);
        }
        placeFrame = cell.frame;
        [cell setFrame:CGRectMake(placeFrame.origin.x, y, placeFrame.size.width, placeFrame.size.height)];
        cnt++;
    }
}





- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_placeDetails appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // convert to JSON
    NSError *myError = nil;
    NSMutableDictionary *res = [NSJSONSerialization JSONObjectWithData:_placeDetails options:NSJSONReadingMutableLeaves error:&myError];
    //NSLog(@"%@", res);
//    NSString *imgURL = [res objectForKey:@"image_url"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

@end
