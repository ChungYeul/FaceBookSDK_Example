//
//  ViewController.m
//  FaceBookSDK_Example
//
//  Created by SDT-1 on 2014. 1. 21..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@interface ViewController ()<FBLoginViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *data;
@end

@implementation ViewController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FRIEND_CELL" forIndexPath:indexPath];
    NSDictionary *one = self.data[indexPath.row];
    cell.textLabel.text = one[@"name"];
    return cell;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [FBRequestConnection startWithGraphPath:@"me/friends"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  self.data = result[@"data"];
                                  // 메인 쓰레드에서 UI 업데이트
                                  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                      [self.table reloadData];
                                  }];
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"logout");
    [self.data removeAllObjects];
    [self.table reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 50);
    loginView.readPermissions = @[@"basic_info", @"email", @"user_likes"];
    loginView.delegate = self;
    [self.view addSubview:loginView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
