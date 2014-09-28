

#import "WeatherAnnotationView.h"
#import "WeatherItem.h"


@implementation WeatherAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(30.0, 30.0);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(15, 15);
    }
    return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    // this annotation view has custom drawing code.  So when we reuse an annotation view
    // (through MapView's delegate "dequeueReusableAnnoationViewWithIdentifier" which returns non-nil)
    // we need to have it redraw the new annotation data.
    //
    // for any other custom annotation view which has just contains a simple image, this won't be needed
    //
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    WeatherItem *weatherItem = (WeatherItem *)self.annotation;
    if (weatherItem != nil)
    {
        /*CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1);
        
        // draw the gray pointed shape:
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 14.0, 0.0);
        CGPathAddLineToPoint(path, NULL, 0.0, 0.0); 
        CGPathAddLineToPoint(path, NULL, 55.0, 50.0); 
        CGContextAddPath(context, path);
        CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGPathRelease(path);
        
        // draw the cyan rounded box
        path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 15.0, 0.5);
        CGPathAddArcToPoint(path, NULL, 59.5, 00.5, 59.5, 5.0, 5.0);
        CGPathAddArcToPoint(path, NULL, 59.5, 69.5, 55.0, 69.5, 5.0);
        CGPathAddArcToPoint(path, NULL, 10.5, 69.5, 10.5, 64.0, 5.0);
        CGPathAddArcToPoint(path, NULL, 10.5, 00.5, 15.0, 0.5, 5.0);
        CGContextAddPath(context, path);
        CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGPathRelease(path);
        */
        //NSInteger high = [weatherItem.high integerValue];
        //NSInteger low = [weatherItem.low integerValue];

        // draw the temperature string and weather graphic
        //NSString *temperature = [NSString stringWithFormat:@"%@\n%d / %d", weatherItem.place, high, low];
        //[[UIColor blackColor] set];
        //[temperature drawInRect:CGRectMake(15.0, 5.0, 50.0, 40.0) withFont:[UIFont systemFontOfSize:11.0]];
        
        NSString *imageName = @"tbi_place";
        NSString *cat=[weatherItem.place objectForKey:@"category"];
        if ([cat isEqual:@"Restaurant/cafe"]){
            imageName=@"fork-and-knife";
        }
        if ([cat isEqual:@"Food/grocery"]){
            imageName=@"fork-and-knife";
        }
        if ([cat isEqual:@"Bar"]){
            imageName=@"food";
        }
        if ([cat isEqual:@"Bar"]){
            imageName=@"food";
        }
        [[UIImage imageNamed:imageName] drawInRect:CGRectMake(0,0, 30, 30)];
         
    }
}

@end
