//
//  OFFLINESearchResultsViewController.h
//  offline_ios
//
//  Created by Richard on 9/9/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFFLINEViewController.h"
#import "DRNRealTimeBlurView.h"

@interface OFFLINESearchResultsViewController : UIViewController
@property (nonatomic, strong) OFFLINEViewController *mainViewController;
@property (nonatomic, strong) NSMutableData *searchResults;
@property (nonatomic, strong) UIScrollView *header;
@property (nonatomic, strong) UIScrollView *searchResultsScrollView;
@property (nonatomic, strong) UILabel *searchForLabel;
@property (nonatomic, strong) UILabel *loadingString;
@property (nonatomic, strong) UILabel *bigLine;
@property (nonatomic, strong) NSString *searchLine;
@property (nonatomic, strong) NSString *searchFor;
@property (nonatomic, strong) UIView * searchResultsView;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) DRNRealTimeBlurView *blurView;
@property (nonatomic) int selectedStopIndex;

- (void) setup;
- (void)selected:(int)rowIndex;
@end
