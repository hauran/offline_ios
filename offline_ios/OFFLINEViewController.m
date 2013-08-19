//
//  OFFLINEViewController.m
//  offline_ios
//
//  Created by hauran on 8/15/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINEViewController.h"
#import "OFFLINELineCell.h"

@interface OFFLINEViewController ()

@end

@implementation OFFLINEViewController

@synthesize nycSubwayLinesData = _nycSubwayLinesData;


NSString *const OFFLINE_SERVER = @"http://dev-offline.jit.su";

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self getLines];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.nycSubwayLinesData appendData:data];
}

- (void)getLines{
    self.nycSubwayLinesData = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", OFFLINE_SERVER, @"lines"]]];
    
    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.nycSubwayLinesData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSArray *res = [NSJSONSerialization JSONObjectWithData:self.nycSubwayLinesData options:NSJSONReadingMutableLeaves error:&myError];
    
//    for(NSDictionary *line in res) {
//        NSLog(@"Line: %@", [line objectForKey:@"route_short_name"]);
//    }
    
    [self setUpCollectionView];
    
//    SBJsonParser *parser;
//    NSLog(@"%@", [parser objectWithString:res]);
//
//    // show all values
//    for(id key in res) {
//        
//        id value = [res objectForKey:key];
//        
//        NSString *keyAsString = (NSString *)key;
//        NSString *valueAsString = (NSString *)value;
//        
//        NSLog(@"key: %@", keyAsString);
//        NSLog(@"value: %@", valueAsString);
//    }
//    
//    // extract specific value...
//    NSArray *results = [res objectForKey:@"results"];
//    
//    for (NSDictionary *result in results) {
//        NSString *icon = [result objectForKey:@"icon"];
//        NSLog(@"icon: %@", icon);
//    }
    
}


- (void) setUpCollectionView {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _linesCollectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_linesCollectionView setDataSource:self];
    [_linesCollectionView setDelegate:self];
    
    [_linesCollectionView registerClass:[OFFLINELineCell class] forCellWithReuseIdentifier:@"cell"];
    [_linesCollectionView setBackgroundColor:[UIColor redColor]];
    
    [self.view addSubview:_linesCollectionView];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSError *myError = nil;
    NSArray *res = [NSJSONSerialization JSONObjectWithData:self.nycSubwayLinesData options:NSJSONReadingMutableLeaves error:&myError];
    return [res count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
//    
    NSError *myError = nil;
    NSArray *res = [NSJSONSerialization JSONObjectWithData:self.nycSubwayLinesData options:NSJSONReadingMutableLeaves error:&myError];
//
    NSString *routeId = [[res objectAtIndex:indexPath.item] objectForKey:@"route_short_name"];
//
//    OFFLINELineCell *lineCell = [[OFFLINELineCell alloc] init];
//    lineCell.routeId = route_id;
//    
//    cell.backgroundColor=[UIColor greenColor];
//    return cell;
    
    OFFLINELineCell *cell = (OFFLINELineCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                               forIndexPath:indexPath];
    [cell setRouteLabel:routeId];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 50);
}

@end
