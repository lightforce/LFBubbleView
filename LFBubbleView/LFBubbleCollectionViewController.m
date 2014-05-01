//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import "LFBubbleCollectionViewController.h"
#import "LFBubbleCollectionViewCell.h"

#define DEFAULT_ITEM_PADDING 5
#define DEFAULT_ITEM_HEIGHT 25
#define DEFAULT_ITEM_TEXT_PADDING 15
#define DEFAULT_FONT [UIFont fontWithName:@"Avenir-Light" size:13.0]

#define REUSE_CELL_IDENTIFIER @"BubbleCell"

@interface LFBubbleCollectionViewController ()
@property (nonatomic,readonly) LFBubbleCollectionView *bubbleView;
@end

@implementation LFBubbleCollectionViewController

-(void)setView:(UIView*)aView{
    [super setView:aView];
    [(UICollectionView*)aView registerClass:[LFBubbleCollectionViewCell class] forCellWithReuseIdentifier:REUSE_CELL_IDENTIFIER];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    NSAssert([self.view isKindOfClass:[LFBubbleCollectionView class]], @"View Controller's view is not instance of class LFBubbleCollectionView");
    NSAssert(self.bubbleView != nil, @"No bubbleView outlet is set.");
    NSAssert(self.bubbleView.dataSource == self, @"LFBubbleCollectionViewController instance is not configured as dataSource");
    NSAssert(self.bubbleView.delegate == self, @"LFBubbleCollectionViewController instance is not configured as delegate");
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFBubbleCollectionView * bubbleView = (LFBubbleCollectionView *)collectionView;
    LFBubbleCollectionViewCell *item = [bubbleView dequeueReusableCellWithReuseIdentifier:REUSE_CELL_IDENTIFIER forIndexPath:indexPath];
    [self configureItem:item forBubbleView:bubbleView atIndex:indexPath.item];
    
    //We neet to call setSelected to initialize the bubble style
    BOOL itemShouldBeHighlighted = [self bubbleView:bubbleView itemIsHighlightedAtIndex:indexPath.item];
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
    NSString* bubbleLabelText = [self bubbleView:bubbleCollectionView textForItemAtIndex:indexPath.item];
    UIFont* bubbleFont = [self bubbleView:bubbleCollectionView fontForItemAtIndex:indexPath.item];
    
    CGRect textRect = [bubbleLabelText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, itemHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:bubbleFont} context:nil];
    CGFloat currentBubbleWidth = ceilf(textRect.size.width+2*itemTextPadding);
    
    BOOL currentBubbleWidthIsLargerThanFrameWidth = currentBubbleWidth > self.bubbleView.frame.size.width-2 * itemPadding;
    if (currentBubbleWidthIsLargerThanFrameWidth) {
        // if bubble width is bigger than frame width cut it off...
        currentBubbleWidth = self.bubbleView.frame.size.width-2*itemPadding;
    }
    
    return CGSizeMake(currentBubbleWidth, itemHeight);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFBubbleCollectionViewCell* bubbleCell = (LFBubbleCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    LFBubbleCollectionView* bubbleCollectionView = (LFBubbleCollectionView*)collectionView;
    
    BOOL highlighted = !bubbleCell.isHighlighted;
    [bubbleCell setHighlighted:highlighted animated:YES];
    
    if([self bubbleView:bubbleCollectionView shouldShowMenuForBubbleItemAtIndex:indexPath.item]){
        if(highlighted) [self.bubbleView showMenuForBubbleItem:bubbleCell];
        return;
    }
    
    if(highlighted) [self bubbleView:bubbleCollectionView didSelectBubbleItemAtIndex:indexPath.item];
    else [self bubbleView:bubbleCollectionView didDeselectBubbleItemAtIndex:indexPath.item];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfBubbleItemsInBubbleView:(LFBubbleCollectionView *)collectionView];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - Controller Actions / Properties

-(LFBubbleCollectionView *)bubbleView
{
    return (LFBubbleCollectionView*) self.view;
}

