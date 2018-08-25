//
//  FQFilterListViewController.m
//  LearnCoreImage
//
//  Created by fan qi on 2018/7/13.
//  Copyright © 2018年 fan qi. All rights reserved.
//

#import "FQFilterListViewController.h"

NSString * const ReuseID = @"TableViewCell";

@interface FQFilterListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray *> *dataDic;

@end

@implementation FQFilterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataDic.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataDic objectForKey:self.dataDic.allKeys[section]] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), tableView.sectionHeaderHeight)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = self.dataDic.allKeys[section];
    label.font = [UIFont boldSystemFontOfSize:18];
    [label sizeToFit];
    label.center = CGPointMake(12 + CGRectGetWidth(label.bounds) * 0.5, CGRectGetHeight(view.bounds) * 0.5);
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseID];
    cell.textLabel.text = [[self.dataDic objectForKey:self.dataDic.allKeys[indexPath.section]] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *filterName = [[self.dataDic objectForKey:self.dataDic.allKeys[indexPath.section]] objectAtIndex:indexPath.row];
    CIFilter *filter = [CIFilter filterWithName:filterName];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:filter.name
                                                                   message:[NSString stringWithFormat:@"%@", filter.attributes]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.rowHeight = 50;
        tableView.sectionHeaderHeight = 50;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ReuseID];
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (NSMutableDictionary<NSString *,NSArray *> *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
        
        /*
         kCICategoryVideo,
         kCICategoryStillImage,
         kCICategoryInterlaced,
         kCICategoryNonSquarePixels,
         kCICategoryHighDynamicRange
         
         
         kCICategoryBuiltIn
         */
        NSArray *categories = @[kCICategoryDistortionEffect, kCICategoryGeometryAdjustment, kCICategoryCompositeOperation, kCICategoryHalftoneEffect, kCICategoryColorAdjustment, kCICategoryColorEffect, kCICategoryTransition, kCICategoryTileEffect, kCICategoryGenerator, kCICategoryReduction, kCICategoryGradient, kCICategoryStylize, kCICategorySharpen, kCICategoryBlur, kCICategoryFilterGenerator];
        
        for (NSString *category in categories) {
            [_dataDic setValue:[CIFilter filterNamesInCategory:category] forKey:category];
        }
    }
    return _dataDic;
}

@end
