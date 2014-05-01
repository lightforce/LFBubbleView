//
//  MyBubbleViewController.m
//  LFBubbleView
//
//  Created by Sebastian Hunkeler on 29/04/14.
//  Copyright (c) 2014 codeninja. All rights reserved.
//

#import "MyBubbleViewController.h"

@implementation MyBubbleViewController
{
    NSMutableDictionary* _selectedItems;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        _bubbleItemsFont = [UIFont fontWithName:@"Avenir-Light" size:13.0];
        _bubbleTexts = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - 

-(LFBubbleCollectionViewController*)bubbleViewController
{
    return self.childViewControllers.firstObject;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectedItems = [NSMutableDictionary dictionary];
    UIBarButtonItem *addItemButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItemToEndOfList)];
    self.navigationItem.leftBarButtonItem = addItemButton;
    self.bubbleViewController.delegate = self;
}

#pragma mark - Delete / Insert Items

-(void)addItemToEndOfList
{
    NSInteger index = [self.bubbleTexts count];
    NSString* label = index % 2 == 0 ? [NSString stringWithFormat:@"Another item %i", index + 1 ] : [NSString stringWithFormat:@"Item %i", index + 1];
    
    [self.bubbleTexts insertObject:label atIndex:index];
    [self.bubbleViewController insertItemAtIndex:index];
}

-(void)deleteSelectedBubble:(id)sender
{
    NSInteger selectedBubbleIndex = self.bubbleViewController.selectedItemIndex;
    [self.bubbleTexts removeObjectAtIndex:selectedBubbleIndex];
    [self.bubbleViewController deleteItemAtIndex:selectedBubbleIndex];
}

-(void)inserLeft:(id)sender
{
    NSInteger selectedBubbleIndex = self.bubbleViewController.selectedItemIndex;

    [self.bubbleTexts insertObject:[NSString stringWithFormat:@"Item %i", self.bubbleTexts.count + 1 ] atIndex:selectedBubbleIndex];
    [self.bubbleViewController insertItemAtIndex:selectedBubbleIndex];
}

-(void)insertRight:(id)sender
{
    NSInteger selectedBubbleIndex = self.bubbleViewController.selectedItemIndex;
    NSInteger index = selectedBubbleIndex + 1;
    [self.bubbleTexts insertObject:[NSString stringWithFormat:@"Item %i", self.bubbleTexts.count + 1 ] atIndex:index];
    [self.bubbleViewController insertItemAtIndex:index];
}

#pragma mark - LFBubbleViewDelegate

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

#pragma mark - LFBubbleViewControllerDelegate

- (void)configureItem:(LFBubbleCollectionViewCell *)item forBubbleView:(LFBubbleCollectionView *)bubbleView atIndex:(NSInteger)index
{
    item.selectedBGColor = [UIColor colorWithRed:92/255.0 green:193/255.0 blue:0 alpha:1];
    item.unselectedBGColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    item.selectedTextColor = [UIColor colorWithWhite:0.98 alpha:1.0];
    item.unselectedTextColor = [UIColor colorWithWhite:0.1 alpha:1.0];
}

-(BOOL)bubbleView:(LFBubbleCollectionView *)bubbleView shouldShowMenuForBubbleItemAtIndex:(NSInteger)index
{
    return index % 2 == 0;
}

-(void)bubbleView:(LFBubbleCollectionView *)aBubbleView didSelectBubbleItemAtIndex:(NSInteger)index
{
    NSLog(@"selected bubble at index %d", index);
    _selectedItems[[self bubbleView:aBubbleView textForItemAtIndex:index]] = @YES;
}

-(void)bubbleView:(LFBubbleCollectionView *)bubbleView didDeselectBubbleItemAtIndex:(NSInteger)index
{
    NSLog(@"deselected bubble at index %d", index);
    [_selectedItems removeObjectForKey:[self bubbleView:bubbleView textForItemAtIndex:index]];
}

-(BOOL)bubbleView:(LFBubbleCollectionView *)bubbleView itemIsHighlightedAtIndex:(NSInteger)index
{
    return _selectedItems[[self bubbleView:bubbleView textForItemAtIndex:index]] ? [_selectedItems[[self bubbleView:bubbleView textForItemAtIndex:index]] boolValue] : NO;
}

-(NSString*)bubbleView:(LFBubbleCollectionView *)bubbleView textForItemAtIndex:(NSInteger)index
{
    return _bubbleTexts[index];
}

-(UIFont*)bubbleView:(LFBubbleCollectionView *)bubbleView fontForItemAtIndex:(NSInteger)index
{
    return _bubbleItemsFont;
}

-(NSUInteger)numberOfBubbleItemsInBubbleView:(LFBubbleCollectionView *)bubbleView
{
    return _bubbleTexts.count;
}

@end
