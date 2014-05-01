//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import "LFBubbleCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_BG_COLOR UIColorFromRGB(0,140,180,255)
#define DEFAULT_SELECTED_BG_COLOR UIColorFromRGB(0,160,200,255)
#define DEFAULT_TEXT_COLOR UIColorFromRGB(255,255,255,255)
#define DEFAULT_SELECTED_TEXT_COLOR UIColorFromRGB(255,255,255,255)

#define DEFAULT_BORDER_WIDTH 2.0
#define DEFAULT_CORNER_RADIUS 12
#define DEFAULT_ITEM_TEXTLABELPADDING_LEFT_AND_RIGHT 10.0;
#define DEFAULT_FONT [UIFont fontWithName:@"Helvetica-Bold" size:14]
#define HIGHLIGHT_ANIMATION_DURATION 0.2

static UIColor* UIColorFromRGB(NSInteger red, NSInteger green, NSInteger blue, NSInteger alpha) {
    return [UIColor colorWithRed:((float)red)/255.0 green:((float)green)/255.0 blue:((float)blue)/255.0 alpha:((float)alpha)/255.0];
}

@implementation LFBubbleCollectionViewCell

#pragma mark - initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = DEFAULT_CORNER_RADIUS;
        
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.font = DEFAULT_FONT;
        _textLabel.backgroundColor = [UIColor clearColor];
        
        _textLabelPadding = DEFAULT_ITEM_TEXTLABELPADDING_LEFT_AND_RIGHT;
        [self initializeDefaultColors];
        [self addSubview:_textLabel];
    }
    return self;
}

#pragma mark - View Logic

-(void)layoutSubviews
{
    self.textLabel.frame = CGRectMake(self.textLabelPadding, self.bounds.origin.y, self.bounds.size.width - 2 * self.textLabelPadding , self.bounds.size.height);
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
        [UIView animateWithDuration:HIGHLIGHT_ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self setColors:highlighted];
        } completion:nil];
    } else {
        [self setColors:highlighted];
    }
    _isHighlighted = highlighted;
}

- (void)initializeDefaultColors
{
    self.unselectedBGColor = DEFAULT_BG_COLOR;
    self.selectedBGColor = DEFAULT_SELECTED_BG_COLOR;
    self.unselectedTextColor = DEFAULT_TEXT_COLOR;
    self.selectedTextColor = DEFAULT_SELECTED_TEXT_COLOR;
    self.unselectedBorderColor = nil;
    self.selectedBorderColor = nil;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.textLabel.text = nil;
    [self initializeDefaultColors];
    [self setHighlighted:NO animated:NO];
}

#pragma mark - Properties

-(void)setSelectedBorderColor:(UIColor *)selectedBorderColor
{
    if(_selectedBorderColor == selectedBorderColor) return;
    _selectedBorderColor = selectedBorderColor;
    self.layer.borderWidth = selectedBorderColor == nil ? 0 : DEFAULT_BORDER_WIDTH;
}

-(void)setUnselectedBorderColor:(UIColor *)unselectedBorderColor
{
    if(_unselectedBorderColor == unselectedBorderColor) return;
    _unselectedBorderColor = unselectedBorderColor;
    self.layer.borderWidth = unselectedBorderColor == nil ? 0 : DEFAULT_BORDER_WIDTH;
}

@end
