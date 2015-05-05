//
//  MessageCell.h
//  Messages
//
//  Created by Giovanni Amati on 16/07/14.
//  Copyright (c) 2014 Messagenet.it. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionLabel.h"
#import "M13ProgressViewPie.h"

#define TIME_CELL_FONT_SIZE 10
#define NAME_CELL_FONT_SIZE 12
#define MESSAGE_CELL_FONT_SIZE 14

@interface MessageCell : UITableViewCell

@property (nonatomic) UIImageView           *img;
@property (nonatomic) UIImageView           *imgArrow;
@property (nonatomic) UILabel               *timeLabel;
@property (nonatomic) UILabel               *nameLabel;
@property (nonatomic) ActionLabel           *messageLabel;
@property (nonatomic) M13ProgressViewPie    *progressView;

-(id) initWithReuseIdentifier:(NSString *)reuseIdentifier withSize:(int)width;
-(void) setMessage:(NSString *)text withStatus:(int)status iAmSender:(BOOL)sender;

@end
