//
//  LoginVc.m
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 31/03/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import "LoginVc.h"
#import "OTPVc.h"

@interface LoginVc ()

@property(weak, nonatomic)IBOutlet  UIButton *objNextBtn;
@end

@implementation LoginVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame=self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.0/255.0 green:80.0/255.0 blue:120.0/255.0 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:20.0/255.0 green:42.0/255.0 blue:74.0/255.0 alpha:1.0] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    self.objNextBtn.layer.cornerRadius = 5.0;
    self.objNextBtn.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didclickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



-(IBAction)didclickNext:(id)sender{
    
    OTPVc *objOtpVc = [self.storyboard instantiateViewControllerWithIdentifier:@"OTPVcID"];
    [self.navigationController pushViewController:objOtpVc animated:YES];
}
@end
