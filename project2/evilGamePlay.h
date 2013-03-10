//
//  evilGamePlay.h
//  project2
//
//  Created by Bobby Odenhoven on 10-03-13.
//
//

#import <Foundation/Foundation.h>

@interface evilGamePlay : NSObject

-(NSMutableArray*) gamePlayDelegate: (NSString*)letter inWords: (NSMutableArray*) words wordLength:(int)word_length;

@end
