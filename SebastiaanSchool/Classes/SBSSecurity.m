//
//  SBSSecurity.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 20-01-13.
//
//

typedef enum {
    UNKNOWN,
    STAFF_USER,
    REGULAR_USER,
}USER_TYPE;

static NSArray *observedKeys;
static NSString * const userTypeKeypath = @"userType";

NSString * const SBSUserRoleDidChangeNotification = @"SBSUserRoleDidChangeNotification";


@interface SBSSecurity ()

@property (nonatomic, assign) USER_TYPE userType;

@end

@implementation SBSSecurity

+(SBSSecurity *)instance {
    static SBSSecurity *instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^{
        observedKeys = @[userTypeKeypath];
        instance = [SBSSecurity new];
    });
    
    return instance;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"userType"];
}

-(id)init {
    if ( self = [super init] ) {
        [self addObserver:self forKeyPath:@"userType" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

-(void)reset {
    self.userType = UNKNOWN;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (![observedKeys containsObject:keyPath]) {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
        return;
    }
    
    
    if ([userTypeKeypath isEqual:keyPath]) {
        DLog(@"Role of user changed");
        [[NSNotificationCenter defaultCenter] postNotificationName:SBSUserRoleDidChangeNotification object:nil];
    }
}

-(BOOL)currentUserStaffUser {
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        //User is anonymous
        return NO;
    }

    if (self.userType == UNKNOWN) {
        _userType = REGULAR_USER;
        
        PFQuery *query = [PFRole query];
        [query whereKey:@"name" equalTo:@"staff"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *matchingRoles, NSError *error) {
            if (error) {
                
            } else {
                NSAssert(matchingRoles.count == 1, @"There should be exactly one staff role");
                
                PFQuery *roleQuery = [[matchingRoles[0] relationforKey:@"users"] query];
                [roleQuery findObjectsInBackgroundWithBlock:^(NSArray *staffUsers, NSError *error) {
                    if (error) {
                        
                    } else {
                        NSString * const currentUserId = [PFUser currentUser].objectId;
                        for (PFUser * staffUser in staffUsers) {
                            if ([currentUserId isEqual:staffUser.objectId]) {
                                self.userType = STAFF_USER;
                            }
                        }
                    }
                }];
            }
        }];
    }
    
    switch (self.userType) {
        case STAFF_USER:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

@end
