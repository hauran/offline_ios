//
//  OFFLINEStopDetails.h
//  offline_ios
//
//  Created by Richard on 9/10/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OFFLINESearchResultsViewController.h"
#import "OFFLINEPlaceCell.h"
#import "UIBorderLabel.h"

@interface OFFLINEStopDetails : UITableViewCell

@property (nonatomic, strong) UILabel *stopLabel;
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) UITableView *placesTable;
@property (nonatomic, strong) UIView *cellView;
@property (nonatomic, strong) UILabel *colorRect;
@property (nonatomic, strong) UILabel *dot;
@property (nonatomic, strong) NSMutableData *placeDetails;
@property (nonatomic, strong) NSIndexPath * stopRowIndex;
@property (nonatomic, strong) OFFLINESearchResultsViewController *lineStopsController;
@property (nonatomic, strong) OFFLINEPlaceCell *selectedPlace;
@property (nonatomic) NSInteger height;

- (void)resetPlaces;
- (void)setDetails:(NSDictionary *)stopResults index:(NSIndexPath *)index lineStopsController:(OFFLINESearchResultsViewController *)lineStopsController;

@end