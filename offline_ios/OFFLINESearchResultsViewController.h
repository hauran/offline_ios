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
@end
