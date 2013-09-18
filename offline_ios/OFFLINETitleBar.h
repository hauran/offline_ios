//
//  OFFLINETitleBar.h
//  offline_ios
//
//  Created by Richard on 9/18/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButtonHightlight.h"

@class OFFLINESearchResultsViewController;

@interface OFFLINETitleBar : UIView

@property (nonatomic, strong) OFFLINESearchResultsViewController *stopsViewController;
@property (nonatomic, strong) UIButtonHightlight *backButton;
@property (nonatomic, strong) UIView *line;

-(void) hideBackButton;
-(void) showBackButton;
@end
