//
//  MyBubbleViewController.h
//  LFBubbleView
//
//  Created by Sebastian Hunkeler on 29/04/14.
//  Copyright (c) 2014 codeninja. All rights reserved.
//

#import "LFBubbleCollectionViewController.h"

@interface MyBubbleViewController : UIViewController<LFBubbleCollectionViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray* bubbleTexts;
@property (nonatomic,strong) UIFont* bubbleItemsFont;
@property (nonatomic,readonly) LFBubbleCollectionViewController* bubbleViewController;

@end
