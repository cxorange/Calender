//
//  ViewController.m
//  test
//
//  Created by  on 2017/5/1.
//  Copyright © 2017年. All rights reserved.
//

#import "ViewController.h"
#import "TimeCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *arr;
    NSDate  *golableDate;
    UILabel *dateLabel;

}
@property (nonatomic, strong) NSCalendar *calender;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *str;
@end

@implementation ViewController
- (NSCalendar *)calender{
    if (!_calender) {
        _calender = [NSCalendar currentCalendar];
        _calender.firstWeekday = 2;
        _calender.minimumDaysInFirstWeek = 1;
    }
    return _calender;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 350) collectionViewLayout:layout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[TimeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        layout.itemSize     = CGSizeMake(_collectionView.frame.size.width / 7, _collectionView.frame.size.height / 7);
        
        
        layout.minimumLineSpacing      = 0;
        layout.minimumInteritemSpacing = 0;
        [_collectionView setCollectionViewLayout:layout animated:YES];
    }
    return _collectionView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return arr.count;
    }else{
        NSInteger i = [self currentMonthHaveDays];
        return i + 7;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        cell.dateLabel.text = arr[indexPath.row];
        
    }else{
        NSInteger daysCount    = [self currentMonthHaveDays];
        NSInteger firstWeekDay = [self monthWithFirstWeekDay];
        NSInteger i = indexPath.row;
        NSInteger day = i - firstWeekDay + 1;
        
        
        if (i < firstWeekDay) {
            [cell.dateLabel setText:@""];
        }else if (i > firstWeekDay + daysCount - 1){
            [cell.dateLabel setText:@""];
        }else{
            
            [cell.dateLabel setText:[NSString stringWithFormat:@"%li",(long)day]];
            
            
        }
        
        
    }
    return cell;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    arr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    self.view.backgroundColor = [UIColor redColor];
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    NSArray * t_arr = @[@"-",@"+"];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * (self.view.frame.size.width - 44), 0, 44, 44);
        btn.tag   = i;
        btn.backgroundColor = [UIColor blueColor];
        [btn setTitle:t_arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(calendarChooseClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width / 2 - 50, 0, 100, 44)];
    [view addSubview:label];
    [self.view addSubview:view];
    [self.view addSubview:self.collectionView];
    golableDate = [NSDate date];
    dateLabel   = label;
    
}
//得到这个月第一天是星期几
- (NSInteger)monthWithFirstWeekDay{
    NSDateComponents * oldComponent = [self.calender components:kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay fromDate:golableDate];
    NSDateComponents * component = [[NSDateComponents alloc] init];
    component.year   = oldComponent.year;
    component.month  = oldComponent.month;
    component.day    = 1;
    
    NSDate * newDate = [_calender dateFromComponents:component];
    
    NSInteger w      = [_calender ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:newDate];
    if (w == 7) {
        w = 0;
    }
    return w;
    
}
//改变月份
- (NSDate *)changeMonthGetDate:(NSDate *)oldDate withChooseTag:(NSInteger)tag{
    NSDateComponents *component = [[NSDateComponents alloc] init];
    if (tag == 0) {
        component.month = -1;
    }else{
        component.month = +1;
    }
    NSDate *newDate = [_calender dateByAddingComponents:component toDate:oldDate options:0];

    return newDate;
}
//获取当前月份多少天
- (NSInteger)currentMonthHaveDays{
    NSRange    range  = [self.calender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:golableDate];
    NSInteger  days   = range.length;
    
    return days;
}


- (void)calendarChooseClick:(UIButton *)sender{
    UIViewAnimationOptions options;
    if (sender.tag == 0) {
        options = UIViewAnimationOptionTransitionCurlDown;
    }else{
        options = UIViewAnimationOptionTransitionCurlUp;
    }
    [UIView transitionWithView:_collectionView duration:0.5 options:options animations:^{
        golableDate = [self changeMonthGetDate:golableDate withChooseTag:sender.tag];
        NSDateFormatter * formatter = [[NSDateFormatter  alloc]init];
        formatter.dateFormat = @"YYYY-MM-dd";
        NSString *dateStr = [formatter stringFromDate:golableDate];
        dateLabel.text = dateStr;
        [self.collectionView reloadData];
    } completion:nil];
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
