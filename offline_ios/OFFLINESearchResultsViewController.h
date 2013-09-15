//
//  OFFLINESearchResultsViewController.h
//  offline_ios
//
//  Created by Richard on 9/9/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFFLINEViewController.h"

@interface OFFLINESearchResultsViewController : UIViewController
-(void) setup;
@property (nonatomic, strong) OFFLINEViewController *mainViewController;
@property (nonatomic, strong) NSMutableData *searchResults;

@property (nonatomic, strong) UIScrollView *header;
@property (nonatomic, strong) UIScrollView *searchResultsScrollView;
@property (nonatomic, strong) UILabel *searchForLabel;
@property (nonatomic, strong) UILabel *loadingString;
@property (nonatomic, strong) UILabel *bigLine;
@property (nonatomic, strong) NSString *searchLine;
@property (nonatomic, strong) NSString *searchFor;
@property (nonatomic, strong) UILabel *searchHeader;
@property (nonatomic, strong) UITableView * searchResultsTable;
@property (nonatomic, strong) NSMutableArray *tableData;

- (void)selected:(NSIndexPath *)rowIndex;

@end
