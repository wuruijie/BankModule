//
//  XHSearchBankController.m
//  XinHuWealth
//
//  Created by XinHuiOS on 2019/4/23.
//  Copyright © 2019 张彦芳. All rights reserved.
//

#import "XHSearchBankController.h"
#import "XHBankViewModel.h"

#define kGreenColor [UIColor colorWithRed:1/255.0 green:190/255.0 blue:86/255.0 alpha:1]
@interface XHSearchBankController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate>
{
    NSArray *_rowArr;//row array
    NSArray *_sectionArr;//section array
    NSArray * dataArray;
}
@property(nonatomic,strong)NSMutableArray *requltData;

@property(nonatomic,strong)NSMutableArray *requltIndexData;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UITableView *indexTableView;

@property (nonatomic, strong) NSMutableArray<XHCommonResult *> *contactArray;// 模拟数据
@property (nonatomic, strong) NSMutableArray *selectArray; // 选中的model数组
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *tipViewBtn;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) BOOL isScrollToShow;
@property (strong,nonatomic)NSMutableArray * searchResultArray;/*搜索完之后的数据(数组类型)*/
@property (strong,nonatomic)NSMutableArray * searchModelResultArray;/*搜索完之后的数据(model类型)*/
@property (strong,nonatomic)NSMutableArray * contactsModelSourceList;
//searchController
@property (strong, nonatomic)  UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *historyListArray; // 搜索历史数组
@property(nonatomic,assign)BOOL searchActive;
@end

@implementation XHSearchBankController
-(NSMutableArray *)searchResultArray{
    if (!_searchResultArray) {
        _searchResultArray = [NSMutableArray array];
    }
    return _searchResultArray;
}
-(NSMutableArray *)searchModelResultArray{
    if (!_searchModelResultArray) {
        _searchModelResultArray = [NSMutableArray array];
    }
    return _searchModelResultArray;
}
-(void)getAllData {
    [XHBankViewModel getTransMoneyBankInfoSuccess:^(NSArray * _Nonnull bankArray) {
        self->dataArray = bankArray;
        for (NSDictionary *dic in self->dataArray) {
            XHCommonResult *model = [[XHCommonResult alloc]init];
            model.bank_name = dic[@"bank_name"];
            model.bankserial = dic[@"id"];
            model.isBaseBank = NO;
            [self.contactArray addObject:model];
        }
        //分组 并排序
        [self sortAllData];
        
    } failed:^(NSString * _Nonnull message) {
        
        [MBProgressHUD showHideMessage:message toView:self.view];
    }];
}
-(void)sortAllData {
    NSArray *tempArray = [self groupingSortingWithObjects:self.contactArray withSelector:@selector(bank_name) isEmptyArray:YES];
    _rowArr = tempArray[0];
    _sectionArr = tempArray[1];
    [self.listTableView reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectIndex = 1;
    self.contactArray = [NSMutableArray new];
    //创建子视图
    [self setupSubViews];
    [self getAllData];
}
- (void)setupSubViews {
    // 列表
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-NAVIGATION_BAR_HEIGHT-48) style:(UITableViewStylePlain)];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.showsVerticalScrollIndicator = NO;
    _listTableView.backgroundColor = kColor_lightGray3;
    _listTableView.tableFooterView = [[UIView alloc] init];
    _listTableView.bounces = NO;
    _listTableView.sectionIndexColor = kColor_assitBlack;
     //_listTableView.contentInset = UIEdgeInsetsMake(-10,0, 0, 0);
    [self.view addSubview:_listTableView];
    [_listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"_listTableViewCell"];
    //创建UISearchController
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    _searchController.delegate = self;
    _searchController.searchResultsUpdater = self;
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    _searchController.dimsBackgroundDuringPresentation = YES;
    //搜索时，背景变模糊
    if (@available(iOS 9.1, *)) {
        _searchController.obscuresBackgroundDuringPresentation = NO;
    } else {
    }
    //隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.backgroundColor = [UIColor whiteColor];
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchController.searchBar.showsCancelButton = YES;
    UIButton *canceLBtn = [_searchController.searchBar valueForKey:@"cancelButton"];
    [canceLBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canceLBtn setTitleColor:kColor_darkGold forState:UIControlStateNormal];
    _searchController.searchBar.placeholder = @"  输入开户名称";
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 74.0);
    self.listTableView.tableHeaderView = _searchController.searchBar;
}
/**
 将传进来的数据模型分组并排序  分成若干个分组  每个分组也进行排序 并删除分组中为空的分组
 
 @param objects 初始的对象数组
 @param selector 属性名称
 @param empty 清空与否
 @return 返回一个大数组 数组中是小数组  小数组中存储模型对象
 */
