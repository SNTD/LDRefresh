//
//  TNActivityIndicator.h
//  TuNiuApp
//
//  Created by Ben on 14/11/3.
//  Copyright (c) 2014年 Tuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TNActivityIndicator : UIView

@property (nonatomic, assign) BOOL hidesWhenStopped;

- (void)startAnimating;

- (void)stopAnimating;

@end
