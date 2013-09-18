//
//  OFFLINETitleBar.m
//  offline_ios
//
//  Created by Richard on 9/18/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINETitleBar.h"
#import "UIButtonHightlight.h"
#import "fontawesome/NSString+FontAwesome.m"
#import "OFFLINESearchResultsViewController.h"


@implementation OFFLINETitleBar

@synthesize stopsViewController = _stopsViewController;
@synthesize backButton = _backButton;
@synthesize line = _line;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:52/255.0f green:73/255.0f blue:94/255.0f alpha:1.0f];
        
        _backButton = [[UIButtonHightlight alloc] init];
        [_backButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:35.0]];
        
        [_backButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton setTitle: [NSString fontAwesomeIconStringForIconIdentifier:@"icon-angle-left"] forState:UIControlStateNormal];
        _backButton.layer.cornerRadius = 5;
        _backButton.frame = CGRectMake(self.frame.size.width-35, 5, 30, 30);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSearchResults:)];
        tap.numberOfTapsRequired = 1;
        [_backButton setUserInteractionEnabled:YES];
        [_backButton addGestureRecognizer:tap];
        
        [self addSubview:_backButton];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-40, 0, 1, 40)];
        _line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_line];
    }
    return self;
}

- (IBAction)closeSearchResults:(UIButton *)sender {
    [_stopsViewController closeSearchResults];
}

-(void) hideBackButton {
    _backButton.hidden = YES;
    _line.hidden = YES;
}

-(void) showBackButton {
    _backButton.hidden = NO;
    _line.hidden = NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
