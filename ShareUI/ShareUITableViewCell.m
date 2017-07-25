//
//  ShareUITableViewCell.m
//  Utopa
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 longge. All rights reserved.
//

#import "ShareUITableViewCell.h"
#import "ShareUICollectionViewCell.h"


#define kActionSheetW [[UIScreen mainScreen] bounds].size.width
#define kActionSheetH [[UIScreen mainScreen] bounds].size.height


@interface ShareUITableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionV;

@end

static NSString *collectionCellIdentifier = @"ShareUICollectionViewCell";


@implementation ShareUITableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self collectionV];
        self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
        [self lineV];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIView *)lineV{
    if (_lineV == nil) {
        _lineV = [[UIView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_lineV];
        _lineV.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
    }
    return _lineV;
}


-(UICollectionView *)collectionV{

    if (_collectionV == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        // 定义 CollectionViewCell 大小
        layout.itemSize =CGSizeMake(70, 65);
        layout.sectionInset = UIEdgeInsetsMake(2, 8, 2, 8);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionV = [[UICollectionView alloc]initWithFrame:CGRectZero  collectionViewLayout:layout];
        _collectionV.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1];
        [_collectionV registerNib:[UINib nibWithNibName:@"ShareUICollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionCellIdentifier];
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        [self.contentView addSubview:_collectionV];
        _collectionV.alwaysBounceHorizontal = YES;
        _collectionV.showsHorizontalScrollIndicator = NO;
        
    }
    return _collectionV;
}

/**
 重新布局  子视图
 */
-(void)layoutSubviews{
    _collectionV.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, self.frame.size.height);
    
    _lineV.frame =CGRectMake(15,self.frame.size.height-1, [[UIScreen mainScreen] bounds].size.width-15,0.6);
}

#pragma mark collection 的代理实现

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShareUICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    ShareUIModel *shareModel = self.itemArr[indexPath.row];
    cell.itemLb.text = shareModel.itemName;
    cell.iconV.image = [UIImage imageNamed:shareModel.itemImgName];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.cellDelegate respondsToSelector:@selector(tableViewCell:didSelectedShareUISelcetIndex:)]) {
        [self.cellDelegate tableViewCell:self didSelectedShareUISelcetIndex:self.itemArr[indexPath.row].shareType];
    }
}

-(void)configData{
    [self.collectionV reloadData];
}

@end
