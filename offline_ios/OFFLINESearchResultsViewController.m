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
#import <QuartzCore/QuartzCore.h>


@interface OFFLINESearchResultsViewController ()
@end


@implementation OFFLINESearchResultsViewController

UIScrollView *header;
UIScrollView *searchResultsScrollView;
UILabel *searchForLabel;
UILabel *loadingString;
UILabel *bigLine;
NSString *searchLine;
NSString *searchFor;
NSString *const JSON_SERVER = @"http://dev-offline.jit.su";

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
    header = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    header.backgroundColor = [UIColor colorWithRed:52/255.0f green:73/255.0f blue:94/255.0f alpha:1.0f];

    UIButtonHightlight *newAlarmButton = [[UIButtonHightlight alloc] init];
    [newAlarmButton.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    [newAlarmButton setBackgroundColor:[UIColor colorWithRed:26/255.0f green:188/255.0f blue:156/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [newAlarmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newAlarmButton setTitle: @"Back" forState:UIControlStateNormal];
    newAlarmButton.layer.cornerRadius = 5;
    newAlarmButton.frame = CGRectMake(self.view.frame.size.width-65, 5, 60,30);
    
    UITapGestureRecognizer *closeAlarmModal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeModal:)];
    closeAlarmModal.numberOfTapsRequired = 1;
    [newAlarmButton setUserInteractionEnabled:YES];
    [newAlarmButton addGestureRecognizer:closeAlarmModal];
    [header addSubview:newAlarmButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-75, 0, 1, 40)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:lineView];
    header.contentSize = CGSizeMake(self.view.frame.size.width, 40);
    [self.view addSubview:header];
    
    searchResultsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 1000)];
    [self.view addSubview:searchResultsScrollView];
}

-(void) setup {
    OFFLINELineData *lineData =[[OFFLINELineData alloc] init];
    NSMutableArray *lines = [lineData createLineData];
    
    searchLine = [_mainViewController getSelectedLine];
    searchFor = [_mainViewController getSearchString];
    for (NSMutableDictionary *lineDetails in lines) {
        if ([(NSString *)[lineDetails objectForKey:@"line"] isEqualToString:searchLine]){
            bigLine = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 80)];
            bigLine.font = [UIFont boldSystemFontOfSize:60];
            bigLine.textAlignment = NSTextAlignmentCenter;
            bigLine.layer.borderColor = [UIColor clearColor].CGColor;
            bigLine.layer.cornerRadius = 40;
            bigLine.text = [lineDetails objectForKey:@"line"];
            bigLine.backgroundColor = [lineDetails objectForKey:@"bgColor"];
            bigLine.textColor = [lineDetails objectForKey:@"textColor"];
            [searchResultsScrollView addSubview:bigLine];
        }
    }
    searchForLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 230, 80)];
    [searchForLabel setFont:[UIFont systemFontOfSize:25.0]];
    searchForLabel.textAlignment = NSTextAlignmentLeft;
    searchForLabel.layer.borderColor = [UIColor clearColor].CGColor;
    searchForLabel.text = searchFor;
    searchForLabel.textColor = [UIColor darkGrayColor];
    [searchResultsScrollView addSubview:searchForLabel];
    
    loadingString = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 230, 80)];
    [loadingString setFont:[UIFont systemFontOfSize:20.0]];
    loadingString.textAlignment = NSTextAlignmentLeft;
    loadingString.layer.borderColor = [UIColor clearColor].CGColor;
    loadingString.text = @"Searching...";
    loadingString.textColor = [UIColor lightGrayColor];
    [searchResultsScrollView addSubview:loadingString];
    [self doSearch];
}

-(void) doSearch{
    self.searchResults = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat :@"%@/search/%@/%@", JSON_SERVER, searchLine, searchFor]]];
    NSLog(@"%@", request);
    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.searchResults appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.searchResults length]);
    
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
        NSArray *results = [res objectForKey:@"stops"];
//    NSLog(@"%@", results);
        for (NSDictionary *result in results) {
            NSString *stop_name = [result objectForKey:@"stop_name"];
            NSLog(@"stop_name: %@", stop_name);
        }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeModal:(UIButton *)sender {
    [loadingString removeFromSuperview];
    [searchForLabel removeFromSuperview];
    [bigLine removeFromSuperview];
    [self dismissViewControllerAnimated:NO completion:^{
       [_mainViewController back];
    }];
}

@end
