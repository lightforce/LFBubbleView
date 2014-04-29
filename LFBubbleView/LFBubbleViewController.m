//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import "LFBubbleViewController.h"

#define ITEM_PADDING 10
#define ITEM_HEIGHT 25
#define ITEM_TEXT_PADDING 15

@implementation LFBubbleViewController
{
    NSMutableArray *_bubbleTexts;
    UIFont* _bubbleItemsFont;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _bubbleItemsFont = [UIFont fontWithName:@"Avenir-Light" size:13.0];
    [_bubbleView registerClass:[LFBubbleViewCell class] forCellWithReuseIdentifier:@"BubbleCell"];
    _bubbleTexts = [[NSMutableArray alloc] init];
    _bubbleView.selectionStyle = HEBubbleViewSelectionStyleDefault;
    
    UIBarButtonItem *addItemButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItemToEndOfList)];
    self.navigationItem.leftBarButtonItem = addItemButton;
}

#pragma mark - Delete / Insert Items

-(void)addItemToEndOfList
{
    NSInteger index = [_bubbleTexts count];
    NSString* label = index % 2 == 0 ? [NSString stringWithFormat:@"Another item %i", index + 1 ] : [NSString stringWithFormat:@"Item %i", index + 1];

    // ALWAYS: first add data to your data source, then call addItem on the bubble view
    [_bubbleTexts insertObject:label atIndex:index];
    [_bubbleView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
}

-(void)deleteSelectedBubble:(id)sender
{
    NSIndexPath* selectedBubbleIndexPath = [_bubbleView indexPathForCell:_bubbleView.activeBubble];
    [_bubbleTexts removeObjectAtIndex:selectedBubbleIndexPath.row];
    [_bubbleView deleteItemsAtIndexPaths:@[selectedBubbleIndexPath]];
}

-(void)inserLeft:(id)sender
{
    NSIndexPath* selectedBubbleIndexPath = [_bubbleView indexPathForCell:_bubbleView.activeBubble];
    [_bubbleTexts insertObject:[NSString stringWithFormat:@"Item %i", _bubbleTexts.count + 1 ] atIndex:selectedBubbleIndexPath.row];
    [_bubbleView insertItemsAtIndexPaths:@[selectedBubbleIndexPath]];
}

-(void)insertRight:(id)sender
{
    NSIndexPath* selectedBubbleIndexPath = [_bubbleView indexPathForCell:_bubbleView.activeBubble];
    NSInteger index = selectedBubbleIndexPath.row+1;    
    [_bubbleTexts insertObject:[NSString stringWithFormat:@"Item %i", _bubbleTexts.count + 1 ] atIndex:index];
    [_bubbleView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
}

#pragma mark - HEBubbleViewDataSource

-(NSInteger)numberOfItemsInBubbleView:(LFBubbleCollectionView *)bubbleView
{
    return _bubbleTexts.count;
}

#pragma mark -

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFBubbleViewCell* cell = (LFBubbleViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     LFBubbleViewCell* cell = (LFBubbleViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return ITEM_PADDING;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemHeight = ITEM_HEIGHT;
    CGFloat itemPadding = ITEM_PADDING;
    CGFloat itemTextPadding = ITEM_TEXT_PADDING;
    NSString* bubbleLabelText = _bubbleTexts[indexPath.row];
    
    CGFloat currentBubbleWidth = [bubbleLabelText sizeWithFont:_bubbleItemsFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, itemHeight)].width+2*itemTextPadding;
    
    BOOL currentBubbleWidthIsLargerThanFrameWidth = currentBubbleWidth >= self.bubbleView.frame.size.width-2 * itemPadding;
    if (currentBubbleWidthIsLargerThanFrameWidth) {
        // if bubble width is bigger than frame width cut it off...
        currentBubbleWidth = self.bubbleView.frame.size.width-2*itemPadding;
    }    
    
    return CGSizeMake(currentBubbleWidth, itemHeight);
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _bubbleTexts.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFBubbleViewCell *item = [_bubbleView dequeueReusableCellWithReuseIdentifier:@"BubbleCell" forIndexPath:indexPath];
    item.delegate = self.bubbleView;
    item.textLabel.font = _bubbleItemsFont;
    item.selectedBGColor = [UIColor colorWithRed:92/255.0 green:193/255.0 blue:0 alpha:1];
    item.unselectedBGColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    item.selectedTextColor = [UIColor colorWithWhite:0.98 alpha:1.0];
    item.unselectedTextColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    item.selectedBorderColor = item.selectedBGColor;
    item.unselectedBorderColor = item.unselectedBGColor;
    item.highlightTouches = NO;
    item.bubbleTextLabelPadding = ITEM_TEXT_PADDING;
    
     //We neet to call setSelected to initialize the bubble style
    [item setSelected:item.isSelected animated:NO];
    item.highlightTouches = self.bubbleView.selectionStyle != HEBubbleViewSelectionStyleNone;
    
    item.textLabel.text = _bubbleTexts[indexPath.row];
    return item;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark - LFBubbleViewDelegate

-(void)bubbleView:(LFBubbleCollectionView *)aBubbleView didSelectBubbleItemAtIndex:(NSInteger)index
{
    NSLog(@"selected bubble at index %d", index);
}

-(void)bubbleView:(LFBubbleCollectionView *)bubbleView didDeselectBubbleItemAtIndex:(NSInteger)index
{
    NSLog(@"deselected bubble at index %d", index);
}

-(BOOL)bubbleView:(LFBubbleCollectionView *)bubbleView shouldShowMenuForBubbleItemAtIndex:(NSInteger)index
{
    return NO;
}

-(BOOL)canBecomeFirstResponder
{
    NSLog(@"Asking %@ if it can become first responder",[self class]);
    return YES;
}

/*
 Create the menu items you want to show in the callout and return them. Provide selectors
 that are implemented in your bubbleview delegate. override canBecomeFirstResponder and return
 YES, otherwise menu will not be shown
*/
-(NSArray *)bubbleView:(LFBubbleCollectionView *)bubbleView menuItemsForBubbleItemAtIndex:(NSInteger)index
{
    UIMenuItem *item0 = [[UIMenuItem alloc] initWithTitle:@"Delete item" action:@selector(deleteSelectedBubble:)];
    UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"Insert Left" action:@selector(inserLeft:)];
    UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"Insert Right" action:@selector(insertRight:)];
    return @[item1,item0,item2];
}

-(void)bubbleView:(LFBubbleCollectionView *)bubbleView didHideMenuForBubbleItemAtIndex:(NSInteger)index
{
    NSLog(@"Did hide menu for bubble at index %i",index);
}

@end
