//
//  OFFLINEPlaceCell.h
//  offline_ios
//
//  Created by Richard on 9/12/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFFLINEStopDetails.h"

@interface OFFLINEPlaceCell : UIView

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic) int stopIndex;
@property (nonatomic, strong) OFFLINEStopDetails *stop;
@property (nonatomic) bool isSelected;
@property (nonatomic, strong) UIView *yelpView;

- (void)setDetails:(NSDictionary *)placesInfo;
- (void)selected;
@end
