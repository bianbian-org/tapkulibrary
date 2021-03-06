//
//  UIView+TKMaterial.m
//  Created by Devin Ross on 12/22/14.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
 Portions Copyright (c) 2013 Ben Vogelzang.
 https://github.com/bvogelzang/BVReorderTableView
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "UIView+TKMaterial.h"
#import "UIView+TKCategory.h"

@implementation UIView (TKMaterial)


- (void) fireMaterialTouchDiskAtPoint:(CGPoint)point{
	
	UIView *disk = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	disk.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
	disk.layer.cornerRadius = CGRectGetWidth(disk.frame)/2;
	disk.center = point;
	[self addSubview:disk];
	
	[UIView animateWithDuration:0.5 animations:^{
		disk.transform = CGAffineTransformMakeScale(10, 10);
		disk.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
	} completion:^(BOOL finished) {
		
		[disk removeFromSuperview];
	}];
	
}



- (void) materialTransitionWithSubview:(UIView*)subview atPoint:(CGPoint)point changes:(void (^)(void))changes completion:(void (^)(BOOL finished))completion{
	
	UIImage *snapshotImage = [subview snapshotImageAfterScreenUpdates:NO];
	
	UIImageView *snapshotView = [[UIImageView alloc] initWithFrame:subview.frame];
	snapshotView.image = snapshotImage;
	[self addSubview:snapshotView];
	
	
	if(changes) changes();
	
	
	[CATransaction begin]; {
		[CATransaction setCompletionBlock:^{
			[snapshotView removeFromSuperview];
			if(completion) completion(YES);
		}];

		
		
		
		CAShapeLayer *shapeMask = [CAShapeLayer layer];
		shapeMask.frame = CGRectMake(point.x-10, point.y-10, 20, 20);
		shapeMask.fillColor = [UIColor redColor].CGColor;
		
		UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 20, 20)];
		[path appendPath:[UIBezierPath bezierPathWithRect:CGRectInset(shapeMask.bounds, -500, -500)]];
		shapeMask.path = path.CGPath;
		snapshotView.layer.mask = shapeMask;
		shapeMask.fillRule = kCAFillRuleEvenOdd;
		
		CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"transform"];
		anime.fromValue = [NSValue valueWithCATransform3D:shapeMask.transform];
		anime.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(85, 85, 1)];
		anime.duration = 1;
		[shapeMask addAnimation:anime forKey:@"material"];
		
	
		shapeMask.transform = CATransform3DMakeScale(85, 85, 1);
		
		
		
	} [CATransaction commit];

	
	
}



@end
