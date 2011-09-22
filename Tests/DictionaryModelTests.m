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

#import <GHUnit/GHUnit.h>
#import "word-machines.h"
#import "DictionaryModel.h"

@interface DictionaryModelTests : GHTestCase { }
@end

@implementation DictionaryModelTests

- (void) test_letters_are_sorted {       
    NSString* sortedWord1 = [word_machines sortLetterInWord:@"zsa"];
    
    GHAssertEqualStrings(sortedWord1, @"asz", @"Word did not sort");
    
    NSString* sortedWord2 = [word_machines sortLetterInWord:@"qqqqiiiiffff"];
    
    GHAssertEqualStrings(sortedWord2, @"ffffiiiiqqqq", @"Word did not sort");
}

- (void) test_words_save_and_retrieve {
    //NSString* sortedWord = [[NsString alloc] init
    
    NSArray* words = [[NSArray alloc] initWithObjects:@"fizzle", @"bang", @"trill", nil];
    
    [DictionaryModel saveWords: words : 2];
    
    NSMutableArray* results = [DictionaryModel getMatchingWords: @"efilzz": 2];
    
    GHAssertTrue([results count] == 1, @"Need to get one result back");
}

@end