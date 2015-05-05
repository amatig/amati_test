//
//  MessageCell.m
//  Messages
//
//  Created by Giovanni Amati on 16/07/14.
//  Copyright (c) 2014 Messagenet.it. All rights reserved.
//

#import "MessageCell.h"
#import <QuartzCore/QuartzCore.h>
#import "RecentMessage.h"

#define IMAGE_SIZE 50
#define PIE_SIZE 15

@interface MessageCell ()

@property (nonatomic) int cell_width;
@property (nonatomic) int cell_padding;

@end

@implementation MessageCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier withSize:(int)width
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // init attributes cell
        _cell_width = width;
        _cell_padding = 10;
        
        // init UI
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cell_padding, 5, width - _cell_padding * 2, 20)];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [_timeLabel setTextColor:[UIColor lightGrayColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:TIME_CELL_FONT_SIZE]];
        
        [self addSubview:_timeLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cell_padding, 5, width - _cell_padding * 2, 20)];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor colorWithRed:1 green:0.49 blue:0 alpha:1]];
        [_nameLabel setFont:[UIFont systemFontOfSize:NAME_CELL_FONT_SIZE]];
        
        [self addSubview:_nameLabel];
        
        _messageLabel = [[ActionLabel alloc] init];
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.numberOfLines = 0;
        [_messageLabel setFont:[UIFont systemFontOfSize:MESSAGE_CELL_FONT_SIZE]];
        // corner
        [_messageLabel.layer setCornerRadius:9.0f];
        _messageLabel.layer.masksToBounds = YES;
        
        [self addSubview:_messageLabel];
        
        _imgArrow = [[UIImageView alloc] init];
        _imgArrow.clipsToBounds = YES;
        
        [self addSubview:_imgArrow];
        
        _progressView = [[M13ProgressViewPie alloc] initWithFrame:CGRectMake(0, 0, PIE_SIZE, PIE_SIZE)];
        _progressView.alpha = 0.0f;
        [self addSubview:_progressView];
        
        [self addSubview:_messageLabel];
        
        _img = [[UIImageView alloc] init];
        _img.clipsToBounds = YES;
        
        CALayer *imageLayer = _img.layer;
        [imageLayer setCornerRadius:IMAGE_SIZE / 2];
        [imageLayer setMasksToBounds:YES];
        
        [self addSubview:_img];
    }
    return self;
}

-(void) setStatus:(int)value
{
    if (value == MessageStatusCode_incoming) {
        _progressView.alpha = 1.0f;
        
        [_progressView performAction:M13ProgressViewActionNone animated:YES];
        [_progressView setIndeterminate:YES];
    } else if (value == MessageStatusCode_sent) {
        _progressView.alpha = 1.0f;
        
        [_progressView performAction:M13ProgressViewActionNone animated:YES];
        [_progressView setIndeterminate:YES];
    } else if (value == MessageStatusCode_delivered) {
        if (_progressView.alpha > 0) {
            [_progressView setIndeterminate:NO];
            [_progressView performAction:M13ProgressViewActionSuccess animated:YES];
            [UIView animateWithDuration:0.5
                                  delay:1.0
                                options: UIViewAnimationOptionLayoutSubviews
                             animations:^{
                                 _progressView.alpha = 0;
                             }
                             completion:^(BOOL finished){
                                 NSLog(@"Done!");
                             }];
        }
    } else {
        _progressView.alpha = 1.0f;
        
        [_progressView setIndeterminate:NO];
        [_progressView performAction:M13ProgressViewActionFailure animated:YES];
    }
}

- (void)setComplete
{
    [self setStatus:MessageStatusCode_delivered];
}

-(void) setMessage:(NSString *)text withStatus:(int)status iAmSender:(BOOL)sender
{
    int x = _cell_padding + 60;
    
    if (sender) {
        x = _cell_padding;
        //[self setBackgroundColor:[UIColor whiteColor]];
        //[self setBackgroundColor:[[UIColor alloc] initWithRed:1.0f green:0.0f blue:0.98f alpha:1.0f]];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _messageLabel.textAlignment = NSTextAlignmentRight;
        [_messageLabel setTextColor:[UIColor whiteColor]];
        [_messageLabel setBackgroundColor:[UIColor colorWithRed:1 green:0.49 blue:0 alpha:1]];
    } else {
        //[self setBackgroundColor:[UIColor whiteColor]];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        [_messageLabel setTextColor:[UIColor blackColor]];
        [_messageLabel setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
    }
    
    int message_fix = 15;
    
    _messageLabel.frame = CGRectMake(x, 35, _cell_width - (IMAGE_SIZE + _cell_padding * 3), 2000); // 10 + 10 + 10 + img
    _messageLabel.text = text;
    [_messageLabel sizeToFit];
    
    CGRect rect = _messageLabel.frame;
    _messageLabel.frame = CGRectMake(x, 35, _cell_width - (IMAGE_SIZE + _cell_padding * 3), rect.size.height + message_fix);
    
    int arrow_width = 26 / 2;
    int arrow_height = 18 / 2;
    
    int img_fix = 9;
    
    if (sender) {
        _img.frame = CGRectMake(_messageLabel.frame.size.width + _messageLabel.frame.origin.x + _cell_padding, img_fix + _messageLabel.frame.size.height + _messageLabel.frame.origin.y - IMAGE_SIZE + arrow_height, IMAGE_SIZE, IMAGE_SIZE);
        _imgArrow.image = [UIImage imageNamed:@"bubble.png"];
        _imgArrow.frame = CGRectMake(x + _messageLabel.frame.size.width - arrow_width - _cell_padding, _messageLabel.frame.size.height + _messageLabel.frame.origin.y, arrow_width, arrow_height);
        
        _progressView.frame = CGRectMake(x, message_fix / 3.5 + IMAGE_SIZE + _messageLabel.frame.size.height + _messageLabel.frame.origin.y - IMAGE_SIZE, PIE_SIZE, PIE_SIZE);
    } else {
        _img.frame = CGRectMake(_cell_padding, img_fix + _messageLabel.frame.size.height + _messageLabel.frame.origin.y - IMAGE_SIZE + arrow_height, IMAGE_SIZE, IMAGE_SIZE);
        _imgArrow.image = [UIImage imageNamed:@"bubble2.png"];
        _imgArrow.frame = CGRectMake(x + _cell_padding, _messageLabel.frame.size.height + _messageLabel.frame.origin.y, arrow_width, arrow_height);
        
        _progressView.frame = CGRectMake(x + _messageLabel.frame.size.width - PIE_SIZE, message_fix / 3.5 + IMAGE_SIZE + _messageLabel.frame.size.height + _messageLabel.frame.origin.y - IMAGE_SIZE, PIE_SIZE, PIE_SIZE);
    }
    
    [self setStatus:status];
    
    // TEST
    if (status == MessageStatusCode_sent) {
        [self performSelector:@selector(setComplete) withObject:nil afterDelay:1.0f];
    }
}

@end
