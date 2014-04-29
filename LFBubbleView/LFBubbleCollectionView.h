//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBubbleViewCell.h"

#pragma mark -  Bubble View DataSource

@class LFBubbleCollectionView;

#pragma mark - Bubble View Delegate

@protocol LFBubbleViewDelegate <NSObject>

@optional
-(void)bubbleView:(LFBubbleCollectionView *)bubbleView didSelectBubbleItemAtIndex:(NSInteger)index;
-(void)bubbleView:(LFBubbleCollectionView *)bubbleView didDeselectBubbleItemAtIndex:(NSInteger)index;
-(BOOL)bubbleView:(LFBubbleCollectionView *)bubbleView shouldShowMenuForBubbleItemAtIndex:(NSInteger)index;
-(void)bubbleView:(LFBubbleCollectionView *)bubbleView didHideMenuForBubbleItemAtIndex:(NSInteger)index;
-(NSArray *)bubbleView:(LFBubbleCollectionView *)bubbleView menuItemsForBubbleItemAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, HEBubbleViewSelectionStyle)
{
    HEBubbleViewSelectionStyleDefault,
    HEBubbleViewSelectionStyleNone
};

@interface LFBubbleCollectionView : UICollectionView <HEBubbleViewItemDelegate>

@property (nonatomic, weak) IBOutlet id<LFBubbleViewDelegate> bubbleDelegate;

// pointer to the currently selected bubble
@property (nonatomic, weak) LFBubbleViewCell *activeBubble;

// Defaults to HEBubbleViewSelectionStyleDefault
@property (nonatomic, assign) HEBubbleViewSelectionStyle selectionStyle;

@end
