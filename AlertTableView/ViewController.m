//
//  ViewController.m
//  AlertTableView
//
//  Created by 张涛 on 2018/3/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController.h"
#import "AlertTableView.h"

@interface ViewController () <AlertTableViewDelegate>

@property (nonatomic, strong) AlertTableView *alertTableView;

//弹出列表数据
@property (nonatomic, strong) NSMutableArray *alertTableDataArr;

@end

@implementation ViewController

- (NSMutableArray *)alertTableDataArr {
    
    if (_alertTableDataArr == nil) {
        
        _alertTableDataArr = [NSMutableArray arrayWithObjects:@"我的订单", @"我的购物车", @"邮寄信息", nil];
        
    }
    
    return _alertTableDataArr;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"首页";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *alertBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 100, 150, 44)];
    
    [alertBtn addTarget:self action:@selector(alertBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    alertBtn.backgroundColor = [UIColor yellowColor];
    
    [alertBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [alertBtn setTitle:@"AlertTableView" forState:UIControlStateNormal];
    
    [self.view addSubview:alertBtn];
    
    [self setUpAlertTableView];
    
}


- (void)alertBtnClick {
    
    [_alertTableView show];

}


- (void)setUpAlertTableView {
    
    //设置弹出选项view
    AlertTableView *alertTableView = [[AlertTableView alloc] initWithFrame:CGRectMake(375 - 120, 64, 115, 128)];
    
    alertTableView.backgroundColor = [UIColor lightGrayColor];
    
    alertTableView.arrowAlignment = ArrowRightType; //设置箭头位置
    
    alertTableView.selectBlock = ^(NSIndexPath *indexPath) {
        
        if (indexPath.row == 0) {
            
            NSLog(@"点击了我的订单");
            
        } else if (indexPath.row == 1) {
            
            NSLog(@"点击了购物车");

        } else if (indexPath.row == 2) {
            
            NSLog(@"点击了邮寄地址");

        }
        
    };
    
    alertTableView.delegate = self;
    
    _alertTableView = alertTableView;
    
}


#pragma mark - AlertTableViewDelegate 弹框
//提供数据源
- (NSMutableArray*)alertTableVieDataSource {
    
    return self.alertTableDataArr;
    
}


//更改对应的cell样式
- (void)alertTableView:(AlertTableViewCell*)alertTableViewCell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    alertTableViewCell.tableTextLable.text = _alertTableDataArr[indexPath.row];
    
    alertTableViewCell.backgroundColor = [UIColor orangeColor];
    
    alertTableViewCell.tableTextLable.font = [UIFont systemFontOfSize:12];
    
    alertTableViewCell.tableTextLable.textColor = [UIColor whiteColor];
    
//    [alertTableViewCell setTableImageViewHidden:YES];

    alertTableViewCell.tableImageView.image = [UIImage imageNamed:@"starlevelfull"]; //设置cell图标，并关掉setTableImageViewHidden
    
}


//每一个cell 的高度
- (CGFloat)alertTableView:(AlertTableView *)alertTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}


@end