-(NSArray *)groupingSortingWithObjects:(NSArray *)objects withSelector:(SEL)selector isEmptyArray:(BOOL)empty{
    
    //UILocalizedIndexedCollation的分组排序建立在对对象的操作之上
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得到collation索引数量（26个字母和1个#）
    NSMutableArray *indexArray = [NSMutableArray arrayWithArray:collation.sectionTitles];
    NSUInteger sectionNumber = [indexArray count];//sectionNumber = 27
    
    //建立每个section数组
    NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:sectionNumber];
    for (int index = 0; index < sectionNumber; index++) {
        NSMutableArray *subArray = [NSMutableArray array];
        [sectionArray addObject:subArray];
    }
    
    for (XHCommonResult *model in objects) {
        //根绝SEL方法返回的字符串判断对象应该处于哪个分区
        //将每个人按name分到某个section下
        NSInteger index = [collation sectionForObject:model collationStringSelector:selector];//获取name属性的值所在的位置，比如“林”首字母是L,则就把林放在L组中
        NSMutableArray *tempArray = sectionArray[index];
        [tempArray addObject:model];
    }
    //对每个section中的数组按照name属性排序
    for (NSMutableArray *arr in sectionArray) {
        NSArray *sortArr = [collation sortedArrayFromArray:arr collationStringSelector:selector];
        [arr removeAllObjects];
        [arr addObjectsFromArray:sortArr];
    }
    //是不是删除空数组
    if (empty) {
        [sectionArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.count == 0) {
                [sectionArray removeObjectAtIndex:idx];
                [indexArray removeObjectAtIndex:idx];
            }
        }];
    }
    //第一个数组为tableView的数据源  第二个数组为索引数组 A B C......
    return @[sectionArray,indexArray];
}
#pragma mark -------- tableview --------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.searchController.active) {
        return 1;
    }
    return _searchActive ? _requltData.count : _rowArr.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.searchController.active) {
        
        if (self.searchController.searchBar.text.length>0) {
            return [self.searchModelResultArray count];
        }else{
            return self.historyListArray.count;
        }
    }
    return _searchActive ? [_requltData[section] count] : [_rowArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tableView == _listTableView ? 52.0 : 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return tableView == _listTableView ? 30.0 : 0.1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"搜索结果";
}
//索引 数组
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        return nil;
    }
    return _searchActive ? _requltIndexData : _sectionArr;
}
//索引 点击
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return [[UILocalizedIndexedCollation currentCollation]sectionForSectionIndexTitleAtIndex:index];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.searchController.active) {
        if (self.searchController.searchBar.text.length>0) {
            return nil;
        }else{
            if (self.historyListArray.count > 0) {
                UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30)];
                header.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
                label.text = @"历史记录";
                label.textColor = [UIColor blackColor];
                [header addSubview:label];
                
                UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
                cancel.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 200, 0, 200, 30);
                [cancel setTitle:@"清除历史记录" forState:0];
                [cancel setTitleColor:[UIColor blackColor] forState:0];
                [header addSubview:cancel];
                [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
                
                return header;
            }else{
                return nil;
            }
        }
    }
    if (tableView == _listTableView) {
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
        label.text = _searchActive ? _requltIndexData[section] : _sectionArr[section];
        label.textColor = kColor_mainBlack;
        [header addSubview:label];
        return header;
    }
    
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XHCommonResult * model = [[XHCommonResult alloc]init];
    if (self.searchController.active) {
        
        if (self.searchController.searchBar.text.length>0) {
            model = _searchModelResultArray[indexPath.row];
        }else{
            model = self.historyListArray[indexPath.row];
        }
    }
    else
    {
        model = _rowArr[indexPath.section][indexPath.row];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_listTableViewCell" forIndexPath:indexPath];
    cell.textLabel.textColor = kColor_mainBlack;
    cell.textLabel.text = model.bank_name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XHCommonResult *model = nil;
    if (self.searchController.active) {
        
        if (self.searchController.searchBar.text.length>0) {
             model  = _searchModelResultArray[indexPath.row];
        }else{
             model = self.historyListArray[indexPath.row];
        }
    }else
    {
        model = _rowArr[indexPath.section][indexPath.row];
    }
#pragma mark 点击传值
    if (self.delegete && [self.delegete respondsToSelector:@selector(getBankInfo:)]) {
        [self.delegete getBankInfo:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --------   --------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.isScrollToShow) {
        // 获取当前屏幕可见范围的indexPath
        NSArray *visiblePaths = [_listTableView indexPathsForVisibleRows];
        
        if (visiblePaths.count < 1) {
            return;
        }
        NSIndexPath *indexPath0 = visiblePaths[0];
        
        // 判断是否已滑到最底部
        CGFloat height = scrollView.frame.size.height;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
        
        NSIndexPath *indexPath;
        if (bottomOffset <= height || fabs(bottomOffset - height) < 1) {
            //在最底部（显示最后一个索引字母）
            NSInteger row = _sectionArr.count-1;
            indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            self.selectIndex = indexPath.row;
        }else {
            indexPath = [NSIndexPath indexPathForRow:indexPath0.section inSection:0];
            self.selectIndex = indexPath.row+1;
        }
        
        [_indexTableView reloadData];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 重置
    if (!self.isScrollToShow) {
        self.isScrollToShow = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 重置
    if (!self.isScrollToShow) {
        self.isScrollToShow = YES;
    }
}
#pragma mark ----------------UISearchControllerDelegate---------------------
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.searchModelResultArray = [NSMutableArray array];
    NSLog(@"updateSearchResultsForSearchController");
    NSString *searchString = [self.searchController.searchBar text];
    
    if (self.searchModelResultArray!= nil) {
        [self.searchModelResultArray removeAllObjects];
    }
    if (searchString.length > 0) {
        NSMutableArray * pinyinArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 0; i < dataArray.count ; i++) {
            NSDictionary * dict = [dataArray objectAtIndex:i];
            /*
             * 搜索拼音
             */
            NSString * pingyin = [dict objectForKey:@"bank_name"];
            pingyin = [pingyin transformCharacter]; //转换拼音
            pingyin = [pingyin lowercaseString]; //转换 大小写之小写
            searchString = [searchString transformCharacter];
            searchString = [searchString lowercaseString];
            
            if (searchString.length == 1) {
                //名字转化拼音 首字符 是否 包含 搜索文字
                if ([pingyin hasPrefix:searchString]) {
                    [pinyinArray addObject:dict];
                }
            }else{
                //名字转化拼音  是否 包含 搜索文字
                if ([pingyin rangeOfString:searchString].location != NSNotFound) {
                    [pinyinArray addObject:dict];
                }
                //转化拼音 保留 每个字的首字母
                NSString * pingyina = [dict objectForKey:@"bank_name"];
                pingyina = [pingyina firstCharactor:pingyina];
                pingyina = [pingyina lowercaseString]; //转换 大小写之小写
                if ([pingyina rangeOfString:searchString].location != NSNotFound) {
                    [pinyinArray addObject:dict];
                }
            }
        }
        //数组 去重复
        NSMutableArray *pinyinArr = [NSMutableArray array];
        for (NSString *item in pinyinArray) {
            if (![pinyinArr containsObject:item]) {
                [pinyinArr addObject:item];
            }
        }
        //展示
        for (NSDictionary * dic in pinyinArr) {
             XHCommonResult *model = [[XHCommonResult alloc]init];
            model.bank_name = dic[@"bank_name"];
            model.bankserial = dic[@"bankserial"];
            [self.searchModelResultArray addObject:model];
        }
        /*
         *  添加历史搜索
         */
        NSMutableArray * historyarray = [[NSMutableArray alloc]init];
        
        if (self.historyListArray.count>0) {
            for (XHCommonResult * model in self.historyListArray) {
                NSMutableDictionary * historyDict = [[NSMutableDictionary alloc]init];
                [historyDict setObject:model.bank_name forKey:@"bank_name"];
                [historyarray addObject:historyDict];
            }
        }
        NSMutableDictionary * historyDict = [[NSMutableDictionary alloc]init];
        [historyDict setObject:searchString forKey:@"bank_name"];
        [historyarray addObject:historyDict];
        //数组 去重复
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSString *item in historyarray) {
            if (![resultArray containsObject:item]) {
                [resultArray addObject:item];
            }
        }
        //储存
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray * array = [NSArray arrayWithArray:resultArray];
        [userDefaults setObject:array forKey:@"history"];
        [userDefaults synchronize];
        //展示
        [self.historyListArray removeAllObjects];
        for (NSDictionary * dic in resultArray) {
            XHCommonResult *model = [[XHCommonResult alloc]init];
            model.bank_name = dic[@"bank_name"];
            [self.historyListArray addObject:model];
        }
#pragma mark 不要历史记录
        //展示
        [self.historyListArray removeAllObjects];
    }else{
        [self.searchModelResultArray removeAllObjects];
    }
    //刷新表格
    [self.listTableView reloadData];
}
#pragma mark --- 清除历史记录
-(void)cancelClick
{
    [self.listTableView removeFromSuperview];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
    [self setupSubViews];
    [self.listTableView reloadData];
}

@end
