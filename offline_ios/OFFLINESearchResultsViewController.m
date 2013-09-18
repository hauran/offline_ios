//  Created by hauran.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINESearchResultsViewController.h"
#import "UIButtonHightlight.h"
#import "OFFLINEViewController.h"
#import "OFFLINELineData.h"
#import "OFFLINEStopDetails.h"
#import "OFFLINEPlaceCell.h"
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
@synthesize searchResultsView = _searchResultsView;
@synthesize tableData = _tableData;
@synthesize selectedStopIndex = _selectedStopIndex;


UIButtonHightlight *newAlarmButton;
NSString *const JSON_SERVER = @"http://dev-offline.jit.su";
NSInteger const SELECTED_HEIGHT_DIFF = 385;

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
    
    _searchResultsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60)];
    _searchResultsScrollView.userInteractionEnabled = YES;
    [self.view addSubview:_searchResultsScrollView];
}


-(void) setup {
    OFFLINELineData *lineData =[[OFFLINELineData alloc] init];
    NSMutableArray *lines = [lineData createLineData];
    
    _blurView = [[DRNRealTimeBlurView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 75)];
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
    
    [self.view addSubview:_blurView];
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
    NSError *myError = nil;
    NSMutableDictionary *res = [NSJSONSerialization JSONObjectWithData:self.searchResults options:NSJSONReadingMutableLeaves error:&myError];
    
    _searchResultsView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, self.view.frame.size.width, self.view.frame.size.height-80)];
    [_searchResultsScrollView insertSubview:_searchResultsView belowSubview:_blurView];
    
    _tableData = [[NSMutableArray alloc] init];
    NSArray *results = [res objectForKey:@"stops"];
    for (NSDictionary *result in results) {
        NSString *stop_name = [result objectForKey:@"stop_name"];
        NSArray *results = [result objectForKey:@"results"];
        int stopSequence = (NSInteger)[result objectForKey:@"stop_sequence"];
        NSLog(@"stop: %@ places %D", stop_name, [results count]);
        [_tableData addObject: [[NSDictionary alloc] initWithObjectsAndKeys:stop_name,@"stop", _bigLine.backgroundColor,@"color",results,@"places",stopSequence,@"stopSequence",nil]];
    }
    
    int cnt = 0, y=0, h=0, placesCount;
    OFFLINEStopDetails *stopView;
    for(NSDictionary *stop in _tableData){
        placesCount = [[stop objectForKey:@"places"] count];
        h = (placesCount * 45.0) + 45.0;
        stopView = [[OFFLINEStopDetails alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, h)];
        stopView.stopIndex = cnt;
        stopView.tag = cnt;
        [stopView setDetails: stop lineStopsController:self];
        [_searchResultsView addSubview:stopView];
        y = y + h + 3;
        cnt++;
    }
    
    [_searchResultsView setFrame:CGRectMake(0,75,self.view.frame.size.width,y)];
    [_searchResultsScrollView setContentSize:CGSizeMake(self.view.frame.size.width,y+75)];
    [_loadingString removeFromSuperview];
}


- (void) selected:(int)rowIndex placeTag:(int)placeTag {
    CGRect frame;
    CGRect nextFrame;
    int newHeight;
    OFFLINEStopDetails *nextStop;

    if(_selectedStopIndex){
        OFFLINEStopDetails *currentlySelectedStop = (OFFLINEStopDetails *)[_searchResultsView viewWithTag:_selectedStopIndex];
        //set places back to default size and position
        [currentlySelectedStop resetPlaces];
        
        if(_selectedStopIndex != rowIndex){
            NSLog(@"here");
            //collapse this row to default height
            frame = currentlySelectedStop.frame;
            newHeight = frame.size.height - SELECTED_HEIGHT_DIFF;
            [currentlySelectedStop.colorRect setFrame:CGRectMake(0, 0, 20, newHeight)];
            [currentlySelectedStop setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, newHeight)];

            //move all stops after currently selected stop up to default position
            for (int inc = 1; inc < [_tableData count] - _selectedStopIndex; inc++) {
                nextStop = (OFFLINEStopDetails *)[_searchResultsView viewWithTag:_selectedStopIndex+inc];
                nextFrame = nextStop.frame;
                [nextStop setFrame:CGRectMake(nextFrame.origin.x, nextFrame.origin.y-SELECTED_HEIGHT_DIFF, nextFrame.size.width, nextFrame.size.height)];
            }
        }
        
    }
    
    if(_selectedStopIndex != rowIndex){
        //expand the newly selected stop
        _selectedStopIndex = rowIndex;
        OFFLINEStopDetails *newSelectedStop = (OFFLINEStopDetails *)[_searchResultsView viewWithTag:_selectedStopIndex];
        frame = newSelectedStop.frame;
        newHeight = frame.size.height + SELECTED_HEIGHT_DIFF;
        
        [newSelectedStop.colorRect setFrame:CGRectMake(0, 0, 20, newHeight)];
        [newSelectedStop setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, newHeight)];
        
        //move all stops after newly selected stop down
        for (int inc = 1; inc < [_tableData count] - _selectedStopIndex; inc++) {
            nextStop = (OFFLINEStopDetails *)[_searchResultsView viewWithTag:_selectedStopIndex+inc];
            nextFrame = nextStop.frame;
            [nextStop setFrame:CGRectMake(nextFrame.origin.x, nextFrame.origin.y+SELECTED_HEIGHT_DIFF, nextFrame.size.width, nextFrame.size.height)];
        }
    }
    [self scrollToPlace:placeTag];
}

- (void) scrollToPlace:(int)placeTag {
    OFFLINEPlaceCell *place = (OFFLINEPlaceCell *)[self.view viewWithTag:placeTag];
    int placeY = place.frame.origin.y;
    
    OFFLINEStopDetails *stop = (OFFLINEStopDetails *)[self.view viewWithTag:_selectedStopIndex];
    int stopY = stop.frame.origin.y;
    
    CGPoint placeOffset = CGPointMake(0, stopY + placeY-3);
    [_searchResultsScrollView setContentOffset:placeOffset animated:YES];
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
