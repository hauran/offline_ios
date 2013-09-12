//
//  OFFLINEStopDetails.h
//  offline_ios
//
//  Created by Richard on 9/10/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OFFLINEViewController.h"

@interface OFFLINEStopDetails : UITableViewCell

@property (nonatomic, strong) UILabel *stopLabel;
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) UIView *cellView;

@property (nonatomic, strong) OFFLINEViewController *mainViewController;

- (void)setDetails:(NSDictionary *)stopResults;

@end
