//
//  DescriptionView.h
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 05/04/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DescriptionViewDelegete <NSObject>
@optional

-(void)disPlayFullDescription:(UILabel *)objview;
-(void)collapseDescription:(UILabel *)objview;

@end

@interface DescriptionView : UIView

@property(unsafe_unretained,nonatomic)id<DescriptionViewDelegete>delegate;
-(void)setValues:(NSString *)objtitle description:(NSString *)objdesc;

@end
