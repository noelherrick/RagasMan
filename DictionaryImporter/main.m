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
#import "DictionaryModel.h"

int main (int argc, const char * argv[])
{

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    if (argc > 0 && strcmp(argv[0], "--help") == 0) {
        printf("This program creates a database file for the Ragas Man. It expects a file named \"dictionary.txt\" in the your home directory.");
        
        return 0;
    }
        
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @"/dictionary.txt"];
    
    // Read the dictionary into a giant strin
    NSString *dictionary = [[NSString alloc] initWithContentsOfFile:filePath];
        
    // Break it into an array
    NSArray *words = [dictionary componentsSeparatedByString:@"\n"];
        
    // Call the database saving functions
    int returnCode = [DictionaryModel saveWords: words];
    
    [pool drain];
    
    return returnCode;
}

