//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import "LFBubbleViewController.h"
#import "LFBubbleViewCell.h"

#define DEFAULT_ITEM_PADDING 5
#define DEFAULT_ITEM_HEIGHT 25
#define DEFAULT_ITEM_TEXT_PADDING 15
#define DEFAULT_FONT [UIFont fontWithName:@"Avenir-Light" size:13.0]

#define REUSE_CELL_IDENTIFIER @"BubbleCell"

@implementation LFBubbleViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.bubbleView registerClass:[LFBubbleViewCell class] forCellWithReuseIdentifier:REUSE_CELL_IDENTIFIER];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFBubbleCollectionView * bubbleView = (LFBubbleCollectionView *)collectionView;
    LFBubbleViewCell *item = [bubbleView dequeueReusableCellWithReuseIdentifier:REUSE_CELL_IDENTIFIER forIndexPath:indexPath];
    [self configureItem:item forBubbleView:bubbleView atIndex:indexPath.row];
    
    //We neet to call setSelected to initialize the bubble style
    BOOL itemShouldBeHighlighted = [self bubbleView:bubbleView itemIsHighlightedAtIndex:indexPath.row];
    [item setHighlighted:itemShouldBeHighlighted animated:NO];
    return item;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return [self itemPadding];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFBubbleCollectionView * bubbleCollectionView = (LFBubbleCollectionView *) collectionView;
    CGFloat itemHeight = [self itemHeight];
    CGFloat itemPadding = [self itemPadding];
    CGFloat itemTextPadding = [self itemTextPadding];
    NSString* bubbleLabelText = [self bubbleView:bubbleCollectionView textForItemAtIndex:indexPath.row];
    UIFont* bubbleFont = [self bubbleView:bubbleCollectionView fontForItemAtIndex:indexPath.row];
    
    CGFloat currentBubbleWidth = [bubbleLabelText sizeWithFont:bubbleFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, itemHeight)].width+2*itemTextPadding;
    
    BOOL currentBubbleWidthIsLargerThanFrameWidth = currentBubbleWidth > self.bubbleView.frame.size.width-2 * itemPadding;
    if (currentBubbleWidthIsLargerThanFrameWidth) {
        // if bubble width is bigger than frame width cut it off...
        currentBubbleWidth = self.bubbleView.frame.size.width-2*itemPadding;
    }
    
    return CGSizeMake(currentBubbleWidth, itemHeight);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFBubbleViewCell* cell = (LFBubbleViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    LFBubbleCollectionView* bubbleCollectionView = (LFBubbleCollectionView*)collectionView;
    
    BOOL highlighted = !cell.isHighlighted;
    [cell setHighlighted:highlighted animated:YES];
    
    if(highlighted && [self bubbleView:bubbleCollectionView shouldShowMenuForBubbleItemAtIndex:indexPath.row]){
        [self.bubbleView showMenuForBubbleItem:cell];
        return;
    }
    
    if(highlighted) [self bubbleView:bubbleCollectionView didSelectBubbleItemAtIndex:indexPath.row];
    else [self bubbleView:bubbleCollectionView didDeselectBubbleItemAtIndex:indexPath.row];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfBubbleItemsInBubbleView:(LFBubbleCollectionView *)collectionView];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - Default implementation

- (void)configureItem:(LFBubbleViewCell *)item forBubbleView:(LFBubbleCollectionView *)bubbleView atIndex:(NSInteger)index
{
    item.textLabel.font = [self bubbleView:bubbleView fontForItemAtIndex:index];
    item.textLabel.text = [self bubbleView:bubbleView textForItemAtIndex:index];
    item.textLabelPadding = self.itemTextPadding;
}

-(CGFloat)itemHeight
{
    return DEFAULT_ITEM_HEIGHT;
}

-(CGFloat)itemPadding
{
    return DEFAULT_ITEM_PADDING;
}

-(CGFloat)itemTextPadding
{
    return DEFAULT_ITEM_TEXT_PADDING;
}

-(void)bubbleView:(LFBubbleCollectionView *)aBubbleView didSelectBubbleItemAtIndex:(NSInteger)index
{}

-(void)bubbleView:(LFBubbleCollectionView *)bubbleView didDeselectBubbleItemAtIndex:(NSInteger)index
{}

-(BOOL)bubbleView:(LFBubbleCollectionView *)bubbleView shouldShowMenuForBubbleItemAtIndex:(NSInteger)index
{
    return NO;
}

-(BOOL)bubbleView:(LFBubbleCollectionView *)bubbleView itemIsHighlightedAtIndex:(NSInteger)index
{
    return NO;
}

-(NSString*)bubbleView:(LFBubbleCollectionView *)bubbleView textForItemAtIndex:(NSInteger)index
{
    return nil;
}

-(UIFont*)bubbleView:(LFBubbleCollectionView *)bubbleView fontForItemAtIndex:(NSInteger)index
{
    return DEFAULT_FONT;
}

-(NSUInteger)numberOfBubbleItemsInBubbleView:(LFBubbleCollectionView *)bubbleView
{
    return 0;
}

@end
