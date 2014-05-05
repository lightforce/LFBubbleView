//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import "LFBubbleCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_BG_COLOR UIColorFromRGB(0,140,180,255)
#define DEFAULT_SELECTED_BG_COLOR UIColorFromRGB(0,160,200,255)
#define DEFAULT_TEXT_COLOR UIColorFromRGB(255,255,255,255)
#define DEFAULT_SELECTED_TEXT_COLOR UIColorFromRGB(255,255,255,255)

#define DEFAULT_CORNER_RADIUS 12
#define DEFAULT_ITEM_TEXTLABELPADDING_LEFT_AND_RIGHT 10.0;
#define HIGHLIGHT_ANIMATION_DURATION 0.2

static UIColor* UIColorFromRGB(NSInteger red, NSInteger green, NSInteger blue, NSInteger alpha) {
    return [UIColor colorWithRed:((float)red)/255.0 green:((float)green)/255.0 blue:((float)blue)/255.0 alpha:((float)alpha)/255.0];
}

static UIColor* defaultBackgroundColor;
static UIColor* defaultSelectedBackgroundColor;
static UIColor* defaultTextColor;
static UIColor* defaultSelectedTextColor;

@implementation LFBubbleCollectionViewCell

#pragma mark - initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        static dispatch_once_t once;
        dispatch_once(&once, ^ {
            defaultBackgroundColor = DEFAULT_BG_COLOR;
            defaultSelectedBackgroundColor = DEFAULT_SELECTED_BG_COLOR;
            defaultSelectedTextColor = DEFAULT_SELECTED_TEXT_COLOR;
            defaultTextColor = DEFAULT_TEXT_COLOR;
        });
        
        self.layer.cornerRadius = DEFAULT_CORNER_RADIUS;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.layer.shouldRasterize = YES;
        
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.backgroundColor = [UIColor clearColor];
        
        _textLabelPadding = DEFAULT_ITEM_TEXTLABELPADDING_LEFT_AND_RIGHT;
        [self applyDefaultColors];
        [self addSubview:_textLabel];
    }
    return self;
}

#pragma mark - View Logic

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect targetLabelFrame = _textLabel.frame;
    targetLabelFrame.origin.x = _textLabelPadding;
    targetLabelFrame.origin.y = self.bounds.origin.y;
    targetLabelFrame.size.width = self.bounds.size.width - 2 * _textLabelPadding;
    targetLabelFrame.size.height = self.bounds.size.height;
    _textLabel.frame = targetLabelFrame;
}

- (void)setColors:(BOOL)isHighlighted
{
    if(isHighlighted) {
        self.layer.backgroundColor = _selectedBGColor.CGColor;
        _textLabel.textColor = _selectedTextColor;
    } else {
        self.layer.backgroundColor = _unselectedBGColor.CGColor;
        _textLabel.textColor = _unselectedTextColor;
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

- (void)applyDefaultColors
{
    _unselectedBGColor = defaultBackgroundColor;
    _selectedBGColor = defaultSelectedBackgroundColor;
    _unselectedTextColor = defaultTextColor;
    _selectedTextColor = defaultSelectedTextColor;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    _textLabel.text = nil;
    [self applyDefaultColors];
    [self setHighlighted:NO animated:NO];
}

@end
