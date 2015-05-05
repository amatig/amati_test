//
//  ViewController.m
//  Messages
//
//  Created by Giovanni Amati on 16/07/14.
//  Copyright (c) 2014 Messagenet.it. All rights reserved.
//

#import "ViewController.h"
#import "MessageCell.h"
#import "RecentMessage.h"
#import <QuartzCore/QuartzCore.h>

#define PLACEHOLDER_FIELD @"Free message"
#define MESSAGE_CELL_ID_L @"MessageCellLeft"
#define MESSAGE_CELL_ID_R @"MessageCellRight"
#define MESSAGE_FOR_PAGE 20

@interface ViewController ()

@property (nonatomic) int statusbar_height;
@property (nonatomic) int container_height;
@property (nonatomic) int container_padding;
@property (nonatomic) int field_width;
@property (nonatomic) int field_height;
@property (nonatomic) int button_width;
@property (nonatomic) int button_height;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *containerView;
@property (nonatomic) UITextView *fieldView;
@property (nonatomic) UIButton *buttonView;

@property (nonatomic) NSString *currentUser;
@property (nonatomic) NSDateFormatter *formatter;

@property (nonatomic) BOOL keyboard_open;
@property (nonatomic) BOOL table_end;

@property (nonatomic) NSUInteger totalNumberOfItems;
@property (nonatomic) NSUInteger numberOfItemsToDisplay;
@property (nonatomic) NSMutableArray *dataMessage;

// test
@property (nonatomic) NSMutableArray *fakeDataMessage;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // init attributes view
    
    _statusbar_height = 20;
    _container_height = 45;
    _container_padding = 5;
    _button_width = 55;
    _field_height = _container_height - _container_padding * 2;
    _field_width = self.view.frame.size.width - (_button_width + _container_padding * 3);
    
    // init UI
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _statusbar_height, self.view.frame.size.width, self.view.frame.size.height - _container_height - _statusbar_height)];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - _container_height, self.view.frame.size.width, _container_height)];
    [_containerView setBackgroundColor:[[UIColor alloc] initWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f]];
    
    // shadow
    /*CALayer *layer = _containerView.layer;
     layer.shadowOffset = CGSizeMake(1, 1);
     layer.shadowColor = [[UIColor darkGrayColor] CGColor];
     layer.shadowRadius = 4.0f;
     layer.shadowOpacity = 0.80f;
     layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];*/
    
    _fieldView = [[UITextView alloc] initWithFrame:CGRectMake(_container_padding, _container_padding, _field_width, _field_height)];
    [_fieldView setBackgroundColor:[UIColor whiteColor]];
    [_fieldView setFont:[UIFont systemFontOfSize:MESSAGE_CELL_FONT_SIZE]];
    [_fieldView setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    _buttonView = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (_button_width + _container_padding), _container_padding, _button_width, _field_height)];
    [_buttonView setBackgroundColor:[UIColor colorWithRed:1 green:0.49 blue:0 alpha:1]];
    [_buttonView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [_buttonView setTitle:@"Invia" forState:UIControlStateNormal];
    
    [self _updateTextViewHeight:NO];
    
    [_containerView addSubview:_fieldView];
    [_containerView addSubview:_buttonView];
    [self.view addSubview:_tableView];
    [self.view addSubview:_containerView];
    
    _keyboard_open = NO;
    
    // EVENT AND DELEGATE
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    [_fieldView setDelegate:self];
    _fieldView.text = PLACEHOLDER_FIELD;
    _fieldView.textColor = [UIColor lightGrayColor]; //optional
    
    [_buttonView addTarget:self action:@selector(buttonSendPressed)
          forControlEvents:UIControlEventTouchUpInside];
    
    // This could be in an init method.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotificationMethod:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotificationMethod:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    // ***** INIT FAKE DATA *****
    
    _fakeDataMessage = [NSMutableArray new];
    _currentUser = @"Giovanni";
    
    for (int i = 0; i < 100; i++) {
        RecentMessage *msg = [RecentMessage new];
        
        msg.message_timestamp = [NSDate date];
        if (i %2 == 0) {
            msg.message_sender = @"Pippo";
            msg.message_body = [[NSString alloc] initWithFormat:@"Messaggio di test %d", i];
            msg.message_status = MessageStatusCode_delivered;
        } else {
            msg.message_sender = _currentUser;
            msg.message_body = [[NSString alloc] initWithFormat:@"Messaggio di test allineamnto a dentra mandato da me non da un altro, prova perche la cella si allarga in basso %d", i];
            msg.message_status = MessageStatusCode_delivered;
        }
        
        [_fakeDataMessage addObject:msg];
    }
    
    // ***** END FAKE DATA *****
    
    // INIT DATA
    
    _dataMessage = [NSMutableArray new];
    
    _numberOfItemsToDisplay = 0;
    
    _totalNumberOfItems = [_fakeDataMessage count];
    
    int start = _totalNumberOfItems - _numberOfItemsToDisplay - 1;
    
    [self loadDataFrom:start];
    
    [self scrollToBottom:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_tableView setDataSource:nil];
    [_tableView setDelegate:nil];
    
    [_fieldView setDelegate:nil];
    
    [_buttonView removeTarget:self action:@selector(buttonSendPressed) forControlEvents:UIControlEventTouchUpInside];
    
    // This could be in an init method.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DataSource

-(void) loadDataFrom:(int)start
{
    NSUInteger newNumberOfItemsToDisplay = MIN(_totalNumberOfItems, (_numberOfItemsToDisplay + MESSAGE_FOR_PAGE));
    
    int stop = _totalNumberOfItems - newNumberOfItemsToDisplay;
    
    for (int i = start; i >= stop; i--)
    {
        [_dataMessage insertObject:[_fakeDataMessage objectAtIndex:i] atIndex:0];
    }
    
    _numberOfItemsToDisplay = newNumberOfItemsToDisplay;
}

#pragma mark - Button

-(void) buttonSendPressed
{
    if (![_fieldView.text isEqualToString:@""] && ![_fieldView.text isEqualToString:PLACEHOLDER_FIELD])
    {
        RecentMessage *msg = [RecentMessage new];
        
        msg.message_timestamp = [NSDate date];
        msg.message_sender = _currentUser;
        msg.message_body = [_fieldView text];
        msg.message_status = MessageStatusCode_sent;
        
        _fieldView.text = @"";
        [self _updateTextViewHeight:YES];
        
        [self appendMessage:msg wasMe:YES animated:YES scrolling:YES];
        
        // test risposta
        
        if ([[msg.message_body lowercaseString] isEqualToString:@"come stai?"])
        {
            // Delay execution of my block for 10 seconds.
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                RecentMessage *msg = [RecentMessage new];
                
                msg.message_timestamp = [NSDate date];
                msg.message_sender = @"Pippo";
                msg.message_body = @"Bene grazie.";
                msg.message_status = MessageStatusCode_sent;
                
                [self appendMessage:msg wasMe:NO animated:YES scrolling:YES];
            });
        }
    }
}

