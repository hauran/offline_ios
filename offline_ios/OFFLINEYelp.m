//
//  OFFLINEYelp.m
//  offline_ios
//
//  Created by Richard on 9/17/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINEYelp.h"

@implementation OFFLINEYelp

@synthesize place = _place;
@synthesize yelpData = _yelpData;
@synthesize loading = _loading;

NSString *const MOREINFO_SERVER = @"http://dev-offline.jit.su";

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
    NSDictionary *latlng = [[_place objectForKey:@"geometry"] objectForKey:@"location"];
    NSDictionary *address = [_place objectForKey:@"vicinity"];
    NSDictionary *name = [_place objectForKey:@"name"];
    
    _yelpData = [NSMutableData data];
    NSString *rawURL = [NSString stringWithFormat :@"%@/moreInfo?address=%@&lat=%@&lng=%@&name=%@", MOREINFO_SERVER, address, [latlng objectForKey:@"lat"], [latlng objectForKey:@"lng"], name];
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
    NSMutableDictionary *res = [NSJSONSerialization JSONObjectWithData:_yelpData options:NSJSONReadingMutableLeaves error:&myError];
    _loading.hidden = YES;
    NSLog(@"%@", res);
    
    NSString *img = [res objectForKey:@"image_url"];
    NSString *url = [res objectForKey:@"url"];
    NSString *name = [res objectForKey:@"name"];
    NSString *phone = [res objectForKey:@"display_phone"];
    NSString *rating = [res objectForKey:@"rating_img_url"];
    NSString *reviewCount = [res objectForKey:@"review_count"];
    NSString *snippetImg = [res objectForKey:@"snippet_image_url"];
    NSString *snippetText = [res objectForKey:@"snippet_text"];
    
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
