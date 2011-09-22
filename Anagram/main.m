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

#import <Foundation/Foundation.h>
#import "word-machines.h"
#import <hiredis.h>

int main (int argc, const char * argv[])
{

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    if (argc > 0 && strcmp(argv[0], "--help") == 0) {
        printf("This program asks you for input then prints possible anagrams from this word (whole word anagrams only).");
        
        return 0;
    }
    
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
    
    BOOL cont = true;
    
    while (cont) {
        printf("Please enter a word, and press enter. Enter -q to quit.\n");
        
        char anagramee [256];
        
        scanf ("%s", &anagramee);
        
        // Check to see if it is -q
        if (strcmp(anagramee,"-q") == 0) {
            printf("Exiting.");
            
            break;
        }
        
        NSString* sortedString = [word_machines sortLetterInWord: [NSString stringWithCString:anagramee encoding:NSASCIIStringEncoding]];
        
        reply = redisCommand(redisContext, "SMEMBERS %s", [sortedString cStringUsingEncoding:NSASCIIStringEncoding]);
        
        if (reply->elements > 0) {
            printf("Found results. Printing.\n");
            
            for (int i = 0; i < reply->elements; i++) {
                printf("%s\n", reply->element[i]->str);
            }
        } else {
            printf("No results.");
        }
        
        freeReplyObject(reply);
    }
    
    [pool drain];
    return 0;
}