#pragma mark - TextView

- (void)keyboardNotificationMethod:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    if (_keyboard_open == NO)
    {
        CGRect rect = _tableView.frame;
        rect.size.height = rect.size.height - keyboardFrameBeginRect.size.height; //set height whatever you want.
        _tableView.frame = rect;
        
        CGRect rect2 = _containerView.frame;
        rect2.origin.y = rect2.origin.y - keyboardFrameBeginRect.size.height; //set height whatever you want.
        _containerView.frame = rect2;
        
        if (_table_end)
        {
            [self scrollToBottom:NO];
        }
        
        _keyboard_open = YES;
    }
    else
    {
        CGRect rect = _tableView.frame;
        rect.size.height = rect.size.height + keyboardFrameBeginRect.size.height; //set height whatever you want.
        _tableView.frame = rect;
        
        CGRect rect2 = _containerView.frame;
        rect2.origin.y = rect2.origin.y + keyboardFrameBeginRect.size.height; //set height whatever you want.
        _containerView.frame = rect2;
        
        _keyboard_open = NO;
    }
}

- (void) _updateTextViewHeight:(BOOL)animated
{
    NSInteger MAX_HEIGHT = 2000;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, _field_width, MAX_HEIGHT)];
    [textView setFont:[UIFont systemFontOfSize:MESSAGE_CELL_FONT_SIZE]];
    textView.text = _fieldView.text;
    [textView sizeToFit];
    int height = textView.frame.size.height;
    
    if (_button_height == 0)
    {
        _button_height = height;
    }
    
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
    }
    
    CGRect rect = _fieldView.frame;
    
    _fieldView.frame = CGRectMake(_container_padding, _container_padding, _field_width, height);
    
    CGRect rect2 = _containerView.frame;
    _containerView.frame = CGRectMake(0, rect2.origin.y - (_fieldView.frame.size.height - rect.size.height), self.view.frame.size.width, _fieldView.frame.size.height + _container_padding * 2);
    
    _buttonView.frame = CGRectMake(self.view.frame.size.width - (_button_width + _container_padding), _container_padding + height - _button_height, _button_width, _button_height);
    
    if (animated)
    {
        [UIView commitAnimations];
    }
}

