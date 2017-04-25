//
//  MenuListCell.m
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 03/04/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//



#import "MenuListCell.h"
#import "AsyncImageView.h"
#import "Utilities.h"
#import "MarqueeLabel.h"


@interface MenuListCell(){
    
}

@property(weak, nonatomic)IBOutlet AsyncImageView *objItemImg;
@property(weak, nonatomic)IBOutlet UILabel *objOfferLbl;
@property(weak, nonatomic)IBOutlet UILabel *objTitleLbl;
@property(weak, nonatomic)IBOutlet UILabel *objdescLbl;
@property(weak, nonatomic)IBOutlet MarqueeLabel *objPriceLbl;

@property(weak, nonatomic)IBOutlet UIImageView *objDecrementImg;
@property(weak, nonatomic)IBOutlet UIButton *objDecrementBtn;
@property(weak, nonatomic)IBOutlet UILabel *objCountLbl;

@end

@implementation MenuListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _objOfferLbl.layer.borderWidth = 1.0;
    _objOfferLbl.layer.borderColor = [UIColor colorWithRed:30.0/255.0 green:155.0/255.0 blue:14.0/255.0 alpha:1.0].CGColor;
    _objOfferLbl.layer.cornerRadius = 5.0;
    _objOfferLbl.layer.masksToBounds = YES;
    
    _objDecrementImg.hidden = YES;
    _objDecrementBtn.hidden = YES;
    _objCountLbl.hidden = YES;
    
    _objPriceLbl.trailingBuffer = 20.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setValuesforItem:(NSDictionary *)objdic{
    
    if ([[objdic valueForKey:@"Offer"] boolValue]) {
        _objOfferLbl.hidden = NO;
        _objOfferLbl.text = [NSString stringWithFormat:@"%@ %%off",[objdic valueForKey:@"OfferPercentage"]];
        _objPriceLbl.text = [NSString stringWithFormat:@"₹%@",[objdic valueForKey:@"Price"]];
        
        CGFloat objoriginalprice = [[objdic valueForKey:@"Price"] floatValue];
        
        CGFloat objoffer = [[objdic valueForKey:@"OfferPercentage"] floatValue];
        
        CGFloat objpricetodetect = (objoriginalprice/ 100) * objoffer;
        
        CGFloat objdiscountedPrice = objoriginalprice - objpricetodetect;
        [self setNsartibutedstr:objoriginalprice newprice:objdiscountedPrice];
        
    }
    else{
        _objOfferLbl.hidden = YES;
        _objPriceLbl.text = [NSString stringWithFormat:@"₹%@",[objdic valueForKey:@"Price"]];
    }
    _objTitleLbl.text = [NSString stringWithFormat:@"%@",[objdic valueForKey:@"MenuName"]];
    _objdescLbl.text = [NSString stringWithFormat:@"%@",[objdic valueForKey:@"Unit"]];
    [Utilities setThumbNailImage:self.objItemImg imageUrlString:[objdic valueForKey:@"ImgURL"] thumbImage:NO];
    
}

-(void)setNsartibutedstr :(CGFloat )objoldprice newprice:(CGFloat )objnewPrice{
    
    NSString *myoldString = [NSString stringWithFormat:@"₹%.2f",objoldprice];
    NSString *myNewString = [NSString stringWithFormat:@"₹%.2f",objnewPrice];
    

    NSString *myString = [NSString stringWithFormat:@"%@  %@",myoldString,myNewString];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
    NSRange range = [myString rangeOfString:[NSString stringWithFormat:@"%@",myoldString]
 ];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    [attString addAttribute:NSStrikethroughStyleAttributeName value:(NSNumber *)kCFBooleanTrue range:range];
    _objPriceLbl.attributedText = attString;
    
}
-(IBAction)didClickShowDetails:(id)sender{
    [self.delegate showDetails:@""];
}
-(IBAction)didClickIncrease:(id)sender{
    [self.delegate increaseCart:@""];

}
-(IBAction)didClickDecrease:(id)sender{
    
}

@end
