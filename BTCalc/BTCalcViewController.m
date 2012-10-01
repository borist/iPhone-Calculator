//
//  BTCalcViewController.m
//  BTCalc
//
//  Created by Boris Treskunov on 9/29/12.
//  Copyright (c) 2012 Boris Treskunov. All rights reserved.
//

#import "BTCalcViewController.h"

@interface BTCalcViewController ()
@property (weak, nonatomic) IBOutlet UILabel *outputField;
@property (weak, nonatomic) IBOutlet UILabel *outputAnswerField;
- (IBAction)evalEquals:(id)sender;
- (IBAction)pressedOperation:(UIButton *)sender;
- (IBAction)clear:(id)sender;
- (IBAction)backspace:(id)sender;
- (IBAction)addDecimal:(id)sender;
- (IBAction)pressedNumber:(UIButton *) sender;

@end

@implementation BTCalcViewController
@synthesize outputField;
@synthesize outputAnswerField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setOutputField:nil];
    [self setOutputAnswerField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Update the UILabel displays
- (void)updateDisplay:(NSString *)addToDisplay {
    // Clear previous results
    if ([self.outputAnswerField.text length] != 0) {
        self.output = @"";
        self.outputField.text = @"";
        self.outputAnswerField.text = @"";
    }
    if ([self.output length] == 0) {
        self.output = addToDisplay;
    } else {
        self.output = [NSString stringWithFormat: @"%@%@", self.output, addToDisplay];
    }
    self.outputField.text = self.output;
}

// If the last button pressed was not an operation, and there is
// some sort of input, evaluate the expression (respecting order of operations).
- (IBAction)evalEquals:(id)sender {
    if (!self.operationActive && [self.output length] != 0) {
        [self evaluateExpression];   
    }
}

- (IBAction)pressedOperation:(UIButton *)sender {
    if (!self.operationActive && [self.output length] != 0) {
        self.operationActive = TRUE;
        [self updateDisplay:[sender currentTitle]];
    }
}

- (IBAction)clear:(id)sender {
    self.output = @"";
    self.outputField.text = self.output;
    self.outputAnswerField.text = self.output;
}

- (IBAction)backspace:(id)sender {
    if([self.output length] != 0) {
        self.output = [self.output substringToIndex:[self.output length] - 1];
        self.outputField.text = self.output;
    }
}

- (IBAction)addDecimal:(id)sender {
    // need to check if decimal already exists
    if(!self.operationActive && [self.output rangeOfString:@"."].location == NSNotFound) {
            self.operationActive = FALSE;
            [self updateDisplay:@"."];
    }
}

- (IBAction)pressedNumber:(UIButton *)sender {
    NSString *number = [sender currentTitle];
    self.operationActive = FALSE;
    [self updateDisplay:number];
}

- (void)evaluateExpression {
    NSMutableArray *operatorSudoStack = [NSMutableArray array];
    NSMutableArray *stringElements = [NSMutableArray array];
    for (int i = 0; i < [self.output length]; i++) {
        unichar c = [self.output characterAtIndex:i];
        if (isnumber(c) || c == '.') { //what about decimal point?
            NSString *numString = [NSString stringWithCharacters:&c length:1];
            while (i + 1 < [self.output length] &&
                   (isnumber([self.output characterAtIndex:i + 1]) ||
                    [self.output characterAtIndex:i + 1] == '.')) {
                c = [self.output characterAtIndex:++i];
                numString =
                    [NSString stringWithFormat:@"%@%@",
                        numString, [NSString stringWithCharacters:&c length:1]];
            }
            [stringElements addObject:numString];
        } else {
            NSString *operator = [NSString stringWithCharacters:&c length:1];
            while ([operatorSudoStack count] != 0) {
                NSString *topOper = [operatorSudoStack objectAtIndex:0];
                if ([self operatorHasPrecedence:topOper:operator]) {
                    [stringElements addObject:topOper];
                    [operatorSudoStack removeObjectAtIndex:0];
                } else {
                    break;
                }
            }
            [operatorSudoStack insertObject:operator atIndex:0];
        }
    }
    while ([operatorSudoStack count] != 0) {
        NSString *topOper = [operatorSudoStack objectAtIndex:0];
        [stringElements addObject:topOper];
        [operatorSudoStack removeObjectAtIndex:0];
    }
    [self evaluatePostfix:stringElements];
}

- (void) evaluatePostfix:(NSMutableArray *)postFix {
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < [postFix count]; i++) {
        NSString *curr = [postFix objectAtIndex:i];
        NSScanner *scan = [NSScanner scannerWithString:curr];
        int val;
        if (([scan scanInt:&val] && [scan isAtEnd]) || [curr rangeOfString:@"."].location != NSNotFound) {
            [result insertObject:curr atIndex:0];
        } else {
            double c1 = [[result objectAtIndex:0] doubleValue];
            double c2 = [[result objectAtIndex:1] doubleValue];
            [result removeObjectAtIndex:0];
            [result removeObjectAtIndex:0];
            double res;
            if ([curr isEqualToString:@"*"]) {
                res = c1 * c2;
            } else if ([curr isEqualToString:@"÷"]) {
                // divide by 0 is undefined
                if (c1 == 0) {
                    self.outputField.text = @"undefined";
                    self.output = @"";
                    return;
                }
                res = c2 / c1;
            } else if ([curr isEqualToString:@"+"]) {
                res = c1 + c2;
            } else if ([curr isEqualToString:@"-"]) {
                res = c2 - c1;
            } else {
                continue;
            }
            [result insertObject:[NSString stringWithFormat:@"%.02f", res] atIndex:0];
        }
    }
    self.outputAnswerField.text = [result objectAtIndex:0];
}

- (BOOL)operatorHasPrecedence:(NSString *)c1 :(NSString *)c2 {
    return [self getPrecedence:c1] >= [self getPrecedence:c2];
}

- (int)getPrecedence:(NSString *)c {
    int val = 0;
    if ([c isEqualToString:@"-"] || [c isEqualToString:@"+"]) {
        val = 1;
    } else if ([c isEqualToString:@"*"] || [c isEqualToString:@"÷"]) {
        val = 2;
    }
    return val;
}

@end
