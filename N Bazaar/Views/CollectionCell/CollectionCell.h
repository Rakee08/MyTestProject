//
//  CollectionCell.h
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 30/03/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface CollectionCell : UICollectionViewCell
@property(weak,nonatomic)IBOutlet UILabel *objitemName;
@property(weak,nonatomic)IBOutlet AsyncImageView *objItemImage;
@end
