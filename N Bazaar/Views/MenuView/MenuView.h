//
//  MenuView.h
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 30/03/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MenuViewDelegete <NSObject>
@optional

-(void)getSelectedMenuDetails:(NSInteger)selectedValues;
-(void)displayToUpdateProfile;

@end

@interface MenuView : UIView


@property(unsafe_unretained,nonatomic)id<MenuViewDelegete>delegate;

-(instancetype)initWithFrame:(CGRect)frame;


@end
