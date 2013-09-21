//
//  OFFLINEYelp.m
//  offline_ios
//
//  Created by Richard on 9/17/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINEYelp.h"
#import "OFFLINEConst.h"
#import "fontawesome/NSString+FontAwesome.m"

@implementation OFFLINEYelp

@synthesize place = _place;
@synthesize yelpData = _yelpData;
@synthesize loading = _loading;
@synthesize yelpLink = _yelpLink;
@synthesize phone = _phone;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        
        _loading = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.bounds.size.width, 20)];
        _loading.font = [UIFont systemFontOfSize:15];
        _loading.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
        _loading.textAlignment = NSTextAlignmentLeft;
        _loading.text = @"Loading Yelp...";
        _loading.hidden = YES;
        [self addSubview:_loading];
    }
    return self;
}


- (void) fetch {
    NSLog(@"FETCH");
    NSDictionary *latlng = [[_place objectForKey:@"geometry"] objectForKey:@"location"];
    NSDictionary *address = [_place objectForKey:@"vicinity"];
    NSDictionary *name = [_place objectForKey:@"name"];
    
    _yelpData = [NSMutableData data];
    NSString *rawURL = [NSString stringWithFormat :@"%@/moreInfo?address=%@&lat=%@&lng=%@&name=%@", OFFLINE_SERVER, address, [latlng objectForKey:@"lat"], [latlng objectForKey:@"lng"], name];
    NSString *url = [rawURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:url]];
    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_yelpData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // convert to JSON
    NSError *myError = nil;
    NSArray *res = [NSJSONSerialization JSONObjectWithData:_yelpData options:NSJSONReadingMutableLeaves error:&myError];
    NSString *imgURL;
    NSString *snippetImg;
    NSString *name;
    NSString *rating;
    NSString *reviewCount;
    NSString *displayPhone;
    NSString *snippetText;
    NSString *yelpLogo = [[NSString alloc] initWithFormat:@"%@", @"http://s3-media1.ak.yelpcdn.com/assets/2/www/img/55e2efe681ed/developers/yelp_logo_50x25.png"];
    
    for (NSDictionary *result in res) {
        imgURL = [result objectForKey:@"image_url"];
        _yelpLink = [NSURL URLWithString:[result objectForKey:@"mobile_url"]];
        name = [result objectForKey:@"name"];
        displayPhone = [result objectForKey:@"display_phone"];
        _phone = [result objectForKey:@"phone"];
        rating = [result objectForKey:@"rating_img_url"];
        reviewCount = [[NSString alloc] initWithFormat: @"%@ Reviews", (NSString *)[result objectForKey:@"review_count"]];
        snippetImg = [result objectForKey:@"snippet_image_url"];
        snippetText = [result objectForKey:@"snippet_text"];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *img = [UIImage imageWithData:imageData];
            UIImageView *yelpImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 100)];
            yelpImage.image = img;
            [self addSubview:yelpImage];
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *ratingImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:rating]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *ratingImg = [UIImage imageWithData:ratingImgData];
            UIImageView *yelpRatingImage = [[UIImageView alloc] initWithFrame:CGRectMake(110, 52, 84, 17)];
            yelpRatingImage.image = ratingImg;
            [self addSubview:yelpRatingImage];
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *snippetImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:snippetImg]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *snippetImg = [UIImage imageWithData:snippetImgData];
            UIImageView *yelpSnippetImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 115, 35, 35)];
            yelpSnippetImage.image = snippetImg;
            [self addSubview:yelpSnippetImage];
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *yelpLogoImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:yelpLogo]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *yelpLogoImg = [UIImage imageWithData:yelpLogoImgData];
            UIImageView *yelpLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(218, 188, 51, 27)];
            yelpLogoImgView.image = yelpLogoImg;
            yelpLogoImgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *yelpLinktap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToYelp)];
            [yelpLogoImgView addGestureRecognizer:yelpLinktap];
            [self addSubview:yelpLogoImgView];
        });
    });
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, 160, 18)];
    nameLabel.text = name;
    nameLabel.font = [UIFont boldSystemFontOfSize:14.0];
    nameLabel.textColor = [UIColor colorWithRed:66/255.0f green:139/255.0f blue:202/255.0f alpha:1.0f];
    nameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *yelpLinktap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToYelp)];
    [nameLabel addGestureRecognizer:yelpLinktap];
    [self addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 23, 160, 18)];
    phoneLabel.text = displayPhone;
    phoneLabel.font = [UIFont systemFontOfSize:13.0];
    phoneLabel.textColor = [UIColor darkGrayColor];
    phoneLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *dialPlace = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dialPlace)];
    [phoneLabel addGestureRecognizer:dialPlace];
    [self addSubview:phoneLabel];
    
    UILabel *reviewCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(198, 53, 160, 15)];
    reviewCountLabel.text = reviewCount;
    reviewCountLabel.font = [UIFont systemFontOfSize:11.0];
    reviewCountLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:reviewCountLabel];

    UILabel *openQuote = [[UILabel alloc] initWithFrame:CGRectMake(48, 114, 14, 14)];
    openQuote.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.0];
    openQuote.textColor = [UIColor lightGrayColor];
    openQuote.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-quote-left"];
    [self addSubview:openQuote];
    
    UILabel *snippet = [[UILabel alloc] initWithFrame:CGRectMake(63, 110, 190, 80)];
    snippet.font = [UIFont systemFontOfSize:12.0];
    snippet.textColor = [UIColor darkGrayColor];
    snippet.text = snippetText;
    snippet.numberOfLines = 0;
    [self addSubview:snippet];
    
    _loading.hidden = YES;
    NSLog(@"%@", res);
    
    
}

- (void)goToYelp {
    [[UIApplication sharedApplication] openURL:_yelpLink];
}

- (void)dialPlace {
    NSURL *URL = [NSURL URLWithString:_phone];
    [[UIApplication sharedApplication] openURL:URL];
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
