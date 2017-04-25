//
//  ChooseLocationType.h
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 31/03/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseLocationDelegate <NSObject>

@optional

-(void)setMynewLocationonText : (NSString *)objLocation;

@end

@interface ChooseLocationType : UIViewController

@property(unsafe_unretained,nonatomic)id<ChooseLocationDelegate>delegate;



@end
