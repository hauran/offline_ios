//
//  OFFLINEViewController.h
//  offline_ios
//
//  Created by hauran on 8/15/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface OFFLINEViewController : UIViewController
{
    UICollectionView *_linesListingView;
}

@property (nonatomic, strong) NSMutableData *nycSubwayLinesData;
@end