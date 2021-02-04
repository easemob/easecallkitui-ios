//
//  EaseCallMultiViewController.m
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/19.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallMultiViewController.h"
#import "EaseCallStreamView.h"
#import "EaseCallManager+Private.h"
#import "EaseCallPlaceholderView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Ext.h"

@interface EaseCallMultiViewController ()<EaseCallStreamViewDelegate>
@property (nonatomic) UIButton* inviteButton;
@property (nonatomic) UILabel* statusLable;
@property (nonatomic) BOOL isJoined;
@property (nonatomic) EaseCallStreamView* bigView;
@property (nonatomic) NSMutableDictionary* placeHolderViewsDic;
@end

@implementation EaseCallMultiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubViews];
    [self updateViewPos];
}

- (void)setupSubViews
{
    self.bigView = nil;
    self.view.backgroundColor = [UIColor grayColor];
    [self.timeLabel setHidden:YES];
    self.inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.inviteButton setImage:[UIImage imageNamedFromBundle:@"invite"] forState:UIControlStateNormal];
    [self.inviteButton addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.inviteButton];
    [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.right.equalTo(self.view);
        make.width.height.equalTo(@50);
    }];
    [self.view bringSubviewToFront:self.inviteButton];
    [self.inviteButton setHidden:YES];
    [self setLocalVideoView:[UIView new] enableVideo:NO];
    {
        if([self.inviterId length] > 0) {
            NSURL* remoteUrl = [[EaseCallManager sharedManager] getHeadImageFromUid:self.inviterId];
            self.remoteHeadView = [[UIImageView alloc] init];
            [self.view addSubview:self.remoteHeadView];
            [self.remoteHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@80);
                make.centerX.equalTo(self.view);
                make.top.equalTo(@100);
            }];
            [self.remoteHeadView sd_setImageWithURL:remoteUrl];
            self.remoteNameLable = [[UILabel alloc] init];
            self.remoteNameLable.backgroundColor = [UIColor clearColor];
            //self.remoteNameLable.font = [UIFont systemFontOfSize:19];
            self.remoteNameLable.textColor = [UIColor whiteColor];
            self.remoteNameLable.textAlignment = NSTextAlignmentRight;
            self.remoteNameLable.font = [UIFont systemFontOfSize:24];
            self.remoteNameLable.text = [[EaseCallManager sharedManager] getNicknameFromUid:self.inviterId];
            [self.timeLabel setHidden:YES];
            [self.view addSubview:self.remoteNameLable];
            [self.remoteNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.remoteHeadView.mas_bottom).offset(20);
                make.centerX.equalTo(self.view);
            }];
            self.statusLable = [[UILabel alloc] init];
            self.statusLable.backgroundColor = [UIColor clearColor];
            self.statusLable.font = [UIFont systemFontOfSize:15];
            self.statusLable.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            self.statusLable.textAlignment = NSTextAlignmentRight;
            self.statusLable.text = @"邀请你进行音视频会话";
            self.answerButton.hidden = NO;
            self.acceptLabel.hidden = NO;
            [self.view addSubview:self.statusLable];
            [self.statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.remoteNameLable.mas_bottom).offset(20);
                make.centerX.equalTo(self.view);
            }];
        }else{
            self.answerButton.hidden = YES;
            self.acceptLabel.hidden = YES;
            [self.hangupButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.width.height.equalTo(@60);
                make.bottom.equalTo(self.view).with.offset(-40);
            }];
            self.isJoined = YES;
            self.localView.hidden = NO;
            [self enableVideoAction];
            self.inviteButton.hidden = NO;
        }
    }
//    for(int i = 0;i<5;i++) {
//        [self addRemoteView:[UIView new] member:[NSNumber numberWithInt:i] enableVideo:NO];
//    }
    [self updateViewPos];
}

- (NSMutableDictionary*)streamViewsDic
{
    if(!_streamViewsDic) {
        _streamViewsDic = [NSMutableDictionary dictionary];
    }
    return _streamViewsDic;
}

- (NSMutableDictionary*)placeHolderViewsDic
{
    if(!_placeHolderViewsDic) {
        _placeHolderViewsDic = [NSMutableDictionary dictionary];
    }
    return _placeHolderViewsDic;
}

- (void)addRemoteView:(UIView*)remoteView member:(NSNumber*)uId enableVideo:(BOOL)aEnableVideo
{
    EaseCallStreamView* view = [[EaseCallStreamView alloc] init];
    view.displayView = remoteView;
    view.enableVideo = aEnableVideo;
    view.delegate = self;
    [view addSubview:remoteView];
    [self.view addSubview:view];
    [remoteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
    }];
    [view sendSubviewToBack:remoteView];
    [self.view sendSubviewToBack:view];
    [self.streamViewsDic setObject:view forKey:uId];
    [self startTimer];
    [self updateViewPos];
}

