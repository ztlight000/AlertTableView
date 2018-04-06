//
//  AlertTableView.m
//  AlertTableView
//
//  Created by 张涛 on 2018/3/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AlertTableView.h"
#import "Masonry.h"

#define WeakSelf typeof(self) __weak weakSelf = self;

@interface AlertTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UIImageView *arrowImageView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation AlertTableView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    _tableViewFrame = frame;
    
    _notHiddenIndex = NSNotFound;
    
    return self;
    
}
- (void)setArrowAlignment:(ArrowAlignmentType)arrowAlignment {
    
    _arrowAlignment = arrowAlignment;
    
    if (arrowAlignment == ArrowLeftType) {
        
        [self.arrowImageView setImage:[UIImage imageNamed:@"alert_left"]];
        
        self.arrowImageView.frame = CGRectMake(_tableViewFrame.origin.x, _tableViewFrame.origin.y - 7, 7, 8);
        
    } else if (arrowAlignment == ArrowCenterType) {
        
        [self.arrowImageView setImage:[UIImage imageNamed:@"alert_center"]];
        
        self.arrowImageView.frame = CGRectMake(_tableViewFrame.origin.x + _tableViewFrame.size.width / 2.0, _tableViewFrame.origin.y - 7, 7, 8);
        
    } else if (arrowAlignment == ArrowRightType) {
        
        [self.arrowImageView setImage:[UIImage imageNamed:@"alert_right"]];
        
        self.arrowImageView.frame = CGRectMake(_tableViewFrame.origin.x + _tableViewFrame.size.width - 7, _tableViewFrame.origin.y - 7, 7, 8);
        
    } else {
        
        
    }
    
}


- (void)reloadData {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
    });
    
}


- (void)setSelectBlock:(SelectAlertTableViewBlock)selectBlock {
    
    selectBlock ? _selectBlock = [selectBlock copy] : nil;
    
}


- (void)setTapBlock:(TapCompletionBlock)tapBlock {
    
    tapBlock ? _tapBlock = [tapBlock copy] : nil;
    
}


- (void)show {
    
    self.dataArray = [self.delegate alertTableVieDataSource];
    
    [self addSubview:self.tableView];
    
    self.tableView.scrollEnabled = NO;
    
    [self.tableView reloadData];
    
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    [window addSubview:self];
    
    
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.2 animations:^ {
        
        self.backgroundColor = [UIColor colorWithRed:(0)/255.0 green:(0)/255.0 blue:(0)/255.0 alpha:(0.3)];
        
        self.tableView.alpha = 1.0;
        
        self.arrowImageView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
    }];
    
}


- (void)hidden {
    
    [UIView animateWithDuration:0.2 animations:^ {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.tableView.alpha = 0.0f;
        
        self.arrowImageView.alpha = 0.0f;
        
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}


- (void)showInView:(UIView*)view {
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        self.dataArray = [self.delegate alertTableVieDataSource];
        
        [self addSubview:self.tableView];
        
        [self.tableView reloadData];
        
        [view addSubview:self];
        
        self.backgroundColor = [UIColor clearColor];
        
        [UIView animateWithDuration:0.2 animations:^ {
            
            self.backgroundColor = [UIColor colorWithRed:(0)/255.0 green:(0)/255.0 blue:(0)/255.0 alpha:(0.3)];
            
            self.tableView.alpha = 1.0f;
            
            self.arrowImageView.alpha=1.0f;
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    });
    
}


- (void)setTableViewFrame:(CGRect)tableViewFrame {
    
    _tableViewFrame = tableViewFrame;
    
    self.tableView.frame = _tableViewFrame;
    
}


- (void)setGlobalFrame:(CGRect)globalFrame {
    
    self.frame = globalFrame;
    
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectBlock ? _selectBlock(indexPath) :nil;
    
    if (_notHiddenIndex==indexPath.row) {
        
        return;
        
    }else{
        
        [self hidden];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.delegate alertTableView:self heightForRowAtIndexPath:indexPath];
    
}


#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *alertIndentify = @"alertIndentify";
    
    AlertTableViewCell *alertCell = [tableView dequeueReusableCellWithIdentifier:alertIndentify];
    
    if (alertCell == nil) {
        
        alertCell = [[AlertTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:alertIndentify];
        
    }
    
    [self.delegate alertTableView:alertCell cellForRowAtIndexPath:indexPath];
    
    return alertCell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
}


- (UIImageView *)arrowImageView {
    
    if (_arrowImageView == nil) {
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        _arrowImageView = arrowImageView;
        
        [self addSubview:_arrowImageView];
        
    }
    
    return _arrowImageView;
    
}


- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:_tableViewFrame style:UITableViewStylePlain];
        
        _tableView = tableView;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.userInteractionEnabled = YES;
        
        [self addSubview:_tableView];
        
    }
    
    return _tableView;
    
}


- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray new];
        
    }
    
    return _dataArray;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    if (!CGRectContainsPoint(_tableView.frame, point)) {
        
        [self hidden];
        
        _tapBlock ? _tapBlock (YES) : nil;
        
    }
    
}

@end


#pragma mark - AlertTableViewCell
@implementation AlertTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self setUpContentView];
    
    [self configUI];
    
    return self;
    
}


- (void)setTableImageViewHidden:(BOOL)isHidden {
    
    [self.tableImageView setHidden:YES];
    
    WeakSelf
    
    if (isHidden) {
        
        [self.tableTextLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(weakSelf.mas_centerX);
            
            make.centerY.equalTo(weakSelf.mas_centerY);
            
        }];
        
    } else {
        
        [self.tableImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakSelf).offset(10);
            
            make.centerY.equalTo(weakSelf);
            
            make.width.height.mas_equalTo(@20);
            
        }];
        
        [self.tableTextLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakSelf.tableImageView.mas_right).offset(10);
            
            make.centerY.equalTo(weakSelf);
            
        }];
        
    }
    
}


- (void)setUpContentView {
    
    UIImageView *tableImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:tableImageView];
    
    _tableImageView = tableImageView;
    
    
    UILabel *tableTextLable = [[UILabel alloc]initWithFrame:CGRectZero];
    
    tableTextLable.font = [UIFont systemFontOfSize:13];
    
    [tableTextLable setBackgroundColor:[UIColor clearColor]];
    
    tableTextLable.lineBreakMode = NSLineBreakByWordWrapping;
    
    tableTextLable.textColor = [UIColor lightGrayColor];
    
    tableTextLable.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:tableTextLable];
    
    _tableTextLable = tableTextLable;
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    lineView.backgroundColor = [UIColor colorWithRed:(209)/255.0 green:(214)/255.0 blue:(222)/255.0 alpha:0.6];
    
    [self addSubview:lineView];
    
    _lineView = lineView;
    
}

- (void)configUI {
    
    WeakSelf
    
    [self.tableImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf).offset(10);
        
        make.centerY.equalTo(weakSelf);
        
        make.width.height.mas_equalTo(@20);
        
    }];
    
    
    [self.tableTextLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.tableImageView.mas_right).offset(10);
        
        make.centerY.equalTo(weakSelf);
        
    }];
    
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(weakSelf);
        
        make.bottom.equalTo(weakSelf);
        
        make.height.mas_equalTo(@0.5);
        
    }];
    
}


@end


#pragma mark - model
@implementation AlertItemModel

@end






