//
//  SelectCityViewController.m
//  SkywareUI
//
//  Created by 李晓 on 15/12/11.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "SelectCityViewController.h"
#import "SelectCityGroups.h"
#import "CoreLocationTool.h"
#import "BundleTool.h"
#import <MJExtension/MJExtension.h>

@interface SelectCityViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>
{
    CoreLocationTool *locationTool;
    NSString *_city;
    UISearchBar *_searchBar;
}
@property (nonatomic,strong) NSMutableArray *cityList;

@property (nonatomic,strong) NSMutableArray *searchList;

@property (nonatomic,strong) UISearchDisplayController *searchDisplayController;

@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"城市定位"];
    [self addSearchDisplayController];
    [self.dataList removeAllObjects];
    NSArray *array = [self.cityList valueForKeyPath:@"citys.name"];
    [array enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataList addObjectsFromArray:obj];
    }];
    [self addUserLocationCity];
}

- (void) addUserLocationCity
{
    locationTool = [[CoreLocationTool alloc] init];
    [locationTool getLocation:^(CLLocation *location) {
        [locationTool reverseGeocodeLocation:location userAddress:^(UserAddressModel *userAddress){
            NSLog(@"%@",userAddress.City);
            _city = userAddress.City;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
    
}

- (void) addSearchDisplayController
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar = searchBar;
    searchBar.placeholder = @"搜索地址";
    self.tableView.tableHeaderView = searchBar;
    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
}

- (void)NavBackBtnClick
{
    if (!self.needCity){
        [super NavBackBtnClick];
    }
}

#pragma mark - TableView实现的协议方法
// 一共有几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return self.cityList.count + 1;
    }else{
        return 1;
    }
}

// 每组有多少条数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return 1;
        }else if(section >=1){
            SelectCityGroups *group = self.cityList[section - 1];
            return group.citys.count;
        }
    }else{
        return self.searchList.count;
    }
    return 0;
}

// 每一行的信息以及状态
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = @"SelectCityViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            cell.textLabel.text = _city;
        }else if(indexPath.section >=1){
            SelectCityGroups *group = self.cityList[indexPath.section - 1];
            SelectCity *cars = group.citys[indexPath.row];
            cell.textLabel.text = cars.name;
        }
    }else{
        cell.textLabel.text = self.searchList[indexPath.row];
    }
    return cell;
}

// 组标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return @"当前定位";
        }else if(section >=1){
            return [self.cityList[section - 1] title];
        }
    }
    return @"";
}

// 右侧快速选择
- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return [self.cityList valueForKeyPath:@"title"];
    }else{
        return nil;
    }
}

// 设置每一组 标题的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return 25;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell.textLabel.text.length) return;
    if (self.cellClick) {
        self.cellClick(cell.textLabel.text);
    }
    [self.searchDisplayController setActive:NO animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundColor:[UIColor clearColor]];
    [bar setTintColor:[UIColor clearColor]];
    
    // 修改搜索Nav按钮改为中文取消
    [_searchBar setShowsCancelButton:YES animated:NO];
    UIView *topView = controller.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.navigationController.navigationBar removeFromSuperview];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString
{
    [self.searchList removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF LIKE '%@*'",searchString]];
    [self.searchList addObjectsFromArray:[self.dataList filteredArrayUsingPredicate:predicate]];
    if (self.searchList.count) {
        [self.tableView reloadData];
    }
    return YES;
}

#pragma mark - 懒加载

- (NSMutableArray *)cityList
{
    if (!_cityList) {
        _cityList = [SelectCityGroups mj_objectArrayWithKeyValuesArray:[BundleTool getArrayWithName:@"citys.plist" FromBundle:LXFrameWorkBundle]];
    }
    return _cityList;
}

- (NSMutableArray *)searchList
{
    if (!_searchList) {
        _searchList = [[NSMutableArray alloc] init];
    }
    return _searchList;
}

@end
