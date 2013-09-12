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
UILabel *searchHeader;
UITableView * searchResultsTable;
NSMutableArray *tableData;

UIButtonHightlight *newAlarmButton;
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
    [header addSubview:backButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40, 0, 1, 40)];
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
    
    searchHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 75)];
    searchHeader.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.90f];
    
    searchLine = [_mainViewController getSelectedLine];
    searchFor = [_mainViewController getSearchString];
    for (NSMutableDictionary *lineDetails in lines) {
        if ([(NSString *)[lineDetails objectForKey:@"line"] isEqualToString:searchLine]){
            bigLine = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
            bigLine.font = [UIFont boldSystemFontOfSize:45];
            bigLine.textAlignment = NSTextAlignmentCenter;
            bigLine.layer.borderColor = [UIColor clearColor].CGColor;
            bigLine.layer.cornerRadius = 30;
            bigLine.text = [lineDetails objectForKey:@"line"];
            bigLine.backgroundColor = [lineDetails objectForKey:@"bgColor"];
            bigLine.textColor = [lineDetails objectForKey:@"textColor"];
            [searchHeader addSubview:bigLine];
        }
    }
    searchForLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, self.view.frame.size.width-70, 60)];
    [searchForLabel setFont:[UIFont systemFontOfSize:25.0]];
    searchForLabel.textAlignment = NSTextAlignmentLeft;
    searchForLabel.layer.borderColor = [UIColor clearColor].CGColor;
    searchForLabel.text = searchFor;
    searchForLabel.textColor = [UIColor darkGrayColor];
    [searchHeader addSubview:searchForLabel];
    
    loadingString = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 100, 80)];
    [loadingString setFont:[UIFont systemFontOfSize:20.0]];
    loadingString.textAlignment = NSTextAlignmentLeft;
    loadingString.layer.borderColor = [UIColor clearColor].CGColor;
    loadingString.text = @"Searching...";
    loadingString.textColor = [UIColor lightGrayColor];
    [searchHeader addSubview:loadingString];
    
    [searchResultsScrollView addSubview:searchHeader];
    [self doSearch];
}

-(void) doSearch{
    self.searchResults = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat :@"%@/search/%@/%@", JSON_SERVER, searchLine, searchFor]]];
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

    tableData = [[NSMutableArray alloc] init];
    NSArray *results = [res objectForKey:@"stops"];
    for (NSDictionary *result in results) {
        NSString *stop_name = [result objectForKey:@"stop_name"];
        NSArray *results = [result objectForKey:@"results"];
        [tableData addObject: [[NSDictionary alloc] initWithObjectsAndKeys:stop_name,@"stop",bigLine.backgroundColor,@"color",results,@"places",nil]];
    }
    
    
    [loadingString removeFromSuperview];
    searchResultsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, self.view.frame.size.height-80) style:UITableViewStylePlain];
    [searchResultsTable registerClass:[OFFLINEStopDetails class] forCellReuseIdentifier:@"cell"];
    [searchResultsTable setDataSource:self];
    [searchResultsTable setDelegate:self];
    [searchResultsTable setContentInset:UIEdgeInsetsMake(55,0,0,0)];

    [searchResultsScrollView insertSubview:searchResultsTable belowSubview:searchHeader];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tableData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"cell";
        
    OFFLINEStopDetails *cell = (OFFLINEStopDetails *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    NSLog(@"%@", [tableData objectAtIndex:indexPath.row]);
    [cell setDetails:[tableData objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected a row" message:[tableData objectAtIndex:indexPath.row] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
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
