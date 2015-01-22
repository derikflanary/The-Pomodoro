//
//  POTimerViewController.m
//  The Pomodoro
//
//  Created by Derik Flanary on 1/20/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "POTimerViewController.h"
#import "POHistoryViewController.h"

@interface POTimerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *startTimerButton;
@property (nonatomic, assign)NSInteger minutes;
@property (nonatomic, assign)NSInteger seconds;
@property (nonatomic, assign)BOOL timerRunning;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

@end

@implementation POTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForNotifications];
    
    self.view.backgroundColor = [UIColor redColor];
    self.minutes = 25;
    self.seconds = 0;
    self.pauseButton.enabled = NO;
    self.pauseButton.alpha = 0;
    self.title = @"Round 1";
    [self updateLabel];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)registerForNotifications{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newRound:) name:roundMinutesKey object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:roundMinutesKey object:nil];
}



- (IBAction)timerButtonPressed:(id)sender {
    self.startTimerButton.enabled = NO;
    self.startTimerButton.alpha = .5;
    self.timerRunning = YES;
    [self performSelector:@selector(decreaseTime) withObject:nil afterDelay:1.0];
}

-(void)decreaseTime{
    if (self.seconds > 0){
        self.seconds --;
    }
    
    if (self.minutes > 0){
        if (self.seconds == 0){
            self.minutes --;
            self.seconds = 59;
        }

    }else if (self.seconds == 0){
        self.startTimerButton.enabled = YES;
        self.timerRunning = NO;
        self.startTimerButton.alpha = 1;
        [[NSNotificationCenter defaultCenter]postNotificationName:roundOverNotification object:nil userInfo:nil];
    }
    
    [self updateLabel];
    
    if (self.timerRunning == YES){
        [self performSelector:@selector(decreaseTime) withObject:nil afterDelay:1.0];
    }
    
}

-(void)updateLabel{
    if (self.seconds > 9) {
    self.timerLabel.text = [NSString stringWithFormat:@"%lu:%lu", self.minutes, self.seconds];
    }else{
        self.timerLabel.text = [NSString stringWithFormat:@"%lu:0%lu", self.minutes, self.seconds];
    }
    if (self.timerRunning){
        self.pauseButton.enabled = YES;
        self.pauseButton.alpha = 1;
    }
}

-(void)newRound:(NSNotification *)notification{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(decreaseTime) object:nil];
    self.minutes = [notification.userInfo[roundMinutesKey]integerValue];
    self.seconds = 0;
    self.title = notification.userInfo[roundTitleKey];
    self.startTimerButton.enabled = YES;
    self.startTimerButton.alpha = 1;
    [self updateLabel];
}
- (IBAction)pausePressed:(id)sender {
    self.startTimerButton.enabled = YES;
    self.startTimerButton.alpha = 1;
    self.pauseButton.alpha = 0;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(decreaseTime) object:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
