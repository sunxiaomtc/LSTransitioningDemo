//
//  ViewController.m
//  LSTransitioningDemo
//
//  Created by gankai on 2018/11/15.
//  Copyright © 2018年 laoSun. All rights reserved.
//

#import "ViewController.h"
#import "ImageCell.h"
#import "LSImageEnlargeManager.h"
#import "UIImageView+LongImageShowView.h"

#define kScreenW ([[UIScreen mainScreen]bounds].size.width)
#define kScreenH ([[UIScreen mainScreen]bounds].size.height)

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *imageArrays;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    for(int i = 0; i < 3;i ++)
    {
        [self.imageArrays addObject:[UIImage imageNamed:@"WechatIMG32886"]];
        [self.imageArrays addObject:[UIImage imageNamed:@"WechatIMG9"]];
        [self.imageArrays addObject:[UIImage imageNamed:@"WechatIMG11"]];
    }
    
    [self setupTableView];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(12, 20, kScreenW - 24, 300);
//    btn.backgroundColor = [UIColor greenColor];
//    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
}

-(void)btnClick:(UIButton *)sender
{
    NSURL * myURL_APP_A = [NSURL URLWithString:@"alipays://"];
    
    if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        // 跳转付款码
        NSURL * url = [NSURL URLWithString:@"alipays://platformapi/startapp?appId=60000098&snapshot=no&canPullDown=NO&showOptionMenu=NO&url=/www/offline_qrcode.html?cardType=S0330100&source=shortCut&transparentTitle=auto"];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}

-(void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageArrays.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //__weak typeof(self) weakSelf = self;
    __weak ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.image = self.imageArrays[indexPath.row];
    __weak __typeof(self) weakSelf = self;
    cell.tapImageBlock = ^{
        //原本位置图片隐藏，也可不加
        cell.imgView.hidden = YES;
        
        //获取图片当前坐标
        CGRect currentRect = [cell convertRect:cell.imgView.frame toView:weakSelf.view];
        [[LSImageEnlargeManager sharedManager] setFormViewController:weakSelf imageCGrect:currentRect Image:[cell.imgView screenShotView] originalImage:weakSelf.imageArrays[indexPath.row]];
        
        [LSImageEnlargeManager sharedManager].didDismissBlock = ^{
            cell.imgView.hidden = NO;
        };
    };
    return cell;
}


-(NSMutableArray *)imageArrays
{
    if(!_imageArrays)
    {
        _imageArrays = [[NSMutableArray alloc] init];
    }
    return _imageArrays;
}


@end
