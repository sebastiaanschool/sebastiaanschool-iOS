// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSBulletinCell.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 22-03-13.
//
//
#import "SBSBulletinCell.h"

@interface SBSBulletinCell () <TTTAttributedLabelDelegate>

@end

@implementation SBSBulletinCell

+ (CGFloat)heightForWidth:(CGFloat)width withItem:(SBSBulletin *)object
{
    if (object == nil) {
        return 0.0f;
    }
    CGFloat availableWidth = width - [SBSStyle standardMargin] *2;
    
    NSString *title = object.title;
    NSString *createdAt = [[SBSStyle longStyleDateFormatter] stringFromDate:object.createdAt];
    NSString *body = object.body;
    
    CGFloat height = [SBSStyle standardMargin];
    if (IS_IOS_7) {
        
        height += ceilf([title boundingRectWithSize:CGSizeMake(availableWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [SBSStyle titleFont]} context:nil].size.height);
        height += ceilf([createdAt boundingRectWithSize:CGSizeMake(availableWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [SBSStyle subtitleFont]} context:nil].size.height);
        if (body != nil) {
            height += ceilf([body boundingRectWithSize:CGSizeMake(availableWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [SBSStyle bodyFont]} context:nil].size.height);
        }
    } else {
        height += [title sizeWithFont:[SBSStyle titleFont] constrainedToSize:CGSizeMake(availableWidth, CGFLOAT_MAX)].height;
        height += [createdAt sizeWithFont:[SBSStyle subtitleFont] constrainedToSize:CGSizeMake(availableWidth, CGFLOAT_MAX)].height;
        if (body != nil) {
            height += [body sizeWithFont:[SBSStyle bodyFont] constrainedToSize:CGSizeMake(availableWidth, CGFLOAT_MAX)].height;
        }
    }
    
    height += [SBSStyle standardMargin];
    
    return height;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.textLabel.font = [SBSStyle titleFont];
        if (IS_IOS_7) {
            [self.textLabel setTextColor:[UIColor blackColor]];
            [self.textLabel setHighlightedTextColor:[UIColor whiteColor]];
        }
        
        self.detailTextLabel.font = [SBSStyle subtitleFont];
        if (IS_IOS_7) {
            [self.detailTextLabel setTextColor:[UIColor blackColor]];
            [self.detailTextLabel setHighlightedTextColor:[UIColor whiteColor]];
        }
        
        // Initialization code
        _bodyLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        [_bodyLabel setTextColor:[UIColor blackColor]];
        [_bodyLabel setHighlightedTextColor:[UIColor whiteColor]];
        _bodyLabel.font = [SBSStyle bodyFont];
        _bodyLabel.numberOfLines = 0;
        _bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _bodyLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        _bodyLabel.delegate = self;
        [self addSubview:_bodyLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel._y = [SBSStyle standardMargin];
    [self.textLabel makeRectIntegral];
    self.detailTextLabel._y = self.textLabel._bottom;
    [self.detailTextLabel makeRectIntegral];
    
    if (self.bodyLabel.text == nil) {
        self.bodyLabel.frame = CGRectZero;
    } else {
        self.bodyLabel.frame = self.bounds;
        self.bodyLabel._y = self.detailTextLabel._bottom;
        self.bodyLabel._left = self.textLabel._left;
        self.bodyLabel._width = self.bodyLabel._width - self.textLabel._left;
        self.bodyLabel._height = self.bounds.size.height - self.bodyLabel._y - [SBSStyle standardMargin];
        [self.bodyLabel makeRectIntegral];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [self trackEvent:[NSString stringWithFormat:@"User selected a bulletin URL: %@", url]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Open external link?", nil) message:[url description] delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Open", nil), nil];
    [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
        if (buttonIndex.integerValue == 1) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];

    [alert show];
}

@end
