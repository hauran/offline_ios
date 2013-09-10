//
//  OFFLINEViewController.h
//  offline_ios
//
//  Created by hauran on 8/15/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface OFFLINEViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_linesCollectionView;
}

- (void) dismissKeyboard;
- (void) back;
- (NSString *) getSelectedLine;
- (NSString *) getSearchString;
@property (nonatomic, strong) NSMutableArray *nycSubwayLinesData;
@property (nonatomic, strong) NSString *selectedLine;

@end
