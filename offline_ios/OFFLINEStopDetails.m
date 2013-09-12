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
//    int stopSequence = [stopResults objectForKey:@"stopSequence"];

    if (_places == nil || [_places count] == 0) {
        _cellView.alpha = 0.4f;
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
        UITableView *placesTable = [[UITableView alloc] initWithFrame:CGRectMake(30, 30, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
//        placesTable.tag = stopSequence;
        [placesTable registerClass:[OFFLINEPlaceCell class] forCellReuseIdentifier:@"cell"];
        [placesTable setDataSource:self];
        [placesTable setDelegate:self];
        [placesTable setContentInset:UIEdgeInsetsMake(55,0,0,0)];
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
    //    NSLog(@"%@", [tableData objectAtIndex:indexPath.row]);
    [cell setDetails:[_places objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected a row" message:[tableData objectAtIndex:indexPath.row] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}



@end
