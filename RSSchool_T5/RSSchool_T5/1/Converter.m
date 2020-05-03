#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    if (!string) return @{KeyPhoneNumber: @"", KeyCountry: @""};
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\D" options:0 error:&error];
    string = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@""];
    if ([string length] == 0) return @{KeyPhoneNumber: @"", KeyCountry: @""};
    if ([string length] > 12) string = [string substringToIndex:12];
    
    NSString *countryCode = @"";
    NSString *formatted = string;
    NSString *mask = @"";
    if ((string.length == 1) && ([string  isEqual: @"7"])) {
        countryCode = @"RU";
    } else if (string.length == 2) {
        int rukz = [string intValue];
        if (rukz == 77) {
            countryCode = @"KZ";
            formatted = [@"7 (" stringByAppendingString: [string substringFromIndex:1]];
        } else if ((rukz >= 70) && (rukz <= 79)) {
            countryCode = @"RU";
            formatted = [@"7 (" stringByAppendingString: [string substringFromIndex:1]];
        }
    } else {
        switch ([[string substringToIndex:3] intValue]) {
            case 998: countryCode = @"UZ"; mask = @"xxx (xx) xxx-xx-xx"; break;
            case 996: countryCode = @"KG"; mask = @"xxx (xx) xxx-xx-xx"; break;
            case 994: countryCode = @"AZ"; mask = @"xxx (xx) xxx-xx-xx"; break;
            case 993: countryCode = @"TM"; mask = @"xxx (xx) xxx-xxx"; break;
            case 992: countryCode = @"TJ"; mask = @"xxx (xx) xxx-xx-xx"; break;
            case 380: countryCode = @"UA"; mask = @"xxx (xx) xxx-xx-xx"; break;
            case 375: countryCode = @"BY"; mask = @"xxx (xx) xxx-xx-xx"; break;
            case 374: countryCode = @"AM"; mask = @"xxx (xx) xxx-xxx"; break;
            case 373: countryCode = @"MD"; mask = @"xxx (xx) xxx-xxx"; break;
            default:
                if ([[string substringToIndex:2] intValue] == 77) {
                    countryCode = @"KZ"; mask = @"x (xxx) xxx-xx-xx";
                } else if ([[string substringToIndex:1] intValue] == 7) {
                    countryCode = @"RU"; mask = @"x (xxx) xxx-xx-xx";
                }
                break;
        }
    }
    if (mask.length > 0) {
        int stringPosition = 0;
        int length = (int)[formatted length];
        NSString *newFormat = @"";
        for (int i = 0; i < mask.length; i++) {
            NSString *symbol = [mask substringWithRange:NSMakeRange(i, 1)];
            if (stringPosition >= length) break;
            if (([symbol isEqual:@"x"]) && (stringPosition <= length)) {
                newFormat = [newFormat stringByAppendingString:[formatted substringWithRange:NSMakeRange(stringPosition, 1)]];
                stringPosition++;
            } else {
                newFormat = [newFormat stringByAppendingString:symbol];
            }
        }
        formatted = newFormat;
    }
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d{3})?(\\d{2})?(\\d{3})?(\\d{2})?(\\d{1,2})?(.*)?$" options:0 error:&error];
//        formatted = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@"$1 ($2) $3-$4-$5"];

    formatted = [@"+" stringByAppendingString:formatted];
    return @{KeyPhoneNumber: formatted,
             KeyCountry: countryCode};
}
@end
