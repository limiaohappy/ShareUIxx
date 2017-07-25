//
//  ShareUIView.m
//  Utopa
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 longge. All rights reserved.
//

#import "ShareUIView.h"

#import "ShareUITableViewCell.h"

@interface ShareUIView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,ShareUITableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableV;
@property (nonatomic,strong) UIView *backGroundView; //背景白色
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIView *topsheetView; //上部的 白色区域
@property (nonatomic,strong) UILabel *titleLb;//上部的 文字label
@property (nonatomic,strong) NSString *proText; //文字
@property (nonatomic,assign) ShareUISelcetIndex selecttype; //点击选中的item值
@property (nonatomic,strong) NSMutableArray <ShareUIModel *> *shareItemArr; //分享
@property (nonatomic,strong) NSMutableArray <ShareUIModel *> *functionItemArr; //其它功能

@end


#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1]
#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]

#define ActionSheetW [[UIScreen mainScreen] bounds].size.width
#define ActionSheetH [[UIScreen mainScreen] bounds].size.height


@implementation ShareUIView

static CGFloat kAnimationDuration = 0.25f;
static NSString *cellIdentity = @"ShareUITableViewCell";


-(instancetype)initWithProText:(NSString *)proText{

    if (self = [super init]) {

        self.selecttype = ShareUISelcetIndexDefault;
        self.proText = proText;
        self.frame = CGRectMake(0, 0, ActionSheetW, ActionSheetH);
        self.backgroundColor = WINDOW_COLOR;
        self.alpha = 0;
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.alpha = 1;
        }];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        tapGesture.delegate = self;

        [self addGestureRecognizer:tapGesture];
        [self loadUiConfig];
        [[UIApplication sharedApplication].keyWindow addSubview:self];

    }
    return self;
}


- (void)loadUiConfig{
    [self addSubview:self.backGroundView];
    [_backGroundView addSubview:self.topsheetView];
    [_backGroundView addSubview:self.cancelBtn];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        _backGroundView.frame = CGRectMake(0, ActionSheetH-CGRectGetHeight(_backGroundView.frame), ActionSheetW, CGRectGetHeight(_backGroundView.frame));
    }];
}

-(UITableView *)tableV{
    if (_tableV == nil) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, CGRectGetWidth(_backGroundView.frame), CGRectGetHeight(_backGroundView.frame)-30) style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.backgroundColor = self.backGroundView.backgroundColor;
        [_tableV registerClass:[ShareUITableViewCell class] forCellReuseIdentifier:cellIdentity];
        _tableV.scrollEnabled = NO;
    }
    return _tableV;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shareItemArr.count==0 ? 1:2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ShareUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    cell.cellDelegate = self;
    if (self.shareItemArr.count == 0) {
        cell.itemArr = self.functionItemArr;
        cell.lineV.hidden = YES;

    }else{
        if (indexPath.row == 0) {
            cell.itemArr = self.shareItemArr;
            cell.lineV.hidden = NO;

        }else{
            cell.itemArr = self.functionItemArr;
            cell.lineV.hidden = YES;

        }
    }
    
    [cell configData];
    return cell;
}

-(void)tableViewCell:(ShareUITableViewCell *)cell didSelectedShareUISelcetIndex:(ShareUISelcetIndex)index{
    self.cellClickblock(index);
    [self tappedCancel];
}
#pragma mark lazy load 懒加载


-(UIView *)backGroundView{
    if (_backGroundView == nil) {
        _backGroundView = [[UIView alloc] init];
       
        _backGroundView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1];
        NSInteger index = self.shareItemArr.count ==0 ? 1:2;
        //初始化的时候 UI在底部
        //根据 self.proText.length  第一部分高度取值
        //根据 self.shareItemArr.count 第二部分高度取值
        //留底部的取消的 的高度 34
        _backGroundView.frame = CGRectMake(0, ActionSheetH, ActionSheetW,(self.proText.length==0?0:30)+85*index+ 50);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noTap)];
        tapGesture.delegate = self;
        [_backGroundView addGestureRecognizer:tapGesture];
    }
    return _backGroundView;
    
}


