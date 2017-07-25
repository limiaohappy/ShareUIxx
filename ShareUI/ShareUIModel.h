//
//  ShareUIModel.h
//  Utopa
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 longge. All rights reserved.
//





#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, ShareUISelcetIndex) {
    ShareUISelcetIndexDefault, // 默认
    ShareUISelcetIndexWechatFriend, // 微信好友
    ShareUISelcetIndexWechatGroup, //微信朋友圈
    ShareUISelcetIndexQQFriend, //QQ好友
    ShareUISelcetIndexQQZone, //QQ空间
    ShareUISelcetIndexSina, //新浪
    
    ShareUISelcetIndexSafari, //苹果自带浏览器

    ShareUISelcetIndexRefresh, // 刷新
    ShareUISelcetIndexCopyToPad, // 复制到剪切板
};
@interface ShareUIModel : NSObject

@property (nonatomic,strong) NSString *itemName;

@property (nonatomic,strong) NSString *itemImgName;

@property (nonatomic,assign) ShareUISelcetIndex shareType;

@end
