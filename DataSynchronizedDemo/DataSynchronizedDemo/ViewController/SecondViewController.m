//
//  SecondViewController.m
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/8/5.
//  Copyright © 2019 piu. All rights reserved.
//

#import "SecondViewController.h"
#import "MyTableViewCell.h"
#import "MyModel.h"
#import "DataSynchronized.h"

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *cellID = @"MyTableViewCell";

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    // Do any additional setup after loading the view.
}

#pragma mark - UI

- (void)configView{
    [self data];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
}

#pragma mark - delegate & datasource

#pragma mark - tableview datasource & delegate
//number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
//cell for
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.data[indexPath.row];
    return cell;
}
//height for row
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
//height for header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}
//height for footer
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
//did select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - action

#pragma mark - method & utils

#pragma mark - net request

#pragma mark - setter & getter
-(NSArray *)data{
    if (!_data) {
        NSMutableArray *array = @[].mutableCopy;
        for (int i = 0; i < 10; i+=2) {
            MyModel *tmp = [[MyModel alloc] initWithMyID:[NSString stringWithFormat:@"%d",i] myName:[NSString stringWithFormat:@"Jason Derulo NO.%d",i] isFollow:false];
            [array addObject:tmp];
        }
        _data = [NSArray arrayWithArray:array];
    }
    //在获取到数据后进行数据源绑定,如果有多个字段用逗号间隔,支持嵌套路径
    __weak typeof(self)weakSelf = self;
    [_data addDataSynchronizedKeyPath:@"isFollow,myName,otherModel.otherName" IDPath:@"myID" onChange:^(MyModel *  _Nonnull model) {
        //UI操作
        [weakSelf.tableView reloadData];
    }];
    return _data;
}

@end
