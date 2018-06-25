
#import "NMFormatter.h"

@implementation NMFormatter
    
//    +(NSString *)format:(NSString*)time{
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        NSTimeInterval _interval = [time doubleValue]/1000;
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
//
//        [dateFormatter setDateFormat:@"hh:mm a"];
//        NSString *newDate = [dateFormatter stringFromDate:date];
//
//        return newDate;
//    }

    +(NSString *)format:(int)time{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval _interval = (CGFloat)time/1000;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *newDate = [dateFormatter stringFromDate:date];
        
        return newDate;
    }

    +(NSString *)now{
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *newDate = [dateFormatter stringFromDate:[NSDate date]];
        
        return newDate;
    }
@end
