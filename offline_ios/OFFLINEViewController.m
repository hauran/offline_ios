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
#import "OFFLINESearchResultsViewController.h"
#import "UIButtonHightlight.h"
#import "OFFLINETitleBar.h"
#import <QuartzCore/QuartzCore.h>
#import "fontawesome/NSString+FontAwesome.m"


@interface OFFLINEViewController ()

@end

@implementation OFFLINEViewController

@synthesize nycSubwayLinesData = _nycSubwayLinesData;
@synthesize selectedLine = _selectedLine;

CGRect screenBound;
CGFloat screenWidth;
CGFloat screenHeight;
UITextField *searchTextField;
UIScrollView *collecitonScrollView;
UIColor *textColor;
UIButtonHightlight *searchButton;
OFFLINESearchResultsViewController *searchResults;

NSString *const OFFLINE_SERVER = @"http://dev-offline.jit.su";
NSDictionary *lineDetails;
NSMutableArray *collectionLineCellArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    screenBound = [[UIScreen mainScreen] bounds];
    screenWidth = screenBound.size.width;
    screenHeight = screenBound.size.height;
    [self setUp];
}

- (void)setUp{
    OFFLINETitleBar *header = [[OFFLINETitleBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    [header hideBackButton];
    [self.view addSubview:header];
    
    collecitonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-40)];
    
    
    textColor = [UIColor colorWithRed:129/255.0f green:129/255.0f blue:129/255.0f alpha:1.0f];
    UILabel *searchLabel = [[UILabel alloc] init];
    searchLabel.font = [UIFont systemFontOfSize:23.0];
    searchLabel.textColor = textColor;
    searchLabel.text = @"What are you looking for?";
    searchLabel.frame = CGRectMake(10, 0, screenWidth-20, 50);
    [collecitonScrollView addSubview:searchLabel];

    CGRect frame = CGRectMake(10, 50, screenWidth - 20, 50);
    searchTextField = [[UITextField alloc] initWithFrame:frame];
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    searchTextField.textColor = [UIColor blackColor];
    searchTextField.font = [UIFont systemFontOfSize:23.0];
    searchTextField.placeholder = @"ramen, date spot, museum";
    searchTextField.backgroundColor = [UIColor clearColor];
    searchTextField.autocorrectionType = UITextAutocorrectionTypeYes;
    searchTextField.keyboardType = UIKeyboardTypeDefault;
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [collecitonScrollView addSubview:searchTextField];
    
    searchTextField.text = @"ramen";
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.font = [UIFont systemFontOfSize:23.0];
    lineLabel.textColor = textColor;
    lineLabel.text = @"Which subway line?";
    lineLabel.frame = CGRectMake(10, 120, screenWidth-20, 50);
    [collecitonScrollView addSubview:lineLabel];
    
    OFFLINELineData *lineData =[[OFFLINELineData alloc] init];
    collectionLineCellArray = [[NSMutableArray alloc] init];
    self.nycSubwayLinesData = [lineData createLineData];

    CGRect rect = CGRectMake(20, 170, screenWidth - 40, 630);
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _linesCollectionView=[[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    [_linesCollectionView setDataSource:self];
    [_linesCollectionView setDelegate:self];
    
    [_linesCollectionView registerClass:[OFFLINELineCell class] forCellWithReuseIdentifier:@"cell"];
    [_linesCollectionView setBackgroundColor:[UIColor clearColor]];
    [_linesCollectionView setOpaque:NO];
    [collecitonScrollView addSubview:_linesCollectionView];
    
    
    searchButton = [[UIButtonHightlight alloc] init];
    [searchButton setBackgroundColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [searchButton setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [searchButton.titleLabel setFont:[UIFont systemFontOfSize:25.0]];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton setTitle: @"Search" forState: UIControlStateNormal];
    searchButton.layer.cornerRadius = 10;
    searchButton.frame = CGRectMake(15, 745, 120.0, 60.0);
    
    UITapGestureRecognizer *searchResultsModal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSearchResultsModal:)];
    searchResultsModal.numberOfTapsRequired = 1;
    [searchButton setUserInteractionEnabled:YES];
    [searchButton addGestureRecognizer:searchResultsModal];
    [collecitonScrollView addSubview:searchButton];
    
    [self.view addSubview:collecitonScrollView];
    collecitonScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 850);
    
    searchResults = [[OFFLINESearchResultsViewController alloc] init];
    searchResults.mainViewController = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [collecitonScrollView addGestureRecognizer:tap];
 
//    UIPanGestureRecognizer *swipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:swipeGesture];
//    [collecitonScrollView addGestureRecognizer:swipeGesture];

}


- (IBAction)showSearchResultsModal:(UIGestureRecognizer *)newAlarmTapped{
    [self presentViewController:searchResults animated:NO completion:nil];
    [searchResults setup];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.nycSubwayLinesData count];
}

- (NSString *)getSelectedLine {
    return _selectedLine;
}

- (NSString *)getSearchString {
    return searchTextField.text;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *lineDetails = [self.nycSubwayLinesData objectAtIndex:indexPath.item];
    NSString *line = [lineDetails objectForKey:@"line"];
    UIColor *bgColor = [lineDetails objectForKey:@"bgColor"];
    UIColor *darkBorder = [lineDetails objectForKey:@"darkBorder"];
    UIColor *textColor = [lineDetails objectForKey:@"textColor"];

    OFFLINELineCell *cell = (OFFLINELineCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                               forIndexPath:indexPath];
    
    [cell setLinesCollectionViewControllers: collectionLineCellArray];
    [cell setLineDetails:line bgColor:bgColor textColor:textColor];
    [collectionLineCellArray addObject: cell];
    cell.darkBorder = darkBorder;
    cell.mainViewController = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}


-(void)dismissKeyboard {
    [searchTextField resignFirstResponder];
}

-(void)selected {
    [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.25];

    
    [self dismissKeyboard];
}
- (void) scrollToBottom {
    CGPoint bottomOffset = CGPointMake(0, collecitonScrollView.contentSize.height - collecitonScrollView.bounds.size.height);
    [collecitonScrollView setContentOffset:bottomOffset animated:YES];
}
-(void)back {
    NSLog(@"BACK");
    [collecitonScrollView setContentOffset:CGPointZero animated:NO];
}

@end




