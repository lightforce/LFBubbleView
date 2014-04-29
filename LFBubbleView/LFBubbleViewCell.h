//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFBubbleViewCell;

@protocol HEBubbleViewItemDelegate <NSObject>

-(void)selectedBubbleItem:(LFBubbleViewCell *)item; 
-(void)deselectedBubbleItem:(LFBubbleViewCell *)item;
-(BOOL)shouldHighlight:(LFBubbleViewCell *)item;

@end

@interface LFBubbleViewCell : UICollectionViewCell

@property (nonatomic, weak) id<HEBubbleViewItemDelegate> delegate;
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, assign) BOOL highlightTouches;

@property (nonatomic, strong) UIColor *unselectedBGColor;
@property (nonatomic, strong) UIColor *selectedBGColor;

@property (nonatomic, strong) UIColor *unselectedBorderColor;
@property (nonatomic, strong) UIColor *selectedBorderColor;

@property (nonatomic, strong) UIColor *unselectedTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@property (nonatomic, readonly) BOOL isSelected;
@property (nonatomic, assign) CGFloat bubbleTextLabelPadding;

-(void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
