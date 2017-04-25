//
//  MenuListCell.h
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 03/04/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MenuListCellDelegate <NSObject>

@optional

-(void)showDetails :(NSString *)objItemID;
-(void)increaseCart :(NSString *)objItemID;
-(void)decreaseCart :(NSString *)objItemID;


@end

@interface MenuListCell : UITableViewCell

@property(unsafe_unretained,nonatomic)id<MenuListCellDelegate>delegate;

-(void)setValuesforItem:(NSDictionary *)objdic;

@end
