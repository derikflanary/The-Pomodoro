//
//  POHistoryViewController.m
//  The Pomodoro
//
//  Created by Derik Flanary on 1/20/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "POHistoryViewController.h"
#import "POTimerViewController.h"

@interface POHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, assign)NSInteger currentRound;

@property(nonatomic, strong)UITableView *tableView;

@end

@implementation POHistoryViewController


- (void)viewDidLoad {
    [self registerForNotifications];
    self.title  = @"Rounds";
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

-(void)registerForNotifications{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endRound:) name:roundOverNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:roundOverNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray*)times{
    return @[@25,@5,@25,@5,@25,@5,@25,@15];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self times]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell One"];
    if (!cell){
        cell = [UITableViewCell new];
    }
    NSArray * roundArray = [self times];
    cell.textLabel.text = [NSString stringWithFormat:@"Round %ld : %@ min", indexPath.row + 1, [[roundArray objectAtIndex:indexPath.row]stringValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentRoundNotification" object:nil userInfo:nil];
    self.currentRound = indexPath.row;
    [self postMinutes];
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    //[self.navigationController pushViewController:timerViewController animated:NO];
}


-(void)postMinutes{
    //NSInteger minForRound = [self times][self.currentRound];
    [[NSNotificationCenter defaultCenter]postNotificationName:roundMinutesKey object:nil userInfo:@{roundMinutesKey:[self times][self.currentRound], roundTitleKey:[NSString stringWithFormat:@"Round %lu",self.currentRound+1]}];
    //roundTitleKey = [NSString stringWithFormat:@"Round %lu", self.currentRound];
    

}

-(void)endRound:(NSNotification *)notification{
     self.currentRound ++;
    
    if (self.currentRound == [[self times]count]){
        self.currentRound = 0;
    }
    
    [self setCurrentRound];
    [self postMinutes];
}

-(void)setCurrentRound{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentRound inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
