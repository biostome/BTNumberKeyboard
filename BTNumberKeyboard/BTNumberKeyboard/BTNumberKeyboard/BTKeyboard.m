//
//  BTKeyboard.m
//  BTNumberKeyboard
//
//  Created by leishen on 2020/1/29.
//  Copyright © 2020 leishen. All rights reserved.
//

#import "BTKeyboard.h"

@interface BTKeyboardCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NSNumber *textData;
@end

@implementation BTKeyboardCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
}

- (void)setTextData:(NSNumber *)textData{
    _textData = textData;
    if ([textData isEqualToNumber:@(10)]) {
        self.contentView.backgroundColor = UIColor.clearColor;
    }
    else if ([textData isEqualToNumber:@(12)]){
        self.textLabel.text = @"删除";
        self.contentView.backgroundColor = UIColor.clearColor;
    }
    else{
        self.textLabel.text = textData.stringValue;
        self.contentView.backgroundColor = UIColor.whiteColor;
    }
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = [UIFont systemFontOfSize:28];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.userInteractionEnabled = NO;
        _textLabel.backgroundColor = UIColor.clearColor;
    }
    return _textLabel;
}

@end

@interface BTKeyboard ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSNumber*> *dataSource;
@end

@implementation BTKeyboard


- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.collectionView];

    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BOOL respone = [self.delegate respondsToSelector:@selector(mkNumberKeyboard:didSelectItem:)];
    if (respone) {
        NSNumber * number = self.dataSource[indexPath.row];
        if ([number isEqualToNumber:@(10)]) {
            return;
        }
        [self.delegate mkNumberKeyboard:self didSelectItem:number];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BTKeyboardCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(BTKeyboardCell.class) forIndexPath:indexPath];
    cell.textData = self.dataSource[indexPath.row];
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((CGRectGetWidth(collectionView.frame) / 3)-1, (CGRectGetHeight(collectionView.frame)/4)-1);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0.6, 0, 0.6, 0);
}

- (NSArray<NSNumber*>*)dataSource{
    if (!_dataSource) {
        NSMutableArray<NSNumber*> * datas = [NSMutableArray new];
        for (int i=1; i<=12; i++) {
            [datas addObject:@(i)];
        }
        NSInteger index = [datas indexOfObject:@(11)];
        [datas replaceObjectAtIndex:index withObject:@(0)];
        _dataSource = datas;
    }
    return _dataSource;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:BTKeyboardCell.class forCellWithReuseIdentifier:NSStringFromClass(BTKeyboardCell.class)];
        _collectionView.backgroundColor = UIColor.separatorColor;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

@end
