//
//  NewAlarmModalViewController.m
//  rhyze
//
//  Created by hauran on 6/27/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINESearchResultsViewController.h"
#import "UIButtonHightlight.h"
#import "OFFLINEViewController.h"
#import "OFFLINELineData.h"
#import "OFFLINEStopDetails.h"
#import "fontawesome/NSString+FontAwesome.m"
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
@synthesize searchHeader = _searchHeader;
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
//    [backButton setBackgroundColor:[UIColor colorWithRed:26/255.0f green:188/255.0f blue:156/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
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
    
    _searchResultsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 1000)];
    [self.view addSubview:_searchResultsScrollView];
}

-(void) setup {
    OFFLINELineData *lineData =[[OFFLINELineData alloc] init];
    NSMutableArray *lines = [lineData createLineData];
    
    _searchHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 75)];
    _searchHeader.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.90f];
    
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
            [_searchHeader addSubview:_bigLine];
        }
    }
    _searchForLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, self.view.frame.size.width-70, 60)];
    [_searchForLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
//    _searchForLabel.adjustsFontSizeToFitWidth = YES;
    _searchForLabel.textAlignment = NSTextAlignmentLeft;
    _searchForLabel.layer.borderColor = [UIColor clearColor].CGColor;
    _searchForLabel.text = _searchFor;
    _searchForLabel.textColor = [UIColor darkGrayColor];
    [_searchHeader addSubview:_searchForLabel];
    
    _loadingString = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 100, 80)];
    [_loadingString setFont:[UIFont systemFontOfSize:20.0]];
    _loadingString.textAlignment = NSTextAlignmentLeft;
    _loadingString.layer.borderColor = [UIColor clearColor].CGColor;
    _loadingString.text = @"Searching...";
    _loadingString.textColor = [UIColor lightGrayColor];
    [_searchHeader addSubview:_loadingString];
    
    [_searchResultsScrollView addSubview:_searchHeader];
    [self doSearch];
}

-(void) doSearch{
    self.searchResults = [NSMutableData data];
    NSString *rawURL = [NSString stringWithFormat :@"%@/search/%@/%@", JSON_SERVER, _searchLine, _searchFor];
    NSString *url = [rawURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

    NSLog(@"%@", url);
//    NSString *myString = [[NSString alloc] initWithData: encoding:NSUTF8StringEncoding];

    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:url]];
    
    
//    NSLog(@"%@", request);
    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.searchResults appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSLog(@"connectionDidFinishLoading");
//    NSLog(@"Succeeded! Received %d bytes of data",[self.searchResults length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSMutableDictionary *res = [NSJSONSerialization JSONObjectWithData:self.searchResults options:NSJSONReadingMutableLeaves error:&myError];
    
    
    
//    for(NSDictionary *stops in res) {
//        NSLog(@"Stops: %@", stops);
//    }
    
//        SBJsonParser *parser;
//        NSLog(@"%@", [parser objectWithString:res]);
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

    _tableData = [[NSMutableArray alloc] init];
    NSArray *results = [res objectForKey:@"stops"];
    for (NSDictionary *result in results) {
        NSString *stop_name = [result objectForKey:@"stop_name"];
        NSArray *results = [result objectForKey:@"results"];
        int stopSequence = [result objectForKey:@"stop_sequence"];
        
        
        NSLog(@"stop: %@ places %D", stop_name, [results count]);
        [_tableData addObject: [[NSDictionary alloc] initWithObjectsAndKeys:stop_name,@"stop", _bigLine.backgroundColor,@"color",results,@"places",stopSequence,@"stopSequence",nil]];
    }
    
    
    [_loadingString removeFromSuperview];
    _searchResultsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, self.view.frame.size.height-80) style:UITableViewStylePlain];
    [_searchResultsTable registerClass:[OFFLINEStopDetails class] forCellReuseIdentifier:@"stopCell"];
    [_searchResultsTable setDataSource:self];
    [_searchResultsTable setDelegate:self];
    [_searchResultsTable setContentInset:UIEdgeInsetsMake(55,0,0,0)];

    [_searchResultsScrollView insertSubview:_searchResultsTable belowSubview:_searchHeader];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"stopCell";
    
    OFFLINEStopDetails *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OFFLINEStopDetails alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    if(selectedRowIndex != rowIndex){
        [self unselect];
        
        selectedRowIndex = rowIndex;
        OFFLINEStopDetails *stopDetails = (OFFLINEStopDetails *)[_searchResultsTable cellForRowAtIndexPath:rowIndex];
//    NSLog(@"%@", stopDetails);
        CGRect frame = stopDetails.frame;
        CGRect cellViewFrame = stopDetails.cellView.frame;
        int newHeight = frame.size.height + SELECTED_HEIGHT_DIFF;

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [stopDetails setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, newHeight)];
        [stopDetails.colorRect setFrame:CGRectMake(0, 0, 20, newHeight)];
        [stopDetails.cellView setFrame:CGRectMake(cellViewFrame.origin.x, cellViewFrame.origin.y, cellViewFrame.size.width, newHeight)];
        [UIView commitAnimations];
    
        NSIndexPath *nextRowIndex;
        CGRect nextFrame;
        for (int inc = 1; inc < [_searchResultsTable numberOfRowsInSection:0] - rowIndex.row; inc++) {
            NSLog(@"%D", inc);
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

-(void) unselect {
    OFFLINEStopDetails *stopDetails = (OFFLINEStopDetails *)[_searchResultsTable cellForRowAtIndexPath:selectedRowIndex];
    //    NSLog(@"%@", stopDetails);
    CGRect frame = stopDetails.frame;
    CGRect cellViewFrame = stopDetails.cellView.frame;
    int newHeight = frame.size.height - SELECTED_HEIGHT_DIFF;
    
    
    [stopDetails setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, newHeight)];
    [stopDetails.colorRect setFrame:CGRectMake(0, 0, 20, newHeight)];
    [stopDetails.cellView setFrame:CGRectMake(cellViewFrame.origin.x, cellViewFrame.origin.y, cellViewFrame.size.width, newHeight)];
    
    NSIndexPath *nextRowIndex;
    CGRect nextFrame;
    for (int inc = 1; inc < [_searchResultsTable numberOfRowsInSection:0] - selectedRowIndex.row; inc++) {
        NSLog(@"%D", inc);
        NSInteger newLast = [selectedRowIndex indexAtPosition:selectedRowIndex.length-1]+inc;
        nextRowIndex = [[selectedRowIndex indexPathByRemovingLastIndex] indexPathByAddingIndex:newLast];
        OFFLINEStopDetails *nextStop = (OFFLINEStopDetails *)[_searchResultsTable cellForRowAtIndexPath:nextRowIndex];
        
        nextFrame = nextStop.frame;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [nextStop setFrame:CGRectMake(nextFrame.origin.x, nextFrame.origin.y-SELECTED_HEIGHT_DIFF, nextFrame.size.width, nextFrame.size.height)];
        [UIView commitAnimations];
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
