//
//  CollectionCell.m
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 30/03/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray *resultantNibs = [[NSBundle mainBundle] loadNibNamed:@"CollectionCell" owner:nil options:nil];
        self = [resultantNibs objectAtIndex:0];
    }
    return self;    
}





@end
