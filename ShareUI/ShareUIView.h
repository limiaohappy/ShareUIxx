//
//  ShareUIView.h
//  Utopa
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 longge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareUIModel.h"


@interface ShareUIView : UIView

//点击Cell  block回调
@property (nonatomic,copy) void(^cellClickblock)(ShareUISelcetIndex);

-(instancetype)initWithProText:(NSString *)proText;

@end
