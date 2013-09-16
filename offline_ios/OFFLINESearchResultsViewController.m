//  Created by hauran.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINESearchResultsViewController.h"
#import "UIButtonHightlight.h"
#import "OFFLINEViewController.h"
#import "OFFLINELineData.h"
#import "OFFLINEStopDetails.h"
#import "fontawesome/NSString+FontAwesome.m"
#import "DRNRealTimeBlurView.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>


@interface OFFLINESearchResultsViewController ()
@end

@implementation OFFLINESearchResultsViewController

@synthesize header =  _header;
@synthesize searchResultsScrollView = _searchResultsScrollView;
@synthesize searchForLabel = _searchForLabel;
@synthesize loadingString = _loadingString;
@synthesize bigLine = _bigLine;
@synthesize searchLine = _searchLine;
@synthesize searchFor = _searchFor;
@synthesize blurView =  _blurView;
@synthesize searchResultsTable = _searchResultsTable;
@synthesize tableData = _tableData;


UIButtonHightlight *newAlarmButton;
NSIndexPath *selectedRowIndex;
NSString *const JSON_SERVER = @"http://dev-offline.jit.su";
NSInteger const SELECTED_HEIGHT_DIFF = 100;

@synthesize mainViewController = _mainViewController;
@synthesize searchResults = _searchResults;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _header = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    _header.backgroundColor = [UIColor colorWithRed:52/255.0f green:73/255.0f blue:94/255.0f alpha:1.0f];
    
    UIButtonHightlight *backButton = [[UIButtonHightlight alloc] init];
    [backButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:35.0]];
    
    [backButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitle: [NSString fontAwesomeIconStringForIconIdentifier:@"icon-angle-left"] forState:UIControlStateNormal];
    backButton.layer.cornerRadius = 5;
    backButton.frame = CGRectMake(self.view.frame.size.width-35, 5, 30, 30);
    
    UITapGestureRecognizer *closeAlarmModal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeModal:)];
    closeAlarmModal.numberOfTapsRequired = 1;
    [backButton setUserInteractionEnabled:YES];
    [backButton addGestureRecognizer:closeAlarmModal];
    [_header addSubview:backButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40, 0, 1, 40)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_header addSubview:lineView];
    _header.contentSize = CGSizeMake(self.view.frame.size.width, 40);
    [self.view addSubview:_header];
    
    _searchResultsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 1000)];
    [self.view addSubview:_searchResultsScrollView];
}

-(void) setup {
    OFFLINELineData *lineData =[[OFFLINELineData alloc] init];
    NSMutableArray *lines = [lineData createLineData];
    
    _blurView = [[DRNRealTimeBlurView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 75)];
    [_blurView setTint:[UIColor whiteColor]];
    [_blurView setBlurRadius:120.0];
    
    _searchLine = [_mainViewController getSelectedLine];
    _searchFor = [_mainViewController getSearchString];
    for (NSMutableDictionary *lineDetails in lines) {
        if ([(NSString *)[lineDetails objectForKey:@"line"] isEqualToString:_searchLine]){
            _bigLine = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
            _bigLine.font = [UIFont boldSystemFontOfSize:45];
            _bigLine.textAlignment = NSTextAlignmentCenter;
            _bigLine.layer.borderColor = [UIColor clearColor].CGColor;
            _bigLine.layer.cornerRadius = 30;
            _bigLine.text = [lineDetails objectForKey:@"line"];
            _bigLine.backgroundColor = [lineDetails objectForKey:@"bgColor"];
            _bigLine.textColor = [lineDetails objectForKey:@"textColor"];
            [_blurView addSubview:_bigLine];
        }
    }
    _searchForLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, self.view.frame.size.width-70, 60)];
    [_searchForLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    _searchForLabel.textAlignment = NSTextAlignmentLeft;
    _searchForLabel.layer.borderColor = [UIColor clearColor].CGColor;
    _searchForLabel.text = _searchFor;
    _searchForLabel.textColor = [UIColor darkGrayColor];
    [_blurView addSubview:_searchForLabel];
    
    _loadingString = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 100, 80)];
    [_loadingString setFont:[UIFont systemFontOfSize:20.0]];
    _loadingString.textAlignment = NSTextAlignmentLeft;
    _loadingString.layer.borderColor = [UIColor clearColor].CGColor;
    _loadingString.text = @"Searching...";
    _loadingString.textColor = [UIColor lightGrayColor];
    [_blurView addSubview:_loadingString];
    
    [_searchResultsScrollView addSubview:_blurView];
    [self doSearch];
}

