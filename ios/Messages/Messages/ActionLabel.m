
// Su ispirazione di
// https://github.com/zhbrass/UILabel-Clipboard/blob/master/Classes/CopyLabel.m

#import "ActionLabel.h"

@interface ActionLabel ()

@property (nonatomic) UIGestureRecognizer *touchy;

@end

@implementation ActionLabel

#pragma mark Initialization

- (void) attachTapHandler
{
    [self setUserInteractionEnabled:YES];
    _touchy = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:_touchy];
}

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self attachTapHandler];
    }
    return self;
}

- (void) dealloc
{
    [self removeGestureRecognizer:_touchy];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self attachTapHandler];
    }
    return self;
}

#pragma mark Action

// implementazione del copy

- (void) copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.text];
}

- (void) unhilight{
    self.highlighted = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:)) { // si visulizza se torna yes
        return YES;
    }
    
    //if (action == @selector(paste:)) { // si visulizza se torna yes, una funzione esitente
    //    return YES;
    //}
    
    return NO;
}

- (void) handleTap:(UIGestureRecognizer*)recognizer
{
    [self becomeFirstResponder];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    // test
    //UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Unfavorite" // titoli custom
    //                                                  action:@selector(unFavorite:)];
    //[menu setMenuItems:[NSArray arrayWithObject:menuItem]];
    
    if ([menu isMenuVisible]) {
        
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unhilight) name:UIMenuControllerWillHideMenuNotification object:nil];
        [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
        self.highlighted = YES;
    }
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {0, 15, 1, 15};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
