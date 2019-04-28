//
//  XHRootBankController.m
//  XinHuWealth
//
//  Created by XinHuiOS on 2019/4/23.
//  Copyright © 2019 张彦芳. All rights reserved.
//

#import "XHRootBankController.h"
#import "ZWMSegmentController.h"

@interface XHRootBankController ()<ChoiseBankDelegete,SearchBankDelegete>

@property (nonatomic, strong) ZWMSegmentController *segmentVC;

@end

@implementation XHRootBankController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    self.navigationItem.title =@"选择开户银行";
    self.view.backgroundColor =kColor_lightGray3;
    [self creatSubViewControllers];
    
}
-(void)creatSubViewControllers {
    NSMutableArray *vcArray=[[NSMutableArray alloc] init];
    //标题数组
    NSArray *titleArr =@[@"快捷+汇款支付",@"仅支持汇款支付"];
    //10家常规银行
    XHBaseBankController * baseBank =[[XHBaseBankController alloc] init];
    baseBank.fl_navigationBar.hidden = YES;
    baseBank.delegete = self;
    self.baseBank = baseBank;
    [vcArray addObject:baseBank];
    //100家搜索银行
    XHSearchBankController *searchBank  =[[XHSearchBankController alloc] init];
    self.searchBank = searchBank;
    searchBank.delegete  = self;
    searchBank.fl_navigationBar.hidden = YES;
    [vcArray addObject:searchBank];
   self.segmentVC = [[ZWMSegmentController alloc] initWithFrame:CGRectMake(0,kNavgationBarAndStatusBarHeight,kScreenWidth,kScreenHeight-kNavgationBarAndStatusBarHeight) titles:titleArr];
    self.segmentVC.view.backgroundColor =kColor_lightGray3;
    self.segmentVC.segmentView.segmentTintColor =kColor_regularGold;
    self.segmentVC.segmentView.segmentNormalColor =kColor_assitBlack;
    self.segmentVC.viewControllers = vcArray;
    self.segmentVC.segmentView.style = ZWMSegmentStyleDefault;
    //指示条和按钮文字对其
    [self addSegmentController:self.segmentVC];
    
    [self.segmentVC selectedAtIndex:^(NSUInteger index, UIButton * _Nonnull button, UIViewController * _Nonnull viewController) {
    
         [self.searchBank cancelClick];
    }];
    [self.segmentVC  setSelectedAtIndex:0];
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchBank cancelClick];
}
#pragma mark   ChoiseBankDelegete
-(void)selectRowModel:(XHCommonResult *)model {
    if (self.delegete  && [self.delegete respondsToSelector:@selector(getBankInfo:)]) {
        [self.delegete getBankInfo:model];
    }
}
#pragma mark   SearchBankDelegete
-(void)getBankInfo:(XHCommonResult *)model
{
    if (self.delegete  && [self.delegete respondsToSelector:@selector(getBankInfo:)]) {
        [self.delegete getBankInfo:model];
    }
}
@end
