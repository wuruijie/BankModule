//
//  XHBaseBankController.m
//  XinHuWealth
//
//  Created by XinHuiOS on 2019/4/23.
//  Copyright © 2019 张彦芳. All rights reserved.
//

#import "XHBaseBankController.h"
#import "TXBaseBankCell.h"
#import "XHBankViewModel.h"
@interface XHBaseBankController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)XHBankResponse *response;
@end
@implementation XHBaseBankController

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight =82;
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.showsHorizontalScrollIndicator =NO;
        _tableView.backgroundColor  =kColor_lightGray3;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            
        } else {
         
        }
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TXBaseBankCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TXBaseBankCell class])];
        _tableView.tableFooterView =[[UIView alloc] init];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =kColor_lightGray3;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(self.view);
    }];
   //获取银行...
    [XHBankViewModel getAllBaseBankInfoSuccess:^(XHBankResponse * _Nonnull responde) {
        self.response = responde;
        [self.tableView reloadData];
    } failed:^(NSString * _Nonnull message) {
        [MBProgressHUD showHideMessage:message toView:self.view];

    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return  1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.response.result.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXBaseBankCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TXBaseBankCell class]) forIndexPath:indexPath];
   
    NSDictionary *result = self.response.result[indexPath.row];
    
    XHCommonResult * model =[XHCommonResult mj_objectWithKeyValues:result];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XHCommonResult *result = self.response.result[indexPath.row];
    XHCommonResult * model =[XHCommonResult mj_objectWithKeyValues:result];
    model.isBaseBank = YES;
    if (self.delegete && [self.delegete respondsToSelector:@selector(selectRowModel:)]) {
        [self.delegete selectRowModel:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
