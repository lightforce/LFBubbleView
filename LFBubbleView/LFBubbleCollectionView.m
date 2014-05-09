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

- (void)configureView
{
    [self configureLayout];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
    self.bounces = YES;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero collectionViewLayout:nil];
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    NHAlignmentFlowLayout* flowLayout = [[NHAlignmentFlowLayout alloc] init];
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if(self){
        [self configureView];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.collectionViewLayout = [[NHAlignmentFlowLayout alloc] init];
        [self configureView];
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
    NHAlignmentFlowLayout* flowLayout = (NHAlignmentFlowLayout*) self.collectionViewLayout;
    flowLayout.alignment = NHAlignmentTopLeftAligned;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = DEFAULT_ITEM_SIZE;
    self.collectionViewLayout = flowLayout;
}

#pragma mark - Menu Actions

-(void)showMenuForBubbleItem:(LFBubbleCollectionViewCell *)item
{
    if (item == _bubbleThatIsShowingMenu) return;
    
    NSArray *menuItems = nil;
    
    if ([_bubbleViewMenuDelegate respondsToSelector:@selector(bubbleView:menuItemsForBubbleItemAtIndex:)])
        menuItems = [_bubbleViewMenuDelegate bubbleView:self menuItemsForBubbleItemAtIndex:[self indexPathForCell:item].row];
    
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
        
        if ([_bubbleViewMenuDelegate respondsToSelector:@selector(bubbleView:didHideMenuForBubbleItemAtIndex:)])
            [_bubbleViewMenuDelegate bubbleView:self didHideMenuForBubbleItemAtIndex:[self indexPathForCell:_bubbleThatIsShowingMenu].row];
        
        _bubbleThatIsShowingMenu = nil;
    }];
    
    [menuController setTargetRect:item.frame inView:self];
    [menuController setMenuVisible:YES animated:YES];
}

@end
