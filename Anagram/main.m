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
#import "DictionaryModel.h"

int main (int argc, const char * argv[])
{

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    if (argc > 0 && strcmp(argv[0], "--help") == 0) {
        NSLog(@"This program asks you for input then prints possible anagrams from this word (whole word anagrams only).");
        
        return 0;
    }
    
    BOOL cont = true;
    
    while (cont) {
        NSLog(@"Please enter a word, and press enter. Enter -q to quit.\n");
        
        char anagramee [256];
        
        scanf ("%s", &anagramee);
        
        // Check to see if it is -q
        if (strcmp(anagramee,"-q") == 0) {
            NSLog(@"Exiting.");
            
            break;
        }
        
        NSString* sortedString = [word_machines sortLetterInWord: [NSString stringWithCString:anagramee encoding:NSASCIIStringEncoding]];
        
        NSMutableArray* results = [DictionaryModel getMatchingWords: sortedString : 1];
        
        if ([results count] > 0) {
            NSLog(@"Found results. Printing.");
            
            for (NSString* word in results) {
                NSLog(@"%@", word);
            }
        } else {
            NSLog(@"No results.");
        }
        
    }
    
    [pool drain];
    return 0;
}

