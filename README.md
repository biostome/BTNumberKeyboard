# BTNumberKeyboard
# 自定义键盘正确方式

本文博客地址：https://www.jianshu.com/p/f2156d2ed981

又是好几周没有写博客了。
今天给大家带来自定义键盘。

我们`自定义键盘`时，总会看到有些同学会这样给TextField赋值。
```
/// 点击键盘的代理方法
- (void)keyboardOfTouchWithText:(NSString*)text{
    self.textFeild.text = text;
}
```
这种操作会遇到一个问题：当赋值完成后，键盘自动消失了。这并不能实现将文本插入光标所在位置。

## UITextField 的 UIKeyInput 协议
实际上我们可以调用UITextField中`UIKeyInput`协议的方法，就可以实现文本插入的功能。
UITextField 遵循了如下`UIKeyInput`协议，这两个协议可以实现`文本插入`和`文本删除`。
```
@protocol UIKeyInput <UITextInputTraits>
/// 是否有文本
@property(nonatomic, readonly) BOOL hasText;
/// 文本插入
- (void)insertText:(NSString *)text;
/// 向后删除文本
- (void)deleteBackward;

@end
```
那么代理方法可以写成这样：
```
/// 点击键盘的代理方法
- (void)keyboardOfTouchWithText:(NSString*)text{
    [self.textField insertText:text];
}
/// 删除文本
- (void)deleteOfTouchKeyboard{
    [self.textField deleteBackward];
}
```
不仅仅UITextField遵循了`UIKeyInput`协议，UITextView同样也遵循了此协议。
使用方法和上面一样简单。

到这里也许会认为已经完成了。
但作为乔布斯的程序猿，我们可以写的更好一点。

## 简化
我希望他人使用时要简单，而不是需要实现一堆代理方法。
我希望是这样：
```objc
BTInputView * inputView = [[BTInputView alloc]init];
self.tf.inputView = inputView;
```
## 封装

封装之前先思考一个问题：“在键盘内部要如何才能拿到TextField”
难道要把textField传进去吗？
这种违背初衷的操作当然不行。

其实也并不复杂
在TextFeild的API下方里有这么几个通知名。

```
UIKIT_EXTERN NSNotificationName const UITextViewTextDidBeginEditingNotification;
UIKIT_EXTERN NSNotificationName const UITextViewTextDidChangeNotification;
UIKIT_EXTERN NSNotificationName const UITextViewTextDidEndEditingNotification;
```
监听
 `UITextViewTextDidBeginEditingNotification`、`UITextViewTextDidEndEditingNotification`
既可以拿到TextField。
```

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

    UIView *textFieldView = _textFieldView;
    //Setting object to nil
    _textFieldView = nil;
}
```

在上述的代码中,通过下列方法获取到了TextField并保存了。
```
-(void)textFieldViewDidBeginEditing:(NSNotification*)notification{

    //  Getting object
    _textFieldView = notification.object;

}
```
当然，键盘退出时要进行置空
```
-(void)textFieldViewDidEndEditing:(NSNotification*)notification{

    UIView *textFieldView = _textFieldView;
    //Setting object to nil
    _textFieldView = nil;
}
```


获取TextField成功后，给textField插入文本就变得很简单了。
```
/// 点击键盘的代理方法
- (void)keyboardOfTouchWithText:(NSString*)text{
    [_textField insertText:text];
}
/// 删除文本
- (void)deleteOfTouchKeyboard{
    [_textField deleteBackward];
}
```

有不明白的地方欢迎留言。
也可以下载此文[Demo]([https://github.com/biostome/BTNumberKeyboard](https://github.com/biostome/BTNumberKeyboard)
)揣摩。

##此文结束
