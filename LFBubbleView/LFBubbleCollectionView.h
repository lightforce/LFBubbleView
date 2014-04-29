//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBubbleViewCell.h"

@class LFBubbleCollectionView;

#pragma mark - Bubble View Delegate

@protocol LFBubbleViewDelegate <NSObject>

@optional
-(void)bubbleView:(LFBubbleCollectionView *)bubbleView didHideMenuForBubbleItemAtIndex:(NSInteger)index;
-(NSArray *)bubbleView:(LFBubbleCollectionView *)bubbleView menuItemsForBubbleItemAtIndex:(NSInteger)index;

@end

@interface LFBubbleCollectionView : UICollectionView

-(void)showMenuForBubbleItem:(LFBubbleViewCell *)item;
@property (nonatomic, weak) IBOutlet id<LFBubbleViewDelegate> bubbleViewDelegate;

//Pointer to the currently selected bubble when displaying a context menu
@property (nonatomic, weak) LFBubbleViewCell* activeBubble;


@end
