//
//  Constant.h
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 29/03/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define Current_Lat @"CurrentLatitude"
#define Current_Long @"CurrentLongitude"


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define isiPhone6AndAbove  ([[UIScreen mainScreen] bounds].size.height >= 667)?TRUE:FALSE
#define isiPhone4  ([[UIScreen mainScreen] bounds].size.height == 480)?TRUE:FALSE
#define isiPhone5s  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define isBelow4inch ([[UIScreen mainScreen] bounds].size.height <= 568)?TRUE:FALSE

#define isiPhone6_7  ([[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE
#define isiPhone6Plus_7Plus  ([[UIScreen mainScreen] bounds].size.height == 736)?TRUE:FALSE

#define IS_iOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0) ? YES:NO)
#define IS_iOS8AndAbove (([[[UIDevice currentDevice] systemVersion] floatValue] > 7.1) ? YES:NO)
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
#define IS_OS_10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] > 10.0



#endif /* Constant_h */
