//
//  TXBaseBankCell.m
//  XinHuWealth
//
//  Created by XinHuiOS on 2019/4/23.
//  Copyright © 2019 张彦芳. All rights reserved.
//

#import "TXBaseBankCell.h"

@interface TXBaseBankCell ()

@property (weak, nonatomic) IBOutlet UIImageView *BankIconView;
@property (weak, nonatomic) IBOutlet UILabel *BankTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *BankDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *BottomLineView;


@end

@implementation TXBaseBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.BottomLineView.backgroundColor = kColor_lightGray3;
    self.BankDetailLabel.textColor = kColor_assitBlack ;
    self.BankTitleLabel.textColor = kColor_mainBlack;
    self.selectionStyle  = UITableViewCellSelectionStyleNone;self.BankIconView.layer.cornerRadius = 15;
    self.BankIconView.layer.masksToBounds = YES;
    self.BankIconView.contentMode = UIViewContentModeScaleAspectFill;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModel:(XHCommonResult *)model {
    _model = model;
    self.BankTitleLabel.text = model.bank_name;
    NSString * onlineDeadLine = nil;
    NSString * todayDeadLine =  nil;
    if (kStringIsEmpty(model.quota)) {
        onlineDeadLine  = @"1";
        todayDeadLine  = @"1";
        NSString *totalS =[NSString stringWithFormat:@"单笔限额 %@万 单日限额 %@万",onlineDeadLine,todayDeadLine];
        NSMutableAttributedString *attbue =[[NSMutableAttributedString alloc] initWithString:totalS];
        [attbue addAttribute:NSForegroundColorAttributeName value:kColor_selectRed range:NSMakeRange(5,onlineDeadLine.length)];
        [attbue addAttribute:NSForegroundColorAttributeName value:kColor_selectRed range:NSMakeRange(5+onlineDeadLine.length+7,todayDeadLine.length)];
        self.BankDetailLabel.attributedText = attbue;
    }else {
      //将字符串截取为2个数组
        NSArray * stringArr =[model.quota componentsSeparatedByString:@"，"];
        NSString *stringFirst =stringArr.firstObject;
        NSString *numberOne =[self getNumberFromStr:stringFirst];
        
        //获取位置
        NSRange locationONe =[stringFirst rangeOfString:numberOne];
        NSMutableAttributedString * stringOne =[[NSMutableAttributedString alloc] initWithString:stringFirst];
        
        [stringOne addAttribute:NSForegroundColorAttributeName value:kColor_selectRed range:locationONe];
        
        NSString *stringLast =stringArr.lastObject;
        NSString *numberTWo =[self getNumberFromStr:stringLast];
        //获取位置
        NSRange locationTWo =[stringLast rangeOfString:numberTWo];
        NSMutableAttributedString * stringTwo =[[NSMutableAttributedString alloc] initWithString:stringLast];
        
        [stringTwo addAttribute:NSForegroundColorAttributeName value:kColor_selectRed range:locationTWo];
        NSMutableAttributedString *stringDo =[[NSMutableAttributedString alloc] initWithString:@", "];
        [stringOne appendAttributedString:stringDo];
        [stringOne appendAttributedString:stringTwo];
        self.BankDetailLabel.attributedText = stringOne;
        
    }
    [self.BankIconView sd_setImageWithURL:[NSURL URLWithString:model.bankimage]];
}

-(NSString *)getNumberFromStr:(NSString *)str{
    
    NSCharacterSet * nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
   
    return[[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
    
}

@end
