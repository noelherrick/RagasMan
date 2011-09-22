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

#import "word-machines.h"

@implementation word_machines

static int char_compare(const void* a, const void* b) {
    
    char alice = ((char*)a)[0];
    char bob = ((char*)b)[0];
    
    if(alice < bob) {
        return -1;
    } else if(alice > bob) {
        return 1;
    } else {
        return 0;
    }
}

+ (NSString*) sortLetterInWord: (NSString*) word {
    // Get the length of the word (plus null termination)
    long len = [word length] + 1;
    
    // Create a string long enough to hold it
    char *cString = malloc(len);
    
    // Extract C-style string from NSString
    [word getCString:cString maxLength:len encoding:NSASCIIStringEncoding];
    
    // Sort it using the quicksort algo
    qsort(cString, len - 1, sizeof(char), char_compare);
    
    // Convert it back to an NSString
    NSString *sorted = [NSString stringWithCString:cString encoding:NSASCIIStringEncoding];
    
    free(cString);
    
    return sorted;
}

@end
