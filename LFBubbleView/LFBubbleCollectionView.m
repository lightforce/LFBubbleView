//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import "LFBubbleCollectionView.h"
#import "NHAlignmentFlowLayout.h"

@interface LFBubbleCollectionView ()
@property (nonatomic, strong) NHAlignmentFlowLayout *flowLayout;
@end

@implementation LFBubbleCollectionView
{
    UIMenuController *_menuController;
}

#pragma mark - Memory Management

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialization

- (void)configureLayout
{
    self.flowLayout = [[NHAlignmentFlowLayout alloc] init];
    self.flowLayout.alignment = NHAlignmentTopLeftAligned;
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.flowLayout setItemSize:CGSizeMake(100.0, 25.0)];
    [self setCollectionViewLayout:self.flowLayout];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _selectionStyle = HEBubbleViewSelectionStyleDefault;                
        [self configureLayout];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        self.bounces = YES;
    }
    
    return  self;
}

#pragma mark - Bubble Item Delegate

-(BOOL)shouldHighlight:(LFBubbleViewCell *)item
{
    switch (_selectionStyle) {
        case HEBubbleViewSelectionStyleDefault:
            return YES;
        case HEBubbleViewSelectionStyleNone:
            return  NO;
        default:
            return YES;
    }
}

-(void)deselectedBubbleItem:(LFBubbleViewCell *)item
{
    if ([_bubbleDelegate respondsToSelector:@selector(bubbleView:didDeselectBubbleItemAtIndex:)]) {
        [_bubbleDelegate bubbleView:self didDeselectBubbleItemAtIndex:[self indexPathForCell:item].row];
    }
}

-(void)selectedBubbleItem:(LFBubbleViewCell *)item
{
    if (item == _activeBubble) return;
    
    if ([_bubbleDelegate respondsToSelector:@selector(bubbleView:didSelectBubbleItemAtIndex:)]) {
        [_bubbleDelegate bubbleView:self didSelectBubbleItemAtIndex:[self indexPathForCell:item].row];
    }
    
    if ([_bubbleDelegate respondsToSelector:@selector(bubbleView:shouldShowMenuForBubbleItemAtIndex:)]) {
        
        if ([_bubbleDelegate bubbleView:self shouldShowMenuForBubbleItemAtIndex:[self indexPathForCell:item].row]) {
            
            NSArray *menuItems = nil;
            
            if ([_bubbleDelegate respondsToSelector:@selector(bubbleView:menuItemsForBubbleItemAtIndex:)]) {
                menuItems = [_bubbleDelegate bubbleView:self menuItemsForBubbleItemAtIndex:[self indexPathForCell:item].row];
            }
            
            if (menuItems) {
                [self showMenuCalloutWthItems:menuItems forBubbleItem:item];
            }
        }
    }
}

#pragma mark - Bubble Item Delegate

-(BOOL)canBecomeFirstResponder
{
    return YES;
}
 
-(void)willShowMenuController
{
    self.userInteractionEnabled = NO;
}

-(void)didHideMenuController
{
    self.userInteractionEnabled = YES;
    [_activeBubble setSelected:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([_bubbleDelegate respondsToSelector:@selector(bubbleView:didHideMenuForBubbleItemAtIndex:)]) {
        [_bubbleDelegate bubbleView:self didHideMenuForBubbleItemAtIndex:[self indexPathForCell:_activeBubble].row];
    }
    _activeBubble = nil;
}

-(void)showMenuCalloutWthItems:(NSArray *)menuItems forBubbleItem:(LFBubbleViewCell *)item
{
    [self becomeFirstResponder];
    
    _activeBubble = item;
    _menuController = [UIMenuController sharedMenuController];
    _menuController.menuItems = nil;
    _menuController.menuItems = menuItems;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowMenuController) name:UIMenuControllerWillShowMenuNotification object:_menuController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideMenuController) name:UIMenuControllerDidHideMenuNotification object:_menuController];
    
    [_menuController setTargetRect:item.frame inView:self];
    [_menuController setMenuVisible:YES animated:YES];
}

@end
