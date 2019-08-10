# DataSynchronized
a solution for iOS data synchronization

#### What for

实现本地数据双向绑定，修改一处数据，其他数据自动同步的功能。主要解决有数据同步需求但采用Notification管理开发和维护都很不友好，重新拉取网络请求不方便（比如有分页）且有延时的问题.

#### Featured

* 一行代码调用，数据一处修改，其他绑定数据自动同步
* 内存占用小，绑定耗时短
* 采用kvo实现，但调用者无需关心内存以及监听的释放
* 内存依赖于绑定的model，model dealloc时自动释放内存和监听移除
* 数据路径加载采用kvc实现，支持多级路径
* 支持同种数据绑定，不同种数据映射绑定

#### How To Use

* clone并将```DataSync```文件夹拖入项目

* 在需要绑定数据处import```DataSynchronized.h```

* 同种数据类型

  ```objective-c
  //在获取到数据后进行数据源绑定,如果有多个字段用逗号间隔,支持多级路径
      __weak typeof(self)weakSelf = self;
      [_data addDataSynchronizedKeyPath:@"isFollow,myName,otherModel.otherName" IDPath:@"myID" onChange:^(MyModel *  _Nonnull model) {
          //数据改变回调,UI操作
          [weakSelf.tableView reloadData];
      }];
      return _data;
  ```

* 不同数据类型

  ```objective-c
      /*
       把data绑定到MyModel类上
       data.otherName与MyModel.myName绑定
       将data.othrID作为绑定的改变标识符
       */
      [_data bindingDataSynchronizedTo:MyModel.class keyPaths:@{@"myName":@"otherName"} IDPath:@"otherID" onChange:^(OtherModel * _Nonnull model) {
          //数据改变回调,UI操作
          weakSelf.textField.text = model.otherName;
      }];
      return _data;
  ```

  ![DataSyncGif](/Users/huhaha/Desktop/DataSynchronized/DataSyncGif.gif)