- (void)setRemoteViewNickname:(NSString*)aNickname headImage:(NSURL*)url uId:(NSNumber*)aUid
{
    EaseCallStreamView* view = [self.streamViewsDic objectForKey:aUid];
    if(view) {
        view.nameLabel.text = aNickname;
        [view.bgView sd_setImageWithURL:url];
    }
}

- (void)removeRemoteViewForUser:(NSNumber*)uId
{
    EaseCallStreamView* view = [self.streamViewsDic objectForKey:uId];
    if(view) {
        [view removeFromSuperview];
        [self.streamViewsDic removeObjectForKey:uId];
    }
    [self updateViewPos];
}
- (void)setRemoteMute:(BOOL)aMuted uid:(NSNumber*)uId
{
    EaseCallStreamView* view = [self.streamViewsDic objectForKey:uId];
    if(view) {
        view.enableVoice = !aMuted;
    }
}
- (void)setRemoteEnableVideo:(BOOL)aEnabled uId:(NSNumber*)uId
{
    EaseCallStreamView* view = [self.streamViewsDic objectForKey:uId];
    if(view) {
        view.enableVideo = aEnabled;
    }
    if(view == self.bigView && !aEnabled)
        self.bigView = nil;
    [self updateViewPos];
}

- (void)setLocalVideoView:(UIView*)aDisplayView  enableVideo:(BOOL)aEnableVideo
{
    self.localView = [[EaseCallStreamView alloc] init];
    self.localView.displayView = aDisplayView;
    self.localView.enableVideo = aEnableVideo;
    self.localView.delegate = self;
    self.localView.nameLabel.text = [[EaseCallManager sharedManager] getNicknameFromUid:[EMClient sharedClient].currentUsername ];
    [self.localView addSubview:aDisplayView];
    int width = self.view.bounds.size.width/2;
    self.localView.frame = CGRectMake(0, 60, width, width);
    [aDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.localView);
    }];
    [self.localView sendSubviewToBack:aDisplayView];
    [self.view addSubview:self.localView];
    [self.localView.bgView sd_setImageWithURL:[[EaseCallManager sharedManager] getHeadImageFromUid:[EMClient sharedClient].currentUsername]];
    [self.view sendSubviewToBack:self.localView];
    [self updateViewPos];
    self.answerButton.hidden = YES;
    self.acceptLabel.hidden = YES;
    
    [self.enableCameraButton setEnabled:YES];
    self.enableCameraButton.selected = YES;
    [self.switchCameraButton setEnabled:YES];
    [self.microphoneButton setEnabled:YES];
    if([self.inviterId length] > 0) {
        [self.remoteNameLable removeFromSuperview];
        [self.statusLable removeFromSuperview];
        [self.remoteHeadView removeFromSuperview];
    }
    self.localView.hidden = YES;
}

- (UIView*) getViewByUid:(NSNumber*)uId
{
    EaseCallStreamView*view =  [self.streamViewsDic objectForKey:uId];
    if(view)
        return view.displayView;
    return nil;
}

