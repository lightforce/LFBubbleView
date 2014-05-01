//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBubbleCollectionView.h"

@protocol LFBubbleCollectionViewControllerDelegate <NSObject,LFBubbleCollectionViewDelegate>

@required
-(NSString*)bubbleView:(LFBubbleCollectionView *)bubbleView textForItemAtIndex:(NSInteger)index;
-(NSUInteger)numberOfBubbleItemsInBubbleView:(LFBubbleCollectionView *)bubbleView;
-(BOOL)bubbleView:(LFBubbleCollectionView *)bubbleView itemIsHighlightedAtIndex:(NSInteger)index;

@optional
-(UIFont*)bubbleView:(LFBubbleCollectionView *)bubbleView fontForItemAtIndex:(NSInteger)index;
-(void)configureItem:(LFBubbleCollectionViewCell *)item forBubbleView:(LFBubbleCollectionView *)bubbleView atIndex:(NSInteger)index;
-(void)bubbleView:(LFBubbleCollectionView *)aBubbleView didSelectBubbleItemAtIndex:(NSInteger)index;
-(void)bubbleView:(LFBubbleCollectionView *)bubbleView didDeselectBubbleItemAtIndex:(NSInteger)index;
-(BOOL)bubbleView:(LFBubbleCollectionView *)bubbleView shouldShowMenuForBubbleItemAtIndex:(NSInteger)index;

-(CGFloat)itemHeight;
-(CGFloat)itemPadding;
-(CGFloat)itemTextPadding;

@end


@interface LFBubbleCollectionViewController : UIViewController <LFBubbleCollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) IBOutlet id<LFBubbleCollectionViewControllerDelegate> delegate;
@property (nonatomic,readonly) NSInteger selectedItemIndex;

-(void)insertItemAtIndex:(NSInteger)index;
-(void)deleteItemAtIndex:(NSInteger)index;

@end
