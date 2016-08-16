//
//  NetViewController.m
//  Tank90
//
//  Created by song on 15/6/10.
//
//

#import "NetViewController.h"
#import "BonjourHelper.h"
@interface NetViewController ()

@end

@implementation NetViewController
@synthesize dataDelegate;
-(void) setDataDelegate:(id)_del
{
    dataDelegate=_del;
    [BonjourHelper sharedInstance].sessionID = @"TypingTogether";
    [BonjourHelper sharedInstance].dataDelegate = _del;
    [BonjourHelper assignViewController:self];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
