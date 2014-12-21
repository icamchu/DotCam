//
//  SendMessageToWeiboViewController.m
//  DotCam
//
//  Created by Cam on 14-12-18.
//  Copyright (c) 2014年 Cam. All rights reserved.
//
#import "AppDelegate.h"
#import "SendMessageToWeiboViewController.h"
#import "WeiboSDK.h"
@interface SendMessageToWeiboViewController ()
@property (strong, nonatomic) UIButton* shareButton;
@property (strong, nonatomic) UIButton* getFriendsButton;
@end

@implementation SendMessageToWeiboViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *ssoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ssoButton setTitle:@"Request SSO Authorize" forState:UIControlStateNormal];
    [ssoButton addTarget:self action:@selector(ssoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    ssoButton.frame = CGRectMake(20, 90, 280, 40);
    [self.view addSubview:ssoButton];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.shareButton.titleLabel.numberOfLines = 2;
    self.shareButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareButton setTitle:@"分享消息到微博" forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.shareButton.frame = CGRectMake(20, 120, 90, 110);
    [self.view addSubview:self.shareButton];
    
    
    self.getFriendsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.getFriendsButton.titleLabel.numberOfLines = 2;
    self.getFriendsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.getFriendsButton setTitle:@"朋友" forState:UIControlStateNormal];
    [self.getFriendsButton addTarget:self action:@selector(getFriendsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.getFriendsButton.frame = CGRectMake(20, 200, 90, 110);
    [self.view addSubview:self.getFriendsButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)ssoButtonPressed
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)shareButtonPressed
{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}


- (void)getFriendsButtonPressed
{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //just set extraPara for http request as you want, more paras description can be found on the API website,
    //for this API, details are from http://open.weibo.com/wiki/2/friendships/friends/en .
    NSMutableDictionary* extraParaDict = [NSMutableDictionary dictionary];
    [extraParaDict setObject:@"2" forKey:@"cursor"];
    [extraParaDict setObject:@"3" forKey:@"count"];
    
    [WBHttpRequest requestForFriendsListOfUser:myDelegate.wbCurrentUserID withAccessToken:myDelegate.wbtoken andOtherProperties:extraParaDict queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        //[self parseJSON:result];
        DemoRequestHanlder(httpRequest, result, error);
    }];
    UITableViewController* table = [[UITableViewController alloc] init];
    [self presentViewController:table animated:YES completion:^{
    }];
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = @"test";
    return message;
}

void DemoRequestHanlder(WBHttpRequest *httpRequest, id result, NSError *error)
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    if (error)
    {
        title = NSLocalizedString(@"请求异常", nil);
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:[NSString stringWithFormat:@"%@",error]
                                          delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                 otherButtonTitles:nil];
    }
    else
    {
        title = NSLocalizedString(@"收到网络回调", nil);
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:[NSString stringWithFormat:@"%@",result]
                                          delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                 otherButtonTitles:nil];
    }
    
    
    [alert show];
}

-(void) parseJSON:(id)results
{
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:results //1
                          options:nil
                          error:nil];
    
}

@end
