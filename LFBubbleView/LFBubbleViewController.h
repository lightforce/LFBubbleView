//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBubbleCollectionView.h"

@interface LFBubbleViewController : UIViewController <LFBubbleViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property IBOutlet LFBubbleCollectionView *bubbleView;

@property (nonatomic,readonly) CGFloat itemHeight;
@property (nonatomic,readonly) CGFloat itemPadding;
@property (nonatomic,readonly) CGFloat itemTextPadding;

-(void)configureItem:(LFBubbleViewCell *)item forBubbleView:(LFBubbleCollectionView *)bubbleView atIndex:(NSInteger)index;
-(void)bubbleView:(LFBubbleCollectionView *)aBubbleView didSelectBubbleItemAtIndex:(NSInteger)index;
-(void)bubbleView:(LFBubbleCollectionView *)bubbleView didDeselectBubbleItemAtIndex:(NSInteger)index;
-(BOOL)bubbleView:(LFBubbleCollectionView *)bubbleView shouldShowMenuForBubbleItemAtIndex:(NSInteger)index;
-(BOOL)bubbleView:(LFBubbleCollectionView *)bubbleView itemIsHighlightedAtIndex:(NSInteger)index;

-(NSString*)bubbleView:(LFBubbleCollectionView *)bubbleView textForItemAtIndex:(NSInteger)index;
-(UIFont*)bubbleView:(LFBubbleCollectionView *)bubbleView fontForItemAtIndex:(NSInteger)index;
-(NSUInteger)numberOfBubbleItemsInBubbleView:(LFBubbleCollectionView *)bubbleView;

@end
