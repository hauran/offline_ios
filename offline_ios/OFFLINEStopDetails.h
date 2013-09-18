//
//  OFFLINEStopDetails.h
//  offline_ios
//
//  Created by Richard on 9/10/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OFFLINESearchResultsViewController.h"
#import "UIBorderLabel.h"

@interface OFFLINEStopDetails : UIView

@property (nonatomic, strong) UILabel *stopLabel;
@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) UITableView *placesTable;
@property (nonatomic, strong) UILabel *colorRect;
@property (nonatomic, strong) UILabel *dot;
@property (nonatomic, strong) NSMutableData *placeDetails;
@property (nonatomic, strong) OFFLINESearchResultsViewController *lineStopsController;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger stopIndex;

- (void)resetPlaces;
- (void)setDetails:(NSDictionary *)stopResults lineStopsController:(OFFLINESearchResultsViewController *)lineStopsController;
- (void)selectedPlace:(NSInteger)tag stopIndex:(int)stopIndex;

@end