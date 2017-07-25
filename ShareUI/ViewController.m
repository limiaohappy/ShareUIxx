//
//  ViewController.m
//  ShareUI
//
//  Created by mac on 2017/7/25.
//  Copyright © 2017年 GTLand_LeeMiao. All rights reserved.
//

#import "ViewController.h"
#import "ShareUIView.h"
#import "ShareUIModel.h"
@interface ViewController ()

@property (nonatomic,strong) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btn.frame = CGRectMake(50, 100, self.view.frame.size.width -100, 50);
    [self.btn setTitle:@"ShareUI" forState:UIControlStateNormal];
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.borderColor = [UIColor blueColor].CGColor;
    self.btn.layer.borderWidth =1.0f;
    self.btn.layer.cornerRadius = 8.0f;
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(shareBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)shareBtnClickAction:(UIButton *)sender{
    NSLog(@"shareBtnClickAction");
    
    [[ShareUIView alloc]initWithProText:@"www.gtlandLeeMiao.com" ].cellClickblock = ^(ShareUISelcetIndex clickIndex) {
        
        NSLog(@"ShareUISelcetIndex = %ld",clickIndex);
        
        if (clickIndex == ShareUISelcetIndexSafari) {
            NSString *url =@"http://www.baidu.com";//把http://带上
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:nil completionHandler:^(BOOL success) {
                
            }];
            
        }
        
        
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
