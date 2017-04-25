//
//  Utilities.h
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 30/03/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncImageView.h"


@interface Utilities : NSObject


+(void) showLoadingWithText:(NSString *)string;
+(void) hideLoading;
+(void) showInfo:(NSString*)errorInfo;
+(void) showalertwithMessage:(NSString *)objmessage;
+(void)displayMenuViewSelectedControllers:(id)controller index:(NSInteger)index;
+(void)setThumbNailImage:(AsyncImageView *)objImageView imageUrlString:(NSString *)objImageURL thumbImage:(BOOL)thumbImage;


@end
