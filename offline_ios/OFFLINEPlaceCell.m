//
//  OFFLINEPlaceCell.m
//  offline_ios
//
//  Created by Richard on 9/12/13.
//  Copyright (c) 2013 Geniot. All rights reserved.
//

#import "OFFLINEPlaceCell.h"

@implementation OFFLINEPlaceCell

@synthesize cellView = _cellView;
@synthesize nameLabel = _nameLabel;
@synthesize addressLabel = _addressLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1.0f];

        _cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-45, self.bounds.size.height-3)];
        _cellView.backgroundColor = [UIColor whiteColor];
        _cellView.layer.cornerRadius = 3;

        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.bounds.size.width-30, 22)];
        _nameLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1.0f];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [_cellView addSubview:_nameLabel];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, self.bounds.size.width-30, 20)];
        _addressLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _addressLabel.font = [UIFont systemFontOfSize:13];
        _addressLabel.textColor = [UIColor colorWithRed:127/255.0f green:140/255.0f blue:141/255.0f alpha:1.0f];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        [_cellView addSubview:_addressLabel];
        
        [self addSubview:_cellView];
    }
    return self;
}

- (void)setDetails:(NSDictionary *)placesInfo stopRowIndex:(NSInteger)stopRowIndex {
    NSLog(@"place: %@", [placesInfo objectForKey:@"name"]);
    _nameLabel.text = [placesInfo objectForKey:@"name"];
    
    NSString *address=[placesInfo objectForKey:@"vicinity"];
    NSRange range = [address rangeOfString:@"," ];
    if(range.location!=NSNotFound){
        address = [address substringToIndex:range.location];
    }
    _addressLabel.text = address;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
