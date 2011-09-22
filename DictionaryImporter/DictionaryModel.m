/*
 
 Copyright (C) 2011 by Noel Herrick
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "DictionaryModel.h"

@implementation DictionaryModel

+ (int) saveWords: (NSArray*) words {
    // Connect to redis
    redisContext *redisContext;
    
    struct timeval timeout = { 1, 500000 };
    
    redisContext = redisConnectWithTimeout((char*)"127.0.0.1", 6379, timeout);
    
    redisReply *reply;
    
    // Check to see if that was successful
    if (redisContext->err) {
        printf("Connection error: %s\n", redisContext->errstr);
        return 1;
    } 
    
    // Select the 1st database
    reply = redisCommand(redisContext,"SELECT 1");
    
    if (reply->type == 6) { // Redis Error
        printf("Database selection error: %s\n", reply->str);
        return 2;
    }
    
    freeReplyObject(reply);
    
    // Delete the db
    reply = redisCommand(redisContext,"FLUSHDB");
    
    if (reply->type == 6) { // Redis Error
        printf("Database deletion error: %s\n", reply->str);
        return 2;
    }
    
    freeReplyObject(reply);
    
    
    // Read the lines into redis
    for (NSString* word in words) {
        //NSLog(@"Adding: %@ %@", word, [word_machines sortLetterInWord:word]);
        
        reply = redisCommand(redisContext,"SADD %s %s", [[word_machines sortLetterInWord:word] cStringUsingEncoding:NSASCIIStringEncoding], [word cStringUsingEncoding:NSASCIIStringEncoding]);
        
        if (reply->type == 6) { // Redis Error
            printf("Word adding error: %s\n", reply->str);
            return 3;
        }
        
        freeReplyObject(reply);
    }
    
    return 0;
}

@end