-(void) doSearch{
    self.searchResults = [NSMutableData data];
    NSString *rawURL = [NSString stringWithFormat :@"%@/search/%@/%@", JSON_SERVER, _searchLine, _searchFor];
    NSString *url = [rawURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:url]];
    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.searchResults appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSLog(@"Succeeded! Received %d bytes of data",[self.searchResults length]);
    NSError *myError = nil;
    NSMutableDictionary *res = [NSJSONSerialization JSONObjectWithData:self.searchResults options:NSJSONReadingMutableLeaves error:&myError];

    _tableData = [[NSMutableArray alloc] init];
    NSArray *results = [res objectForKey:@"stops"];
    for (NSDictionary *result in results) {
        NSString *stop_name = [result objectForKey:@"stop_name"];
        NSArray *results = [result objectForKey:@"results"];
        int stopSequence = (NSInteger)[result objectForKey:@"stop_sequence"];
        NSLog(@"stop: %@ places %D", stop_name, [results count]);
        [_tableData addObject: [[NSDictionary alloc] initWithObjectsAndKeys:stop_name,@"stop", _bigLine.backgroundColor,@"color",results,@"places",stopSequence,@"stopSequence",nil]];
    }
    
    
    [_loadingString removeFromSuperview];
    _searchResultsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, self.view.frame.size.height-80) style:UITableViewStylePlain];
    [_searchResultsTable setDataSource:self];
    [_searchResultsTable setDelegate:self];
    [_searchResultsTable registerClass:[OFFLINEStopDetails class] forCellReuseIdentifier:@"stopCell"];
    [_searchResultsTable setContentInset:UIEdgeInsetsMake(55,0,0,0)];

    [_searchResultsScrollView insertSubview:_searchResultsTable belowSubview:_blurView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"stopCell";
    
    OFFLINEStopDetails *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSLog(@"nil - create new stop cell");
        cell = [[OFFLINEStopDetails alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
    else {
        NSLog(@"reuse stop cell");
    }
    
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [cell setDetails:[_tableData objectAtIndex:indexPath.row] index:indexPath lineStopsController:self ];
    cell.userInteractionEnabled=YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger placesCount = [[[_tableData objectAtIndex:indexPath.row] objectForKey:@"places"] count];
    return (placesCount * 45.0) + 45.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}

- (void) selected:(NSIndexPath *)rowIndex {
    NSLog(@"selected stop #%D", rowIndex.row);
    
//    if(selectedRowIndex !=  nil){
//        OFFLINEStopDetails *selectedStop = (OFFLINEStopDetails *)[_searchResultsTable cellForRowAtIndexPath:selectedRowIndex];
//        [selectedStop resetPlaces];
//    }
    
    if(selectedRowIndex != rowIndex){
        NSLog(@"STOP SELECTED");
        selectedRowIndex = rowIndex;
        OFFLINEStopDetails *stopDetails = (OFFLINEStopDetails *)[_searchResultsTable cellForRowAtIndexPath:rowIndex];
//    NSLog(@"%@", stopDetails);
        CGRect frame = stopDetails.frame;
        CGRect cellViewFrame = stopDetails.cellView.frame;
        CGRect placesTableFrame = stopDetails.placesTable.frame;
        int newHeight = frame.size.height + SELECTED_HEIGHT_DIFF;

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [stopDetails setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, newHeight)];
        [stopDetails.colorRect setFrame:CGRectMake(0, 0, 20, newHeight)];
        [stopDetails.cellView setFrame:CGRectMake(cellViewFrame.origin.x, cellViewFrame.origin.y, cellViewFrame.size.width, cellViewFrame.size.width + SELECTED_HEIGHT_DIFF)];
        [stopDetails.placesTable  setFrame:CGRectMake(placesTableFrame.origin.x, placesTableFrame.origin.y, placesTableFrame.size.width, placesTableFrame.size.height + SELECTED_HEIGHT_DIFF)];
        [UIView commitAnimations];
    
        NSIndexPath *nextRowIndex;
        CGRect nextFrame;
        for (int inc = 1; inc < [_searchResultsTable numberOfRowsInSection:0] - rowIndex.row; inc++) {
            NSInteger newLast = [rowIndex indexAtPosition:rowIndex.length-1]+inc;
            nextRowIndex = [[rowIndex indexPathByRemovingLastIndex] indexPathByAddingIndex:newLast];
            OFFLINEStopDetails *nextStop = (OFFLINEStopDetails *)[_searchResultsTable cellForRowAtIndexPath:nextRowIndex];
            
            nextFrame = nextStop.frame;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            [nextStop setFrame:CGRectMake(nextFrame.origin.x, nextFrame.origin.y+SELECTED_HEIGHT_DIFF, nextFrame.size.width, nextFrame.size.height)];
            [UIView commitAnimations];
        }
       
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeModal:(UIButton *)sender {
    [_loadingString removeFromSuperview];
    [_searchForLabel removeFromSuperview];
    [_bigLine removeFromSuperview];
    [self dismissViewControllerAnimated:NO completion:^{
       [_mainViewController back];
    }];
}

@end
