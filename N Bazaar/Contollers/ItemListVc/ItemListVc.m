

//
//  ItemListVc.m
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 03/04/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import "ItemListVc.h"
#import "MenuListCell.h"
#import "ItemDetailsVc.h"

@interface ItemListVc ()<MenuListCellDelegate>{
   NSArray *objCatagoryArray;
   NSString *objCategoryName;
}

@property(weak, nonatomic)IBOutlet UITableView *tableView;
@property(weak, nonatomic)IBOutlet UILabel *objHeaderLbl;


@end

@implementation ItemListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self parseJsonFile];
    [self setTableHeader];
}

-(void)parseJsonFile{
    NSError *error;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"CategoryList" ofType:@"json"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
    NSDictionary *jsonDic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    objCatagoryArray = [jsonDic valueForKey:@"CategoryList"];
    objCategoryName = [jsonDic valueForKey:@"CategoryName"];
    
    self.objHeaderLbl.text = objCategoryName;
    
}

-(void)setTableHeader{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width,40)];
    headerView.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, headerView.frame.size.width-20, headerView.frame.size.height)];
    labelView.text = [NSString stringWithFormat:@"%@ contains %lu item(s)",objCategoryName,(unsigned long)objCatagoryArray.count];;
    labelView.textColor = [UIColor grayColor];
    [headerView addSubview:labelView];
    
    UIView *subHeader = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width,40)];
    subHeader.backgroundColor = [UIColor colorWithRed:0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
    
    self.tableView.tableHeaderView = headerView;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didClickBacl:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [objCatagoryArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *simpleTableIdentifier = @"MenuListCellID";
    
    MenuListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[MenuListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.delegate = self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [cell setValuesforItem:[objCatagoryArray objectAtIndex:indexPath.row]];
    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ItemDetailsVc *objvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetailsVcID"];
    objvc.objid = indexPath.row;
    [self.navigationController pushViewController:objvc animated:YES];
    


}


#pragma mark MenuListCell
-(void)showDetails :(NSString *)objItemID{
    
}
-(void)increaseCart :(NSString *)objItemID{
    
}
-(void)decreaseCart :(NSString *)objItemID{
    
}



@end
