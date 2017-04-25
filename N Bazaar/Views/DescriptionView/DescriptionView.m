//
//  DescriptionView.m
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 05/04/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import "DescriptionView.h"

@interface DescriptionView(){
    BOOL isExpanded;
}

@property(weak, nonatomic)IBOutlet UIView *objMainView;
@property(weak, nonatomic)IBOutlet UILabel *objDescription;
@property(weak, nonatomic)IBOutlet UILabel *objTitle;
@property(weak, nonatomic)IBOutlet UIImageView *objArrow;
@property(weak, nonatomic)IBOutlet UIButton *objExpandBtn;


@end

@implementation DescriptionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle]loadNibNamed:@"DescriptionView" owner:self options:nil];
        self.objMainView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.objMainView];
    }
    
    return self;
}


-(IBAction)didclickShowFullDesc:(id)sender{
    if (!isExpanded) {
        isExpanded = YES;
        [UIView animateWithDuration:0.4 animations:^{
            CGSize size = [_objDescription sizeThatFits:CGSizeMake(_objDescription.frame.size.width, CGFLOAT_MAX)];
            CGRect frame = _objDescription.frame;
            frame.size.height = size.height + 10;
            _objDescription.frame = frame;
            [_objArrow setTransform:CGAffineTransformMakeRotation(M_PI)];
            [self.delegate disPlayFullDescription:self.objDescription];
        }completion:^(BOOL finished) {
        }];
    }
    else{
        isExpanded = NO;
        [UIView animateWithDuration:0.4 animations:^{
            [_objArrow setTransform:CGAffineTransformMakeRotation(0)];
            CGSize size = [_objDescription sizeThatFits:CGSizeMake(_objDescription.frame.size.width, 25)];
            CGRect frame = _objDescription.frame;
            frame.size.height = size.height;
            _objDescription.frame = frame;
            [self.delegate collapseDescription:self.objDescription];
        }completion:^(BOOL finished) {
            
        }];
    }
}



-(void)setValues:(NSString *)objtitle description:(NSString *)objdesc{
    
    _objTitle.text = objtitle;
    _objDescription.text = objdesc;
    
    CGSize size = [_objDescription sizeThatFits:CGSizeMake(_objDescription.frame.size.width, CGFLOAT_MAX)];
    CGRect frame = _objDescription.frame;
    frame.size.height = size.height;
    
    
    
    
    if ([objtitle isEqualToString:@"Description"]) {
        _objArrow.hidden = NO;
        _objExpandBtn.hidden = NO;
        
        if (_objDescription.text.length < 40) {
            _objArrow.hidden = YES;
            _objExpandBtn.hidden = YES;
        }
        else{
            _objArrow.hidden = NO;
            _objExpandBtn.hidden = NO;
        }
        
    }
    else{
        _objArrow.hidden = YES;
        _objExpandBtn.hidden = YES;
    }
    
}



@end
