//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import "LFBubbleViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_BG_COLOR UIColorFromRGB(0,140,180,255)
#define DEFAULT_SELECTED_BG_COLOR UIColorFromRGB(0,140,180,255)
#define DEFAULT_TEXT_COLOR UIColorFromRGB(255,255,255,255)
#define DEFAULT_SELECTED_TEXT_COLOR UIColorFromRGB(255,255,255,255)
#define DEFAULT_BORDER_COLOR UIColorFromRGB(0,140,180,255)
#define DEFAULT_SELECTED_BORDER_COLOR UIColorFromRGB(255,255,255,255)

#define DEFAULT_BORDER_WIDTH 2.0;
#define DEFAULT_FONT [UIFont fontWithName:@"Helvetica-Bold" size:14]

#define ITEM_TEXTLABELPADDING_LEFT_AND_RIGHT 10.0;

static UIColor* UIColorFromRGB(NSInteger red, NSInteger green, NSInteger blue, NSInteger alpha) {
    return [UIColor colorWithRed:((float)red)/255.0 green:((float)green)/255.0 blue:((float)blue)/255.0 alpha:((float)alpha)/255.0];
}

@implementation LFBubbleViewCell

#pragma mark - initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.font = DEFAULT_FONT;
        
        self.textLabel.backgroundColor = [UIColor clearColor];        
        self.textLabelPadding = ITEM_TEXTLABELPADDING_LEFT_AND_RIGHT;
        [self initializeDefaultColors];
        [self addSubview:_textLabel];
    }
    return self;
}

#pragma mark - View Logic

-(void)layoutSubviews
{
    self.textLabel.frame = CGRectMake(_textLabelPadding, self.bounds.origin.y, self.bounds.size.width-2*_textLabelPadding, self.bounds.size.height);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.height/2;
    self.layer.borderWidth = DEFAULT_BORDER_WIDTH;
    self.layer.borderColor = [_unselectedBorderColor CGColor];
    
    [super layoutSubviews];
}

- (void)setColors:(BOOL)isHighlighted
{
    if(isHighlighted) {
        self.backgroundColor = _selectedBGColor;
        self.textLabel.textColor = _selectedTextColor;
        self.layer.borderColor = _selectedBorderColor.CGColor;
    } else {
        self.backgroundColor = _unselectedBGColor;
        self.textLabel.textColor = _unselectedTextColor;
        self.layer.borderColor = _unselectedBorderColor.CGColor;
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self setColors:highlighted];
        } completion:nil];
    } else {
        [self setColors:highlighted];
    }
    _isHighlighted = highlighted;
}

- (void)initializeDefaultColors
{
    self.backgroundColor = DEFAULT_BG_COLOR;
    self.unselectedBGColor = DEFAULT_BG_COLOR;
    self.selectedBGColor = DEFAULT_SELECTED_BG_COLOR;
    self.unselectedTextColor = DEFAULT_TEXT_COLOR;
    self.selectedTextColor = DEFAULT_SELECTED_TEXT_COLOR;
    self.unselectedBorderColor = DEFAULT_BORDER_COLOR;
    self.selectedBorderColor = DEFAULT_SELECTED_BORDER_COLOR;
}

-(void)prepareForReuse
{
    self.textLabel.text = nil;
    [self setHighlighted:NO animated:NO];
    [self initializeDefaultColors];
}

@end
