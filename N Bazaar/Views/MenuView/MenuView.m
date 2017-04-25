//
//  MenuView.m
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 30/03/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import "MenuView.h"
#import "Constant.h"




@interface MenuView(){
    
    NSMutableArray *objInfodata;
    NSMutableArray *objInfoicons;
    NSMutableArray *objOthersdata;
    NSMutableArray *objOthersicons;
    
}

@property(weak, nonatomic)IBOutlet UIView *objMainView;
@property(weak, nonatomic)IBOutlet UITableView *objInfoTableView;
@property(weak, nonatomic)IBOutlet UITableView *objOthersTableView;
@property(weak, nonatomic)IBOutlet UIScrollView *objScrollView;


@end

@implementation MenuView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle]loadNibNamed:@"MenuView" owner:self options:nil];
        self.objMainView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.objMainView];
    }
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 10);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 5.0;
    
    //LoggedUser
    
    NSString *objLoggeduser = [[NSUserDefaults standardUserDefaults]valueForKey:@"LoggedUser"];
    
    objInfodata= [[NSMutableArray alloc]initWithObjects:(objLoggeduser)?@"Logout":@"Login",@"My Addresses",@"My Orders",nil];
    objInfoicons= [[NSMutableArray alloc]initWithObjects:@"Login",@"My Addresses",@"My Orders",nil];
    
    objOthersdata = [[NSMutableArray alloc]initWithObjects:@"Share",@"About us",@"About this release",nil];
    objOthersicons = [[NSMutableArray alloc]initWithObjects:@"Share",@"About us",@"About this release",nil];
    
    self.objScrollView.scrollEnabled = NO;
    
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _objInfoTableView) {
        return [objInfodata count];
    }
    else{
        return [objOthersdata count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        UIImageView *objImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15,(IS_IPAD)?18:14, 18, 18)];
        objImgView.tag=20;
        
        [cell addSubview:objImgView];
        
        UILabel *objTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50,(IS_IPAD)?15: 8, 200, 30)];
        objTitleLabel.tag=21;
        [cell addSubview:objTitleLabel];
        
    }
    UIImageView *objImageView=(UIImageView *)[cell viewWithTag:20];
    UILabel *objTitleLabel=(UILabel *)[cell viewWithTag:21];
    objTitleLabel.textAlignment=NSTextAlignmentLeft;
    if (IS_IPAD) {
        objTitleLabel.font = [UIFont systemFontOfSize:20];
    }
    else{
        objTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    objTitleLabel.textColor=[UIColor darkTextColor];

    if (tableView == _objInfoTableView) {
    objTitleLabel.text = [objInfodata objectAtIndex:indexPath.row];
    objImageView.image=[UIImage imageNamed:[objInfoicons objectAtIndex:indexPath.row]];
    }
    else{
        objTitleLabel.text = [objOthersdata objectAtIndex:indexPath.row];
        objImageView.image=[UIImage imageNamed:[objOthersicons objectAtIndex:indexPath.row]];
    }
    [tableView setSeparatorInset:UIEdgeInsetsZero];

    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate getSelectedMenuDetails:indexPath.row];
    [self removeFromSuperview];
}


@end