- (void) textViewDidChange:(UITextView *)textView
{
    [self _updateTextViewHeight:YES];
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:PLACEHOLDER_FIELD]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = PLACEHOLDER_FIELD;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

#pragma mark - TableView

- (void) appendMessage:(RecentMessage *)msg wasMe:(BOOL)me animated:(BOOL)animated scrolling:(BOOL)scrolling
{
    [_dataMessage addObject:msg];
    _numberOfItemsToDisplay++;
    [_tableView reloadData];
    if (scrolling && (_table_end || me)) {
        [self scrollToBottom:_table_end];
    }
}

- (void) scrollToBottom:(BOOL)animated
{
    if ([_dataMessage count] > 0)
    {
        int section = 0;
        if (_totalNumberOfItems > [_dataMessage count]) {
            section = 1;
        }
        
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:[_dataMessage count] - 1 inSection:section];
        [_tableView scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionTop animated:animated];
    }
    
    _table_end = YES;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentOffset = scrollView.contentOffset.y + scrollView.frame.size.height;
    CGFloat maximumOffset = scrollView.contentSize.height;
    
    if ((maximumOffset - currentOffset) <= 150.0)
    {
        //NSLog(@"DENTRO");
        _table_end = YES;
    }
    else
    {
        //NSLog(@"FUORI");
        _table_end = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView numberOfSections] > 1 && indexPath.section == 0)
    {
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (_keyboard_open)
        {
            [_fieldView resignFirstResponder];
        }
        
        int start = _totalNumberOfItems - _numberOfItemsToDisplay - 1;
        
        [self loadDataFrom:start];
        
        if (_totalNumberOfItems > [_dataMessage count])
        {
            // [_tableView reloadData];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [_tableView reloadData];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else
    {
        if (_keyboard_open)
        {
            [_fieldView resignFirstResponder];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([tableView numberOfSections] > 1 && indexPath.section == 1) || [tableView numberOfSections] == 1) {
        RecentMessage *msg = [_dataMessage objectAtIndex:indexPath.row];
        return 60.0f + [self _cellHeightForText:msg.message_body];
    }
    
    return 60.0f;
}

-(CGFloat)_cellHeightForText:(NSString *)text
{
    NSInteger MAX_HEIGHT = 2000;
    ActionLabel *textView = [[ActionLabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width - 80, MAX_HEIGHT)];
    textView.lineBreakMode = NSLineBreakByWordWrapping;
    textView.numberOfLines = 0;
    [textView setFont:[UIFont systemFontOfSize:MESSAGE_CELL_FONT_SIZE]];
    textView.text = text;
    [textView sizeToFit];
    return textView.frame.size.height + 15;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_totalNumberOfItems > [_dataMessage count]) {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView numberOfSections] == 2 && section == 0) {
        return 1;
    }
    return _numberOfItemsToDisplay;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if ([tableView numberOfSections] == 2 && indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MORE"];
        if (cell == nil)
        {
            NSLog(@"new cell more");
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MORE"];
            
            [cell setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1]];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setTextColor:[UIColor colorWithRed:1 green:0.49 blue:0 alpha:1]];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        cell.textLabel.text = @"Load More";
    }
    else
    {
        RecentMessage *msg = [_dataMessage objectAtIndex:indexPath.row];
        
        BOOL you = [msg.message_sender isEqualToString:_currentUser];
        NSString *cellID = you ? MESSAGE_CELL_ID_R : MESSAGE_CELL_ID_L;
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            NSLog(@"new cell");
            cell = [[MessageCell alloc] initWithReuseIdentifier:cellID withSize:_tableView.frame.size.width];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        ((MessageCell *) cell).timeLabel.text = [_formatter stringFromDate:msg.message_timestamp];
        if (you) {
            ((MessageCell *) cell).img.image = [UIImage imageNamed:@"avatar.jpg"];
            ((MessageCell *) cell).nameLabel.text = @"Io";
        } else {
            ((MessageCell *) cell).img.image = [UIImage imageNamed:@"avatar.jpg"];
            ((MessageCell *) cell).nameLabel.text = msg.message_sender;
        }
        [((MessageCell *) cell) setMessage:msg.message_body withStatus:msg.message_status iAmSender:you];
    }
    
    return cell;
}

@end
