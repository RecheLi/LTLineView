# LTLineView
最近因项目需求而写的一个体重折线图

## 示例代码
```
- (void)getLineData {
    // 假装从网络请求数据
    [self.weightData removeAllObjects];
    [self.predictWeightData removeAllObjects];
    NSMutableArray *temp1 = [NSMutableArray array];
    NSMutableArray *temp2 = [NSMutableArray array];
    for (int i=0; i<21; i++) {
        NSDictionary *weight = @{@"date":[NSString stringWithFormat:@"%@",@(1000+i)],@"weight":[NSString stringWithFormat:@"%.1f",50.1+(random() % 10 -13.5)]};
        
        if (i==5 || i==7 || i==8) {
            weight = @{@"date":[NSString stringWithFormat:@"%@",@(1000+i)],@"weight":@"0.0"};
        }
        [temp1 addObject:weight];
    }
    for (int i=0; i<21; i++) {
        NSDictionary *weight = @{@"date":[NSString stringWithFormat:@"%@",@(1000+i)],@"weight":@"0.0"};
        if (i % 7 == 0) {
            weight = @{@"date":[NSString stringWithFormat:@"%@",@(1000+i)],@"weight":[NSString stringWithFormat:@"%1.f",48.1+(random() % 10 -11.5)]};
        }
        [temp2 addObject:weight];
    }
    NSDictionary *dic = @{@"minWeight":@"20.0",@"maxWeight":@"80.0",@"realWeights":temp1,@"dashWeights":temp2};
    LTLineData *lineData = [LTLineData mj_objectWithKeyValues:dic];
    [lineData setupReallinePoints];
    [lineData setupDashlinePoints];
    self.weightData = lineData.realWeights.mutableCopy;
    self.predictWeightData = lineData.dashWeights.mutableCopy;
}

- (void)showLineView {
    LTLine *lineView = [[LTLine alloc]initWithFrame:({
        CGRect rect = {0,0,kScreenWidth,kScreenHeight};
        rect;
    })];
    lineView.realPoints = self.weightData;
    lineView.dashPoints = self.predictWeightData;
    [self.view addSubview:lineView];
}

```

## 效果图
![image](https://raw.githubusercontent.com/Cherishforever/LTLineView/master/LTLineView/lineExample.png)
