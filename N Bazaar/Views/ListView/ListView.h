//
//  ListView.h
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 30/03/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ListViewDelegate <NSObject>
-(void)getView:(id)sender;
-(void)didSelectatindex:(NSIndexPath *)objindex;


@end
@interface ListView : UIView
@property(weak,nonatomic)IBOutlet UIView *objMainView;
@property(weak,nonatomic)IBOutlet UIButton *objArrowOutlet;
@property(weak,nonatomic)IBOutlet UIImageView *objThumbImg;
@property(weak,nonatomic)IBOutlet NSLayoutConstraint *objCollectionViewHeight;
@property(unsafe_unretained,nonatomic)id <ListViewDelegate> delegate;
@property(weak,nonatomic)IBOutlet UICollectionView *collectionView;
@property(weak,nonatomic)IBOutlet UILabel *objtitle;
@property(weak,nonatomic)IBOutlet UILabel *objDescription;
-(void)getValuesFromDic:(NSDictionary *)objDic;
@end
