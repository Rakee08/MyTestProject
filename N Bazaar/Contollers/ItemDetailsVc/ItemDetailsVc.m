//
//  ItemDetailsVc.m
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 04/04/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import "ItemDetailsVc.h"
#import "MarqueeLabel.h"
#import "AsyncImageView.h"
#import "Utilities.h"
#import "DescriptionView.h"
#import "EXPhotoViewer.h"




@interface ItemDetailsVc ()<DescriptionViewDelegete>{
    NSArray *objCatagoryArray;
    NSString *objCategoryName;
    DescriptionView *objdescView;
    DescriptionView *objUnitView;
}

@property(weak, nonatomic)IBOutlet MarqueeLabel *objHeader;
@property(weak, nonatomic)IBOutlet AsyncImageView *objItemimg;
@property(weak, nonatomic)IBOutlet UILabel *objTitleLbl;
@property(weak, nonatomic)IBOutlet UILabel *objPriceLbl;
@property(weak, nonatomic)IBOutlet UIScrollView *objUnitBtnContainer;
@property(weak, nonatomic)IBOutlet UIView *objDescriptionContainer;
@property(weak, nonatomic)IBOutlet UIScrollView *objScrollview;



@end

@implementation ItemDetailsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self parseJsonFile];
}

-(void)parseJsonFile{
    NSError *error;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"CategoryList" ofType:@"json"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
    NSDictionary *jsonDic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    objCatagoryArray = [jsonDic valueForKey:@"CategoryList"];
    _objHeader.trailingBuffer = 20.0;
    [self initiateViews];
}


-(void)initiateViews{
    
    NSDictionary *objdic = [objCatagoryArray objectAtIndex:_objid];
    
    _objHeader.text = [objdic valueForKey:@"MenuName"];
    [Utilities setThumbNailImage:_objItemimg imageUrlString:[objdic valueForKey:@"ImgURL"] thumbImage:NO];
    _objTitleLbl.text = [objdic valueForKey:@"MenuName"];
    
    CGFloat objoriginalprice = [[objdic valueForKey:@"Price"] floatValue];
    
    CGFloat objoffer = [[objdic valueForKey:@"OfferPercentage"] floatValue];
    
    CGFloat objpricetodetect = (objoriginalprice/ 100) * objoffer;
    
    CGFloat objdiscountedPrice = objoriginalprice - objpricetodetect;
    [self setNsartibutedstr:objoriginalprice newprice:objdiscountedPrice];
    
    NSArray *objunitArray = [objdic valueForKey:@"Weight"];
    
    CGFloat xPos = 8;
    
    for (NSString *objunit in objunitArray) {
        UIButton *objBtn = [[UIButton alloc]initWithFrame:CGRectMake(xPos, 10, 60, 30)];
        [objBtn setTitle:objunit forState:UIControlStateNormal];
        objBtn.layer.cornerRadius = 5.0;
        objBtn.layer.masksToBounds = YES;
        objBtn.layer.borderWidth = 1.0;
        
        objBtn.titleLabel.font = [UIFont systemFontOfSize:14];

        
         if (xPos == 8) {
            objBtn.layer.borderColor = [UIColor colorWithRed:0/255.0 green:80/255.0 blue:120/255.0 alpha:1.0].CGColor;
            [objBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:80/255.0 blue:120/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        else{
            objBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [objBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        [self.objUnitBtnContainer addSubview:objBtn];
        xPos += 68;
    }
    
    CGFloat objwidth = (objunitArray.count * 60) + ((objunitArray.count+1)*8);
    [_objUnitBtnContainer setContentSize:CGSizeMake(objwidth , 50)];
    
    
    NSString *objunit = [objdic valueForKey:@"Unit"];
    NSString *objContent = [objdic valueForKey:@"Contents"];
    
    objdescView = [[DescriptionView alloc] initWithFrame:CGRectMake(0, 41, self.view.frame.size.width, 70)];
    [objdescView setValues:@"Description" description:objContent];
    objdescView.delegate = self;
    [self.objDescriptionContainer addSubview:objdescView];
    
    objUnitView = [[DescriptionView alloc] initWithFrame:CGRectMake(0, 112, self.view.frame.size.width, 70)];
    [objUnitView setValues:@"Unit" description:objunit];
    [self.objDescriptionContainer addSubview:objUnitView];
    
}


-(void)disPlayFullDescription:(UILabel *)objview{
    
    CGFloat objnewheigt = objview.frame.size.height - 25;
    
    [UIView animateWithDuration:0.4 animations:^{
        [objdescView setFrame:CGRectMake(objdescView.frame.origin.x, objdescView.frame.origin.y, objdescView.frame.size.width, objdescView.frame.size.height + objnewheigt)];
    [objUnitView setFrame:CGRectMake(objUnitView.frame.origin.x, objUnitView.frame.origin.y +objnewheigt, objUnitView.frame.size.width, objUnitView.frame.size.height)];
        [self.objDescriptionContainer setFrame:CGRectMake(self.objDescriptionContainer.frame.origin.x, self.objDescriptionContainer.frame.origin.y, self.objDescriptionContainer.frame.size.width, self.objDescriptionContainer.frame.size.height + objnewheigt )];
        [self.objScrollview setContentSize:CGSizeMake(self.objScrollview.frame.size.width,470+self.objDescriptionContainer.frame.size.height)];
    
    }completion:^(BOOL finished) {
    }];
   
}

-(void)collapseDescription:(UILabel *)objview{
    
    CGFloat objnewheigt = 69;
    [UIView animateWithDuration:0.4 animations:^{
        [objdescView setFrame:CGRectMake(objdescView.frame.origin.x, objdescView.frame.origin.y, objdescView.frame.size.width, objnewheigt)];
        [objUnitView setFrame:CGRectMake(objUnitView.frame.origin.x, 40 + objnewheigt + 2, objUnitView.frame.size.width, objUnitView.frame.size.height)];
        [self.objDescriptionContainer setFrame:CGRectMake(self.objDescriptionContainer.frame.origin.x, self.objDescriptionContainer.frame.origin.y, self.objDescriptionContainer.frame.size.width, objUnitView.frame.size.height + objdescView.frame.size.height + 42)];
        [self.objScrollview setContentSize:CGSizeMake(self.objScrollview.frame.size.width,470+self.objDescriptionContainer.frame.size.height)];

    }completion:^(BOOL finished) {
    }];
    
    
}


-(void)setNsartibutedstr :(CGFloat )objoldprice newprice:(CGFloat )objnewPrice{
    NSString *myoldString = [NSString stringWithFormat:@"₹%.2f",objoldprice];
    NSString *myNewString = [NSString stringWithFormat:@"  ₹%.2f",objnewPrice];

    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:myoldString attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName : [UIColor lightGrayColor]}];

    
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:myNewString attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone]}];

    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] init];
    [labelString appendAttributedString:str1];
    [labelString appendAttributedString:str2];
    _objPriceLbl.numberOfLines = 0;
    _objPriceLbl.attributedText = labelString;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)didClickFullscreenImg:(id)sender{
    [EXPhotoViewer showImageFrom:self.objItemimg];

}



@end
