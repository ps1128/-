//
//  rankViewController.m
//  test
//
//  Created by 裴骕 on 2017/8/19.
//  Copyright © 2017年 裴骕. All rights reserved.
//

#import "rankViewController.h"
#import "PSRankTableView.h"

@interface rankViewController ()

@end

@implementation rankViewController {
    PSRankTableView *_kTableView;
    UIView *_kBarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //上边框
    _kBarView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:_kBarView];
    _kBarView.backgroundColor = [UIColor blackColor];
    //排行榜标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 80)/2, 30, 80, 20)];
    [_kBarView addSubview:titleLabel];
    titleLabel.text = @"排行榜";
    titleLabel.textColor = [UIColor whiteColor];
    //回转按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 30, 30)];
    [_kBarView addSubview:leftButton];
    [leftButton addTarget:self action:@selector(rollbackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //排行榜布局
    _kTableView = [PSRankTableView new];
    [self.view addSubview:_kTableView];
    //获取数据库Bmob数据
    [self getDataFromBmob];
}


- (void)getDataFromBmob {
    BmobQuery   *bquery = [BmobUser query]; //用户表
    [bquery orderByDescending:@"score"];
    [SVProgressHUD showWithStatus:@"请稍等..."];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSMutableArray *userArr = [@[] mutableCopy];
        for (BmobObject *obj in array) {
            //字典对应
            NSMutableDictionary *dict = [@{} mutableCopy];
            dict[@"username"] = [obj objectForKey:@"username"];
            dict[@"score"] = [obj objectForKey:@"score"];
            [userArr addObject:dict];
        }
        [SVProgressHUD dismiss];
        [self arrSort:userArr];
        _kTableView.tableDataArray = userArr;
    }];
}

- (void)rollbackBtnClick {
    //回滚操作
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)insertSort:(int [100]) a and: (int) n {
    for(int i= 1; i<n; i++){
        if(a[i] < a[i-1]){
            //若第i个元素大于i-1元素，直接插入。小于的话，移动有序表后插入
            int j= i-1;
            int x = a[i];        //复制为哨兵，即存储待排序元素
            a[i] = a[i-1];           //先后移一个元素
            while(x < a[j]){  //查找在有序表的插入位置
                a[j+1] = a[j];
                j--;         //元素后移
            }
            a[j+1] = x;      //插入到正确位置
        }
    }
}

- (void)arrSort:(NSArray *)dataArr {
    //排序
    int tempNum[100];
    for (int i = 0; i < dataArr.count; i ++) {
        NSString *str = [dataArr objectAtIndex:i][@"score"];
        int tempInt = (int)[str integerValue];
        tempNum[i] =tempInt;
    }
    
//    for (int i = 0; i < dataArr.count; i++) {
//    }
    [self insertSort:&tempNum[100]and:dataArr.count];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    //显示上边框
    return UIStatusBarStyleLightContent;
}

@end
