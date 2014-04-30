//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBubbleCollectionViewCell.h"

@class LFBubbleCollectionView;

#pragma mark - Bubble View Delegate

@protocol LFBubbleCollectionViewDelegate <NSObject>

@optional
-(void)bubbleView:(LFBubbleCollectionView *)bubbleView didHideMenuForBubbleItemAtIndex:(NSInteger)index;
-(NSArray *)bubbleView:(LFBubbleCollectionView *)bubbleView menuItemsForBubbleItemAtIndex:(NSInteger)index;

@end

@interface LFBubbleCollectionView : UICollectionView

-(void)showMenuForBubbleItem:(LFBubbleCollectionViewCell *)item;

@property (nonatomic, weak) IBOutlet id<LFBubbleCollectionViewDelegate> bubbleViewDelegate;

//Pointer to the currently selected bubble when displaying a context menu
@property (nonatomic, weak) LFBubbleCollectionViewCell* bubbleThatIsShowingMenu;


@end
