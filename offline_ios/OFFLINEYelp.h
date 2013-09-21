//
//  OFFLINEYelp.h
//  offline_ios
//
//  Created by Richard on 9/17/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFFLINEYelp : UIView

@property (nonatomic, strong) NSDictionary *place;
@property (nonatomic, strong) UILabel *loading;
@property (nonatomic, strong) NSMutableData *yelpData;
@property (nonatomic, strong) NSURL *yelpLink;
@property (nonatomic, strong) NSString *phone;

- (void) fetch;

@end
