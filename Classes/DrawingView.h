//
//  DrawingView.h
//  AnimatedPaths
//
//  Created by Seth on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol DrawingViewDelegate <NSObject>
-(void) finishedDrawingStroke:(UIBezierPath *)completedStroke;
-(NSArray *) brushPaths;
@end

@interface DrawingView : UIView

@property (nonatomic, retain) IBOutlet id<DrawingViewDelegate> delegate;
@property (nonatomic, getter = isAnimatingPlayback) BOOL animatingPlayback;

- (void) setupDrawingLayer;

@end