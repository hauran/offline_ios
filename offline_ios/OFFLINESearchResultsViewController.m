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
UIScrollView *scrollView;
UILabel *searchString;
UILabel *bigLine;
@synthesize mainViewController = _mainViewController;

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
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 1000)];
    [self.view addSubview:scrollView];
}

-(void) setup {
    OFFLINELineData *lineData =[[OFFLINELineData alloc] init];
    NSMutableArray *lines = [lineData createLineData];
    
    for (NSMutableDictionary *lineDetails in lines) {
        if ([(NSString *)[lineDetails objectForKey:@"line"] isEqualToString:[_mainViewController getSelectedLine]]){
            NSLog(@"%@",lineDetails);
            
            bigLine = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 80)];
            [bigLine setFont:[UIFont systemFontOfSize:60.0]];
            bigLine.textAlignment = NSTextAlignmentCenter;
            bigLine.layer.borderColor = [UIColor clearColor].CGColor;
            bigLine.layer.cornerRadius = 40;
            bigLine.text = [lineDetails objectForKey:@"line"];
            bigLine.backgroundColor = [lineDetails objectForKey:@"bgColor"];
            bigLine.textColor = [lineDetails objectForKey:@"textColor"];
            [scrollView addSubview:bigLine];
        }
    }
    
    searchString = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 230, 80)];
    [searchString setFont:[UIFont systemFontOfSize:25.0]];
    searchString.textAlignment = NSTextAlignmentLeft;
    searchString.layer.borderColor = [UIColor clearColor].CGColor;
    searchString.text = [_mainViewController getSearchString];
    searchString.textColor = [UIColor darkGrayColor];
    [scrollView addSubview:searchString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeModal:(UIButton *)sender {
    [searchString removeFromSuperview];
    [self dismissViewControllerAnimated:NO completion:nil];
    [_mainViewController back];
}

@end
