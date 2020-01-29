//
//  ViewController.m
//  BTNumberKeyboard
//
//  Created by leishen on 2020/1/29.
//  Copyright © 2020 leishen. All rights reserved.
//

#import "ViewController.h"
#import "BTNumberKeyboard.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.redColor;
    BTNumberKeyboard * inputView1 = [[BTNumberKeyboard alloc]init];
    self.textField.inputView = inputView1;
    
    BTNumberKeyboard * inputView2 = [[BTNumberKeyboard alloc]init];
    self.textView.inputView = inputView2;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