- (void)updateViewPos
{
    unsigned long count = self.streamViewsDic.count + self.placeHolderViewsDic.count;
    if(self.localView.displayView)
        count++;
    int index = 0;
    int top = 60;
    int left = 0;
    int right = 0;
    int colSize = 1;
    int colomns = count>6?3:2;
    int bottom = 200;
    int cellwidth = (self.view.frame.size.width - left - right - (colomns - 1)*colSize)/colomns ;
    int cellHeight = (self.view.frame.size.height - top - bottom)/(count > 6?5:3);
    if(count < 5)
        cellHeight = cellwidth;
    //int cellwidth = (self.view.frame.size.width - left - right - (colomns - 1)*colSize)/colomns ;
    //int cellHeight = MIN(cellHeightH, cellWidthV);
    //int cellwidth = cellHeight
    if(self.isJoined) {
        
        self.microphoneButton.hidden = NO;
        self.microphoneLabel.hidden = NO;
        self.enableCameraButton.hidden = NO;
        self.enableCameraLabel.hidden = NO;
        self.speakerButton.hidden = NO;
        self.speakerLabel.hidden = NO;
        self.switchCameraButton.hidden = NO;
        self.switchCameraLabel.hidden = NO;
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.inviteButton);
            make.width.equalTo(@100);
        }];
        if(self.bigView) {
            self.bigView.frame = CGRectMake(0, top, self.view.bounds.size.width, self.view.bounds.size.height-top-bottom);
            if(self.bigView != self.localView) {
                [self.view sendSubviewToBack:self.localView];
            }
            NSArray* views = [self.streamViewsDic allValues];
            for(EaseCallStreamView* view in views) {
                if(self.bigView != view) {
                    [self.view sendSubviewToBack:view];
                }
            }
        }else{
            self.localView.frame = CGRectMake(left + index%colomns * (cellwidth + colSize), top + index/colomns * (cellHeight + colSize), cellwidth, cellHeight);
            index++;
            NSArray* views = [self.streamViewsDic allValues];
            for(EaseCallStreamView* view in views) {
                view.frame = CGRectMake(left + index%colomns * (cellwidth + colSize), top + index/colomns * (cellHeight + colSize), cellwidth, cellHeight);
                index++;
            }
            NSArray* placeViews = [self.placeHolderViewsDic allValues];
            for(EaseCallStreamView* view in placeViews) {
                view.frame = CGRectMake(left + index%colomns * (cellwidth + colSize), top + index/colomns * (cellHeight + colSize), cellwidth, cellHeight);
                index++;
            }
        }
        
    }else{
        self.microphoneButton.hidden = YES;
        self.microphoneLabel.hidden = YES;
        self.enableCameraButton.hidden = YES;
        self.enableCameraLabel.hidden = YES;
        self.speakerButton.hidden = YES;
        self.speakerLabel.hidden = YES;
        self.switchCameraButton.hidden = YES;
        self.switchCameraLabel.hidden = YES;
    }
}

- (void)inviteAction
{
    [[EaseCallManager sharedManager] inviteAction];
}

- (void)answerAction
{
    [super answerAction];
    self.answerButton.hidden = YES;
    self.acceptLabel.hidden = YES;
    self.statusLable.hidden = YES;
    self.remoteNameLable.hidden = YES;
    self.remoteHeadView.hidden = YES;
    [self.hangupButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@60);
        make.bottom.equalTo(self.view).with.offset(-40);
    }];
    self.isJoined = YES;
    self.localView.hidden = NO;
    self.inviteButton.hidden = NO;
    [self enableVideoAction];
}

- (void)hangupAction
{
    [super hangupAction];
}

- (void)muteAction
{
    [super muteAction];
    self.localView.enableVoice = !self.microphoneButton.isSelected;
}

- (void)enableVideoAction
{
    [super enableVideoAction];
    self.localView.enableVideo = self.enableCameraButton.isSelected;
    if(self.localView == self.bigView && !self.localView.enableVideo) {
        self.bigView = nil;
        [self updateViewPos];
    }
}

- (void)setPlaceHolderUrl:(NSURL*)url member:(NSString*)uId
{
    EaseCallPlaceholderView* view = [self.placeHolderViewsDic objectForKey:uId];
    if(view)
        return;
    EaseCallPlaceholderView* placeHolderView = [[EaseCallPlaceholderView alloc] init];
    [self.view addSubview:placeHolderView];
    [placeHolderView.nameLabel setText:[[EaseCallManager sharedManager] getNicknameFromUid:uId]];
//    NSData* data = [NSData dataWithContentsOfURL:url ];
//    [placeHolderView.placeHolder setImage:[UIImage imageWithData:data]];
    [placeHolderView.placeHolder sd_setImageWithURL:url];
    [self.placeHolderViewsDic setObject:placeHolderView forKey:uId];
    [self updateViewPos];
}

- (void)removePlaceHolderForMember:(NSString*)uId
{
    EaseCallPlaceholderView* view = [self.placeHolderViewsDic objectForKey:uId];
    if(view)
    {
        [view removeFromSuperview];
        [self.placeHolderViewsDic removeObjectForKey:uId];
        [self updateViewPos];
    }
}

- (void)streamViewDidTap:(EaseCallStreamView *)aVideoView
{
    if(aVideoView == self.floatingView) {
        self.isMini = NO;
        [self.floatingView removeFromSuperview];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIViewController *rootViewController = window.rootViewController;
        self.modalPresentationStyle = 0;
        [rootViewController presentViewController:self animated:YES completion:nil];
        return;
    }
    if(aVideoView == self.bigView) {
        self.bigView = nil;
        [self updateViewPos];
    }else{
        if(aVideoView.enableVideo)
        {
            self.bigView = aVideoView;
            [self updateViewPos];
        }
    }
}

- (void)miniAction
{
    self.isMini = YES;
    [super miniAction];
    self.floatingView.enableVideo = NO;
    self.floatingView.delegate = self;
    if(self.isJoined) {
        self.floatingView.nameLabel.text = @"通话中";
    }else{
        self.floatingView.nameLabel.text = @"等待接听";
    }
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