-(void)insertItemAtIndex:(NSInteger)index
{
    [self.bubbleView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
}

-(void)deleteItemAtIndex:(NSInteger)index
{
    [self.bubbleView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
}

-(NSInteger)selectedItemIndex
{
    return [self.bubbleView indexPathForCell:self.bubbleView.bubbleThatIsShowingMenu].item;
}

#pragma mark - LFBubbleCollectionViewControllerDelegate forwarding methods

-(NSArray *)bubbleView:(LFBubbleCollectionView *)bubbleView menuItemsForBubbleItemAtIndex:(NSInteger)index
{
    if([self.delegate respondsToSelector:@selector(bubbleView:menuItemsForBubbleItemAtIndex:)])
        return [self.delegate bubbleView:bubbleView menuItemsForBubbleItemAtIndex:index];
        
    return nil;
}

-(void)bubbleView:(LFBubbleCollectionView *)bubbleView didHideMenuForBubbleItemAtIndex:(NSInteger)index
{
    if([self.delegate respondsToSelector:@selector(bubbleView:didHideMenuForBubbleItemAtIndex:)])
        [self.delegate bubbleView:bubbleView didHideMenuForBubbleItemAtIndex:index];
}

- (void)configureItem:(LFBubbleCollectionViewCell *)item forBubbleView:(LFBubbleCollectionView *)bubbleView atIndex:(NSInteger)index
{
    item.textLabel.font = [self bubbleView:bubbleView fontForItemAtIndex:index];
    item.textLabel.text = [self bubbleView:bubbleView textForItemAtIndex:index];
    item.textLabelPadding = self.itemTextPadding;
    
    if([self.delegate respondsToSelector:@selector(configureItem:forBubbleView:atIndex:)])
        [self.delegate configureItem:item forBubbleView:bubbleView atIndex:index];
}

-(CGFloat)itemHeight
{
    if([self.delegate respondsToSelector:@selector(itemHeight)])
        return [self.delegate itemHeight];
    
    return DEFAULT_ITEM_HEIGHT;
}

-(CGFloat)itemPadding
{
    if([self.delegate respondsToSelector:@selector(itemPadding)])
        return [self.delegate itemPadding];
    
    return DEFAULT_ITEM_PADDING;
}

-(CGFloat)itemTextPadding
{
    if([self.delegate respondsToSelector:@selector(itemTextPadding)])
        return [self.delegate itemTextPadding];
    
    return DEFAULT_ITEM_TEXT_PADDING;
}

-(void)bubbleView:(LFBubbleCollectionView *)aBubbleView didSelectBubbleItemAtIndex:(NSInteger)index
{
    if([self.delegate respondsToSelector:@selector(bubbleView:didSelectBubbleItemAtIndex:)])
        [self.delegate bubbleView:aBubbleView didSelectBubbleItemAtIndex:index];
}

-(void)bubbleView:(LFBubbleCollectionView *)bubbleView didDeselectBubbleItemAtIndex:(NSInteger)index
{
    if([self.delegate respondsToSelector:@selector(bubbleView:didDeselectBubbleItemAtIndex:)])
        [self.delegate bubbleView:bubbleView didDeselectBubbleItemAtIndex:index];
}

-(BOOL)bubbleView:(LFBubbleCollectionView *)bubbleView shouldShowMenuForBubbleItemAtIndex:(NSInteger)index
{
    if([self.delegate respondsToSelector:@selector(bubbleView:shouldShowMenuForBubbleItemAtIndex:)])
        return [self.delegate bubbleView:bubbleView shouldShowMenuForBubbleItemAtIndex:index];
    
    return NO;
}

-(BOOL)bubbleView:(LFBubbleCollectionView *)bubbleView itemIsHighlightedAtIndex:(NSInteger)index
{
    return [self.delegate bubbleView:bubbleView itemIsHighlightedAtIndex:index];
}

-(NSString*)bubbleView:(LFBubbleCollectionView *)bubbleView textForItemAtIndex:(NSInteger)index
{
    return [self.delegate bubbleView:bubbleView textForItemAtIndex:index];
}

-(UIFont*)bubbleView:(LFBubbleCollectionView *)bubbleView fontForItemAtIndex:(NSInteger)index
{
    if([self.delegate respondsToSelector:@selector(bubbleView:fontForItemAtIndex:)])
        return [self.delegate bubbleView:bubbleView fontForItemAtIndex:index];
    
    return DEFAULT_FONT;
}

-(NSUInteger)numberOfBubbleItemsInBubbleView:(LFBubbleCollectionView *)bubbleView
{
    return [self.delegate numberOfBubbleItemsInBubbleView:bubbleView];
}

@end
