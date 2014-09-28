
#import "WeatherItem.h"

@implementation WeatherItem 

@synthesize  place, low, high, condition,title;

- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = self->latitude;
    coordinate.longitude = self->longitude;
    return coordinate; 
}

@end
