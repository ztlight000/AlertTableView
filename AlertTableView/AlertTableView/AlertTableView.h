//
//  AlertTableView.h
//  AlertTableView
//
//  Created by 张涛 on 2018/3/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertTableView;
@class AlertTableViewCell;

@protocol AlertTableViewDelegate <NSObject>

//提供数据源
- (NSMutableArray*)alertTableVieDataSource;

//更改对应的cell样式
- (void)alertTableView:(AlertTableViewCell *)alertTableViewCell cellForRowAtIndexPath:(NSIndexPath *)indexPath;

//每一个cell的高度
- (CGFloat)alertTableView:(AlertTableView *)alertTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

typedef void (^SelectAlertTableViewBlock)(NSIndexPath *indexPath);

typedef void (^TapCompletionBlock)(BOOL isTap);

enum {
    ArrowNoneType,
    ArrowLeftType,
    ArrowCenterType,
    ArrowRightType
};
typedef NSInteger ArrowAlignmentType;


@interface AlertTableView : UIView

@property (nonatomic,assign)  CGRect tableViewFrame; //tableView的frame

@property (nonatomic, assign) CGRect globalFrame; //AlertTableView的frame

@property (nonatomic, copy) SelectAlertTableViewBlock selectBlock; //选中cell的回调

@property (nonatomic, copy) TapCompletionBlock tapBlock; //点击当前AlertTableView的回调

@property (nonatomic, weak) id<AlertTableViewDelegate> delegate;

@property (nonatomic, assign) ArrowAlignmentType arrowAlignment; //箭头位置

@property (nonatomic, assign) NSInteger notHiddenIndex;

- (void)show;

- (void)showInView:(UIView*)view;

- (void)reloadData;

- (void)hidden;

@end


//cell
@interface AlertTableViewCell : UITableViewCell

@property (nonatomic, weak) UIImageView *tableImageView;

@property (nonatomic, weak) UILabel *tableTextLable;

@property (nonatomic, weak) UIView *lineView;

//在调用隐藏的时候，用下面的方法.主要是布局的变化，图片的隐藏要调用下面的方法
//包括设置样式，都可以自己去设置，当然有默认的样式
- (void)setTableImageViewHidden:(BOOL)isHidden;

@end


//model
@interface AlertItemModel : NSObject

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *linkUrl;

@property (nonatomic, copy) NSString *originTitle;

@end





