//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFBubbleViewCell;

@interface LFBubbleViewCell : UICollectionViewCell

@property (nonatomic, readonly) UILabel *textLabel;

@property (nonatomic, strong) UIColor *unselectedBGColor;
@property (nonatomic, strong) UIColor *selectedBGColor;
@property (nonatomic, strong) UIColor *unselectedBorderColor;
@property (nonatomic, strong) UIColor *selectedBorderColor;
@property (nonatomic, strong) UIColor *unselectedTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@property (nonatomic, assign) CGFloat textLabelPadding;
@property (nonatomic, readonly) BOOL isHighlighted;

-(void)setHighlighted:(BOOL)selected animated:(BOOL)animated;

@end
