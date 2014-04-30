//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.

#import "LFBubbleCollectionView.h"
#import "NHAlignmentFlowLayout.h"

#define DEFAULT_ITEM_SIZE CGSizeMake(100.0, 25.0)

@implementation LFBubbleCollectionView
{
    id _willShowMenuNotificationObserver;
    id _didHideMenuObserver;
}

#pragma mark - Memory Management

-(void)dealloc
{
    [self deregisterNotificationObservers];
}

#pragma mark - Initialization

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self configureLayout];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        self.bounces = YES;
    }    
    return  self;
}

#pragma mark - 

- (void)deregisterNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:_willShowMenuNotificationObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_didHideMenuObserver];
}

- (void)configureLayout
{
    NHAlignmentFlowLayout* flowLayout = [[NHAlignmentFlowLayout alloc] init];
    flowLayout.alignment = NHAlignmentTopLeftAligned;
    //UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = DEFAULT_ITEM_SIZE;
    self.collectionViewLayout = flowLayout;
}

#pragma mark - Menu Actions

-(void)showMenuForBubbleItem:(LFBubbleCollectionViewCell *)item
{
    if (item == _bubbleThatIsShowingMenu) return;
    
    NSArray *menuItems = nil;
    
    if ([_bubbleViewDelegate respondsToSelector:@selector(bubbleView:menuItemsForBubbleItemAtIndex:)])
        menuItems = [_bubbleViewDelegate bubbleView:self menuItemsForBubbleItemAtIndex:[self indexPathForCell:item].row];
    
    if (menuItems)
        [self showMenuCalloutWthItems:menuItems forBubbleItem:item];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)showMenuCalloutWthItems:(NSArray *)menuItems forBubbleItem:(LFBubbleCollectionViewCell *)item
{
    [self becomeFirstResponder];
    
    _bubbleThatIsShowingMenu = item;
    UIMenuController* menuController = [UIMenuController sharedMenuController];
    menuController.menuItems = menuItems;
    
    _willShowMenuNotificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIMenuControllerWillShowMenuNotification object:menuController queue:nil usingBlock:^(NSNotification *note) {
         self.userInteractionEnabled = NO;
    }];
    
    _didHideMenuObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIMenuControllerDidHideMenuNotification object:menuController queue:nil usingBlock:^(NSNotification *note) {
        self.userInteractionEnabled = YES;
        [_bubbleThatIsShowingMenu setHighlighted:NO animated:YES];
        [self deregisterNotificationObservers];
        
        if ([_bubbleViewDelegate respondsToSelector:@selector(bubbleView:didHideMenuForBubbleItemAtIndex:)])
            [_bubbleViewDelegate bubbleView:self didHideMenuForBubbleItemAtIndex:[self indexPathForCell:_bubbleThatIsShowingMenu].row];
        
        _bubbleThatIsShowingMenu = nil;
    }];
    
    [menuController setTargetRect:item.frame inView:self];
    [menuController setMenuVisible:YES animated:YES];
}

@end
