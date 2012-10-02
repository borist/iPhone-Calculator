//
//  BTCalcViewController.h
//  BTCalc
//
//  Created by Boris Treskunov on 9/29/12.
//  Copyright (c) 2012 Boris Treskunov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTCalcViewController : UIViewController
- (void) updateDisplay:(NSString *)addToDisplay;
- (void) evaluateExpression;
- (void) evaluatePostfix:(NSMutableArray *) postFix;
- (BOOL) operatorHasPrecedence:(NSString *) c1:(NSString *) c2;
- (int) getPrecedence:(NSString *) c;
@property(nonatomic, assign)BOOL operationActive;
@property(nonatomic, assign)BOOL canAddDecimal;
@property (weak, nonatomic) NSString *output;
@end
