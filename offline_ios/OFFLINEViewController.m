//
//  OFFLINEViewController.m
//  offline_ios
//
//  Created by hauran on 8/15/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINEViewController.h"
#import "OFFLINELineCell.h"
#import "OFFLINELineData.h"

@interface OFFLINEViewController ()

@end

@implementation OFFLINEViewController

@synthesize nycSubwayLinesData = _nycSubwayLinesData;

CGRect screenBound;
CGFloat screenWidth;
CGFloat screenHeight;

NSString *const OFFLINE_SERVER = @"http://dev-offline.jit.su";
NSDictionary *lineDetails;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    screenBound = [[UIScreen mainScreen] bounds];
    screenWidth = screenBound.size.width;
    screenHeight = screenBound.size.height;
    [self createLines];
    NSLog(@"%@", self.nycSubwayLinesData);
}

- (void)createLines{
    OFFLINELineData *lineData =[[OFFLINELineData alloc] init];
    self.nycSubwayLinesData = [lineData createLineData];

    CGRect rect = CGRectMake(10, 100, screenWidth - 20, screenHeight-100);
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _linesCollectionView=[[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    [_linesCollectionView setDataSource:self];
    [_linesCollectionView setDelegate:self];
    
    [_linesCollectionView registerClass:[OFFLINELineCell class] forCellWithReuseIdentifier:@"cell"];
    [_linesCollectionView setBackgroundColor:[UIColor clearColor]];
    [_linesCollectionView setOpaque:NO];
    [self.view addSubview:_linesCollectionView];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.nycSubwayLinesData count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSMutableDictionary *lineDetails = [self.nycSubwayLinesData objectAtIndex:indexPath.item];
    NSString *line = [lineDetails objectForKey:@"line"];
    UIColor *bgColor = [lineDetails objectForKey:@"bgColor"];
    UIColor *textColor = [lineDetails objectForKey:@"textColor"];

    OFFLINELineCell *cell = (OFFLINELineCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                               forIndexPath:indexPath];
    
    [cell setLineDetails:line bgColor:bgColor textColor:textColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}

@end
