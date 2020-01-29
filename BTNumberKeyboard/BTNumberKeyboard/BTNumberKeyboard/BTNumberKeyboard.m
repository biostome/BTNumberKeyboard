//
//  BTNumberKeyboard.m
//  BTNumberKeyboard
//
//  Created by leishen on 2020/1/29.
//  Copyright © 2020 leishen. All rights reserved.
//

#import "BTNumberKeyboard.h"
#import "BTKeyboard.h"

@interface BTNumberKeyboard ()<BTKeyboardDelegate>
/** To save UITextField/UITextView object voa textField/textView notifications. */
@property(nullable, nonatomic, weak) UIView *textFieldView;
@property(nonatomic, strong, nonnull, readwrite) NSMutableSet<Class> *registeredClasses;
@property (nonatomic, strong) BTKeyboard *keyboard;
@end

CGFloat defaultHeight = 320;

@implementation BTNumberKeyboard


- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.lightGrayColor;
        [self addSubview:self.keyboard];
        [self registerAllNotifications];
        
        if (CGRectEqualToRect(self.frame, CGRectZero)) {
            CGRect frame = self.frame;
            frame.size.height = defaultHeight;
            self.frame = frame;
        }
    
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat bottomOfSafeAreaInset = 0;
    if (@available(iOS 10.0, *)) {
        bottomOfSafeAreaInset = UIApplication.sharedApplication.windows.firstObject.safeAreaInsets.bottom;
    }

    self.keyboard.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-bottomOfSafeAreaInset);

}

- (void)dealloc{
#if DEBUG
    NSLog(@"mkInputview id dealloc");
#endif
    [self unregisterAllNotifications];
}


#pragma mark - BTKeyboardDelegate

- (void)mkNumberKeyboard:(BTKeyboard *)numberKeyboard didSelectItem:(NSNumber *)item{
    
    UIView * textFieldView = _textFieldView;
    
    if ([_textFieldView isKindOfClass:UITextField.class]) {
        
        UITextField *textField = (UITextField*)textFieldView;
        if ([item isEqualToNumber:@12]) {
            [textField deleteBackward];
        }
        else{
            [textField insertText:item.stringValue];
        }
    }
    if ([_textFieldView isKindOfClass:UITextView.class]) {
        
        UITextView *textView = (UITextView*)textFieldView;
        if ([item isEqualToNumber:@12]) {
            [textView deleteBackward];
        }
        else{
            [textView insertText:item.stringValue];
        }
    }
}

#pragma mark - lazy

- (BTKeyboard *)keyboard{
    if (!_keyboard) {
        _keyboard = [[BTKeyboard alloc]init];
        _keyboard.delegate = self;
    }
    return _keyboard;
}

#pragma mark - Customised textField/textView support.

/**
 Add customised Notification for third party customised TextField/TextView.
 */
-(void)registerTextFieldViewClass:(nonnull Class)aClass
  didBeginEditingNotificationName:(nonnull NSString *)didBeginEditingNotificationName
    didEndEditingNotificationName:(nonnull NSString *)didEndEditingNotificationName
{
    [_registeredClasses addObject:aClass];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:didBeginEditingNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidEndEditing:) name:didEndEditingNotificationName object:nil];
}

/**
 Remove customised Notification for third party customised TextField/TextView.
 */
-(void)unregisterTextFieldViewClass:(nonnull Class)aClass
    didBeginEditingNotificationName:(nonnull NSString *)didBeginEditingNotificationName
      didEndEditingNotificationName:(nonnull NSString *)didEndEditingNotificationName
{
    [_registeredClasses removeObject:aClass];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didBeginEditingNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didEndEditingNotificationName object:nil];
}

-(void)registerAllNotifications{
    
    //  Registering for UITextField notification.
    [self registerTextFieldViewClass:[UITextField class]
     didBeginEditingNotificationName:UITextFieldTextDidBeginEditingNotification
       didEndEditingNotificationName:UITextFieldTextDidEndEditingNotification];
    
    //  Registering for UITextView notification.
    [self registerTextFieldViewClass:[UITextView class]
     didBeginEditingNotificationName:UITextViewTextDidBeginEditingNotification
       didEndEditingNotificationName:UITextViewTextDidEndEditingNotification];
}

-(void)unregisterAllNotifications{

    //  Unregistering for UITextField notification.
    [self unregisterTextFieldViewClass:[UITextField class]
     didBeginEditingNotificationName:UITextFieldTextDidBeginEditingNotification
       didEndEditingNotificationName:UITextFieldTextDidEndEditingNotification];
    
    //  Unregistering for UITextView notification.
    [self unregisterTextFieldViewClass:[UITextView class]
     didBeginEditingNotificationName:UITextViewTextDidBeginEditingNotification
       didEndEditingNotificationName:UITextViewTextDidEndEditingNotification];
}

#pragma mark - UITextFieldView Delegate methods
/**  UITextFieldTextDidBeginEditingNotification, UITextViewTextDidBeginEditingNotification. Fetching UITextFieldView object. */
-(void)textFieldViewDidBeginEditing:(NSNotification*)notification{
    //  Getting object
    _textFieldView = notification.object;

}

/**  UITextFieldTextDidEndEditingNotification, UITextViewTextDidEndEditingNotification. Removing fetched object. */
-(void)textFieldViewDidEndEditing:(NSNotification*)notification{
    //Setting object to nil
    _textFieldView = nil;

}

@end
