//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import "LFBubbleViewCell.h"
#import <QuartzCore/QuartzCore.h>

/////////////////// Constants //////////////////////

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
    return [UIColor colorWithRed:((float)red)/255.0
                           green:((float)green)/255.0
                            blue:((float)blue)/255.0
                           alpha:((float)alpha)/255.0];
}

/*
 TODO: Evaluate whether custom drawing is more efficient. @SEE https://www.cocoanetics.com/2013/08/variable-sized-items-in-uicollectionview/
 
 //Draw rounded Rect around label
 - (void)drawRect:(CGRect)rect
 {
 // inset by half line width to avoid cropping where line touches frame edges
 CGRect insetRect = CGRectInset(rect, 0.5, 0.5);
 UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:rect.size.height/2.0];
 
 // white background
 [[UIColor whiteColor] setFill];
 [path fill];
 
 // red outline
 [[UIColor redColor] setStroke];
 [path stroke];
 }
 */

@implementation LFBubbleViewCell
{
    CGPoint _touchBegan;
    BOOL _previouslySelected;
}

#pragma mark - initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.font = DEFAULT_FONT;
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.backgroundColor = DEFAULT_BG_COLOR;
        
        [self addSubview:_textLabel];
        
        self.bubbleTextLabelPadding = ITEM_TEXTLABELPADDING_LEFT_AND_RIGHT;
        
        self.unselectedBGColor = DEFAULT_BG_COLOR;
        self.selectedBGColor = DEFAULT_SELECTED_BG_COLOR;
        self.unselectedTextColor = DEFAULT_TEXT_COLOR;
        self.selectedTextColor = DEFAULT_SELECTED_TEXT_COLOR;
        self.unselectedBorderColor = DEFAULT_BORDER_COLOR;
        self.selectedBorderColor = DEFAULT_SELECTED_BORDER_COLOR;
        
        self.highlightTouches = YES;
    }
    return self;
}

#pragma mark - View Logic

-(void)layoutSubviews
{
    self.textLabel.frame = CGRectMake(_bubbleTextLabelPadding, self.bounds.origin.y, self.bounds.size.width-2*_bubbleTextLabelPadding, self.bounds.size.height);
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.height/2;
    self.layer.borderWidth = DEFAULT_BORDER_WIDTH;
    self.layer.borderColor = [_unselectedBorderColor CGColor];
    
    [super layoutSubviews];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        
        if (animated) {
            
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.backgroundColor = _selectedBGColor;
                self.textLabel.textColor = _selectedTextColor;
                self.layer.borderColor = _selectedBorderColor.CGColor;
            } completion:nil];
            
        }else {
            self.backgroundColor = _selectedBGColor;
            self.textLabel.textColor = _selectedTextColor;
            self.layer.borderColor = _selectedBorderColor.CGColor;
        }
        
    } else {
        
        if (animated) {
            
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.backgroundColor = _unselectedBGColor;
                self.textLabel.textColor = _unselectedTextColor;
                self.layer.borderColor = _unselectedBorderColor.CGColor;
            } completion:nil];

        }else {
            self.backgroundColor = _unselectedBGColor;
            self.textLabel.textColor = _unselectedTextColor;
            self.layer.borderColor = _unselectedBorderColor.CGColor;
        }
        
    }
    
    _isSelected = selected;
}

#pragma mark - bubble item logic

-(void)prepareForReuse
{
    self.textLabel.text = nil;
    [self setSelected:NO animated:NO];
    self.delegate = nil;
    _isSelected = NO;
    self.unselectedBGColor = DEFAULT_BG_COLOR;
    self.selectedBGColor = DEFAULT_SELECTED_BG_COLOR;
    self.unselectedTextColor = DEFAULT_TEXT_COLOR;
    self.selectedTextColor = DEFAULT_SELECTED_TEXT_COLOR;
    self.unselectedBorderColor = DEFAULT_BORDER_COLOR;
    self.selectedBorderColor = DEFAULT_SELECTED_BORDER_COLOR;
    
    self.highlightTouches = YES;
}

#pragma mark - Touch Handling

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _previouslySelected = self.isSelected;
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    _touchBegan = touchPoint;
    
    if (_highlightTouches) [self setSelected:YES animated:NO];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.bounds, touchPoint)) {
        [self touchesCancelled:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchPoint)) {
        
        BOOL shouldHighlight = [self.delegate respondsToSelector:@selector(shouldHighlight:)] ? [self.delegate shouldHighlight:self] : YES;
        [self setSelected: shouldHighlight && !_previouslySelected animated:YES];
        
        if (self.isSelected && [_delegate respondsToSelector:@selector(selectedBubbleItem:)]) {
            [_delegate selectedBubbleItem:self];
        } else if(!self.isSelected && [_delegate respondsToSelector:@selector(deselectedBubbleItem:)]){
            [_delegate deselectedBubbleItem:self];
        }
        
    } else {
        [self setSelected:NO animated:NO];
    }
    
    _previouslySelected = self.isSelected;
}

@end
