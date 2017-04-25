//
//  SearchController.m
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 10/04/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import "SearchController.h"
#import "Utilities.h"
#import "ItemDetailsVc.h"

@interface SearchController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *objCatagoryArray;
}

@property(weak, nonatomic)IBOutlet UITableView *objtableView;
@property(weak, nonatomic)IBOutlet UISearchBar *objsearchBar;

@property(strong, nonatomic) NSMutableArray *objListArray;
@property(strong, nonatomic) NSMutableArray *objFilteredArray;

@end



@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    _objsearchBar.placeholder = @"Search for products or stores";
    [self parseJsonFile];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
}
-(void)parseJsonFile{
    NSError *error;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"CategoryList" ofType:@"json"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
    NSDictionary *jsonDic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    objCatagoryArray = [jsonDic valueForKey:@"CategoryList"];
    _objListArray = [[NSMutableArray alloc]init];
    for (NSDictionary *objdic in objCatagoryArray) {
        NSString *objstr = [objdic valueForKey:@"MenuName"];
        [_objListArray addObject:objstr];
    }
}
- (void)keyboardWasShown:(NSNotification *)notification
{
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    int height = MIN(keyboardSize.height,keyboardSize.width);
    
    _objtableView.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70-height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)didClickCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchText];

    _objFilteredArray = [[_objListArray filteredArrayUsingPredicate:predicate] mutableCopy];

    [_objtableView reloadData];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_objFilteredArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"MenuListCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    cell.textLabel.text = [_objFilteredArray objectAtIndex:indexPath.row];
    
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


@end
