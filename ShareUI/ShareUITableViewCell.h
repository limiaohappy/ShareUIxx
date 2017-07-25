//
//  ShareUITableViewCell.h
//  Utopa
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 longge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareUIModel.h"

@class ShareUITableViewCell;

@protocol ShareUITableViewCellDelegate <NSObject>

-(void)tableViewCell:(ShareUITableViewCell *)cell didSelectedShareUISelcetIndex:(ShareUISelcetIndex)index;

@end



@interface ShareUITableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray <ShareUIModel *>*itemArr;//分享的项目数组

@property (nonatomic, weak) id <ShareUITableViewCellDelegate> cellDelegate;

@property (nonatomic, strong) UIView *lineV;

-(void)configData;

@end
