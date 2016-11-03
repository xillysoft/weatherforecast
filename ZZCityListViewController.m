//
//  ZZCityListViewController.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/3/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import "ZZCityListViewController.h"

@interface ZZCityListViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSArray<NSDictionary *> *_cityData;
    NSMutableArray<NSString *> *_provList; //derived from _cityData
    
    NSLayoutConstraint *_topGuideConstraint;
}

@end

@implementation ZZCityListViewController

-(void)loadView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.view = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _topGuideConstraint = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraint:_topGuideConstraint];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
}

-(void)_loadCityData
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"citylist_allchina" withExtension:@"json"];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] options:0 error:&error];
    _cityData = [json objectForKey:@"city_info"];
    //enumerate all provinces
    _provList = [NSMutableArray array];
    for(NSDictionary *cityInfo in _cityData){
        NSString *prov = [cityInfo objectForKey:@"prov"];
        if(! [_provList containsObject:prov]) {
            [_provList addObject:prov];
        }
    }
//    NSLog(@"--City Data loaded! Totally %d cities", [_cityData count]);
//    NSLog(@"\n\t Province List[%d]=%@", [_provList count], _provList);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _loadCityData];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    
    [_tableView registerClass:[UITableViewCell class]
       forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self _setupContraints];
    
}

-(void)viewWillLayoutSubviews
{
    CGFloat topGuide = [[UIApplication sharedApplication] statusBarFrame].size.height;
    [_topGuideConstraint setConstant:topGuide];
    [super viewWillLayoutSubviews];
//    NSLog(@"--viewWillLayoutSubViews! topGuide=%@", @(topGuide));
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)_setupContraints
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_provList count];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionProv = [_provList objectAtIndex:section];
    NSInteger count = 0;
    //filter all city with section-province
    for(NSDictionary *cityInfo in _cityData){
        if([[cityInfo objectForKey:@"prov"] isEqualToString:sectionProv]){
            count ++;
        }
    }
    return count;
}

-(NSDictionary *)_getCityInfoAtIndexPath:(NSIndexPath *)indexPath
{
    //find city at indexPath
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *sectionProv = [_provList objectAtIndex:section];
    NSInteger count = 0;
    for(NSDictionary *cityInfo in _cityData){
        if([[cityInfo objectForKey:@"prov"] isEqualToString:sectionProv]){
            count ++;
            if(count == row+1){
                return cityInfo;
                break;
            }
        }
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cityInfo = [self _getCityInfoAtIndexPath:indexPath];
    NSAssert(cityInfo!=nil && [cityInfo objectForKey:@"city"]!=nil, @"Assertion Failed: City at indexPath:%@-%@ not found!", @(indexPath.section), @(indexPath.row));
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    [[cell textLabel] setText:[cityInfo objectForKey:@"city"]];
    return cell;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    NSLog(@"--secionInexTitlesForTableView: ! secionIndexTitles=\n\t%@", [_provList componentsJoinedByString:@"\n\t"]);
    return _provList;
}

#pragma mark -

#pragma mark UITableViewDelegate
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionProv = [_provList objectAtIndex:section];
    return sectionProv;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        [header.textLabel setFont:[UIFont boldSystemFontOfSize:24]];
        [header.textLabel setTextColor:[UIColor darkGrayColor]];
    }
}

-(UIView *)tableView:(UITableView *)tableView ___viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionProv = [_provList objectAtIndex:section];
//    NSLog(@"--tableView:viewForHeaderInSection:%d --> %@", section, sectionProv);
    NSString *identifier = NSStringFromClass([UITableViewHeaderFooterView class]);
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if(header == nil){
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    }
    [header.contentView setBackgroundColor:[UIColor clearColor]];
    UILabel *label;
    if([[header.contentView subviews] count] > 0){
        label = [[header.contentView subviews] objectAtIndex:0];
    }else{
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [header.contentView addSubview:label];
        
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [header.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:header.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5]];
        [header.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:header.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5]];
        [header.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:header.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10]];
        [header.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:header.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5]];
    }
    
    [label setAttributedText:({
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24],
                                     NSForegroundColorAttributeName: [UIColor redColor]};
        [[NSAttributedString alloc] initWithString:sectionProv
                                        attributes:attributes];
    })];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    static NSNumber *cachedHeight = nil;
    if(cachedHeight == nil){
        if([self respondsToSelector:@selector(tableView:viewForHeaderInSection:)]){
            UIView *view = [self tableView:tableView viewForHeaderInSection:0];
            CGSize size = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            NSLog(@"--tableView:heightForHeaderInSectin:%d --> %@", section, NSStringFromCGSize(size));
            cachedHeight = @(size.height);
        }else{
            cachedHeight = @(20);
        }
    }
    return [cachedHeight floatValue];
//    return [[UIFont boldSystemFontOfSize:32] capHeight] + 5*2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *cityInfo = [self _getCityInfoAtIndexPath:indexPath];
    NSString *cityId = [cityInfo objectForKey:@"id"];
    NSString *cityName = [cityInfo objectForKey:@"city"];
    NSLog(@"--City: %@ [%@] selected!", cityName, cityId);
    [self.delegate cityDidSelectWithId:cityId cityName:cityName];
    
}

#pragma mark -

@end
