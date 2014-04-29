//  Created by Sebastian Hunkeler on 19.07.12.
//  Copyright (c) 2014 Sebastian Hunkeler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBubbleCollectionView.h"

/*
 Always implement the DataSource, Delegate is optional, though menu callouts are only possible when implementing the deleagate
 */
@interface LFBubbleViewController : UIViewController <LFBubbleViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property IBOutlet LFBubbleCollectionView *bubbleView;

@end
