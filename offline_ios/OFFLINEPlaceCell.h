//
//  OFFLINEPlaceCell.h
//  offline_ios
//
//  Created by Richard on 9/12/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFFLINEPlaceCell : UITableViewCell

@property (nonatomic, strong) UIView *cellView;
@property (nonatomic, strong) UILabel *nameLabel;

- (void)setDetails:(NSDictionary *)placesInfo stopRowIndex:(NSInteger)stopRowIndex;
@end
