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

@interface OFFLINEStopDetails : UITableViewCell

@property (nonatomic, strong) UILabel *stopLabel;
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) UIView *cellView;
@property (nonatomic, strong) UILabel *colorRect;
@property (nonatomic, strong) UILabel *dot;
@property (nonatomic) NSInteger stopRowIndex;

- (void)setDetails:(NSDictionary *)stopResults index:(NSInteger)index;

@end