- (UIView *)topsheetView{
    if (_topsheetView == nil) {
        _topsheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backGroundView.frame), CGRectGetHeight(_backGroundView.frame)-50)];
        _topsheetView.backgroundColor = [UIColor whiteColor];
//        _topsheetView.layer.cornerRadius = 4;
        _topsheetView.clipsToBounds = YES;
        if (_proText.length) {
            [_topsheetView addSubview:self.titleLb];
        }
        [_topsheetView addSubview:self.tableV];
    }
    return _topsheetView;
}

-(UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backGroundView.frame), 30)];
        _titleLb.text = self.proText;
        _titleLb.textColor = [UIColor grayColor];
        _titleLb.backgroundColor =self.backGroundView.backgroundColor;
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.font = [UIFont systemFontOfSize:12];
    }
    return _titleLb;
}

- (UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, CGRectGetHeight(_backGroundView.frame)-50, CGRectGetWidth(_backGroundView.frame), 50);
//        _cancelBtn.layer.cornerRadius = 4;
//        _cancelBtn.clipsToBounds = YES;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}




-(NSMutableArray<ShareUIModel *> *)functionItemArr{
    if (_functionItemArr==nil) {
        ShareUIModel *refreshModel = [[ShareUIModel alloc]init];
        refreshModel.itemName = @"刷新";
        refreshModel.itemImgName = @"refresh";
        refreshModel.shareType = ShareUISelcetIndexRefresh;
        ShareUIModel *copyModel = [[ShareUIModel alloc]init];
        copyModel.itemName = @"复制剪切板";
        copyModel.itemImgName = @"link";
        copyModel.shareType = ShareUISelcetIndexCopyToPad;
        _functionItemArr = [NSMutableArray arrayWithCapacity:1];
        [_functionItemArr addObject:refreshModel];
        [_functionItemArr addObject:copyModel];
    }
    return _functionItemArr;
}


-(NSMutableArray<ShareUIModel *> *)shareItemArr{
    if (_shareItemArr == nil) {
        _shareItemArr = [NSMutableArray arrayWithCapacity:1];
        BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
        BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
#warning 这里为了显示图标 强制打开了
        hadInstalledWeixin = hadInstalledQQ = YES;
        
        if (hadInstalledWeixin) {
            ShareUIModel *model1 = [[ShareUIModel alloc]init];
            model1.itemImgName = @"wechat";
            model1.itemName = @"微信好友";
            model1.shareType = ShareUISelcetIndexWechatFriend;
            
            ShareUIModel *model2 = [[ShareUIModel alloc]init];
            model2.itemImgName = @"pengyouquan";
            model2.itemName = @"微信朋友圈";
            model2.shareType = ShareUISelcetIndexWechatGroup;
            [_shareItemArr addObject:model1];
            [_shareItemArr addObject:model2];
        }
        
        if (hadInstalledQQ) {
            ShareUIModel *model1 = [[ShareUIModel alloc]init];
            model1.itemImgName = @"qq";
            model1.itemName = @"QQ好友";
            model1.shareType = ShareUISelcetIndexQQFriend;
            ShareUIModel *model2 = [[ShareUIModel alloc]init];
            model2.itemImgName = @"qqzone";
            model2.itemName = @"QQ空间";
            model2.shareType = ShareUISelcetIndexQQZone;
            [_shareItemArr addObject:model1];
            [_shareItemArr addObject:model2];
        }
        
        ShareUIModel *modelSafari = [[ShareUIModel alloc]init];
        modelSafari.itemImgName = @"safari";
        modelSafari.itemName = @"用Safari打开";
        modelSafari.shareType = ShareUISelcetIndexSafari;
        [_shareItemArr addObject:modelSafari];


    }
    return _shareItemArr;
}



#pragma mark  click Action  点击事件
- (void)tappedCancel{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.backGroundView setFrame:CGRectMake(0, ActionSheetH, ActionSheetW, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
//            [self removeAllSubviews];
            [self removeFromSuperview];
        }
    }];
}

- (void)noTap{
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    
    if (touch.view == self || touch.view == self.backGroundView) {
        return YES;
    }
    return  NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
