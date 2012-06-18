//
//  AnimatedPathViewController.h
//  AnimatedPath
//
//  Created by Ole Begemann on 08.12.10.
//  Copyright 2010 Ole Begemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DrawingView.h"

@interface AnimatedPathViewController : UIViewController<DrawingViewDelegate>

@property (nonatomic, readonly) DrawingView *drawingView;
@property (nonatomic, retain, readonly) NSMutableArray *brushPaths;

- (IBAction) replayButtonTapped:(id)sender;
- (IBAction) clearCanvas:(id)sender;

@end

