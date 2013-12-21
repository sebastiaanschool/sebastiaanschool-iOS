//
//  GeneratedConstants.h
//
//  Created by Jeroen Leenarts on 25/1/2012.
// 

// The values of these constants are generated as part of the build process.

extern const BOOL DEBUG_LOGGING;
extern const BOOL DEBUG_PAYLOAD_ALLOWED;
extern NSString * const SERVER_URL;
extern NSString * const PARSE_APPLICATION_ID;
extern NSString * const PARSE_CLIENT_KEY;

/** For testflight we need an APP token. This constant contains that value. */
extern NSString * const TEST_FLIGHT_APP_TOKEN;

void bootstrapTestFlight(void);