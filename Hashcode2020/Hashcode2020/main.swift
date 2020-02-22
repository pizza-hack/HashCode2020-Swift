//
//  main.swift
//  Hashcode2020
//
//  Created by Gabriel Marro on 20/02/2020.
//  Copyright © 2020 Apptones. All rights reserved.
//

import Foundation

debugPrint("Pizza Hack Hasscode\n================")

let debug = true

// MARK: - ARGUMENTS IN COMMAND LINE
// ==================================

guard CommandLine.arguments.count > 2 else {
    debugPrint("No input file name in command line")
    exit(0)
}

let fileName = CommandLine.arguments[1]
let outputName = CommandLine.arguments[2]

let filePath = fileName.hasPrefix("/") ? fileName : FileManager.default.currentDirectoryPath + "/" + fileName
let outputPath = outputName.hasPrefix("/") ? outputName : FileManager.default.currentDirectoryPath + "/" + outputName

guard let input = try? String(contentsOfFile: filePath) else {
    debugPrint("Error: could not read file \(filePath)" )
    exit(0)
}

// MARK: - DATA STRUCTURE
// ======================

struct Book {
    let bookID: Int
    let score: Int
    var sent: Bool
}

var allBooks: [Book] = []

var numLibsByDaysToSign:[Int:Int] = [:]

func minDaysToSign() -> Int? {
    let keys = numLibsByDaysToSign.keys.sorted()
    
    for key in keys {
        if numLibsByDaysToSign[key]! > 0 {
            return key
        }
    }
    return nil
}

struct Library {
    
    let libID: Int
    let numBooks: Int
    let daysForSign: Int
    let books: [Int]
    let booksPerDay: Int
    
    var selectedBooks: [Book]
    
    func totalPoint(_ days: Int) -> (points: Int, days: Int, books: Int) {
        let realDays = days - daysForSign
        
        let num = booksPerDay * realDays
        
        var i = 0
        var points = 0
        
        var counter = 0
        
        while counter < num,
            i < books.count {
            let bookID = books[i]
            let theBook = allBooks[bookID]
                if !theBook.sent {
                    points += theBook.score
                    counter += 1
                }
            i += 1
        }
        
        return (points: points, days: Int(ceil(Float(counter)/Float(booksPerDay))), books: counter)
    }
    
    func timeRatio(_ days: Int) -> Float {
        
        let (points, usedDays, _) = totalPoint(days)
        
        // how many days unused?
        let gap = days - usedDays - daysForSign
        
        return Float( points ) / Float( daysForSign ) * (gap > 1 ? 0.9 : 1.0)
    }
    
    func booksToSend(_ days: Int) -> [Book]? {
        
        var selectedBooks: [Book] = []
        var booksCounter = 0
        let maxBooks = (days - daysForSign) * booksPerDay
        
        if maxBooks > 0 {
            for bookID in books {
                let theBook = allBooks[bookID]
                if !theBook.sent {
                    selectedBooks.append(theBook)
                    booksCounter += 1
                    if booksCounter >= maxBooks {
                        break
                    }
                }
            }
        }
        
        return selectedBooks
    }
}

var libraries = [Library]()



let numBooks: Int
let numLibs: Int
let numDays: Int

// MARK: - READ FILE
// ==============================

let lines = input.components(separatedBy: "\n")

var allNums:[Int] = []

// first line

let firstLine = lines[0]

let nums = firstLine.components(separatedBy: " ")

numBooks = Int(nums[0])!
numLibs = Int(nums[1])!
numDays = Int(nums[2])!

let secondLine = lines[1]
let scoreStrings = secondLine.components(separatedBy: " ")

for i in 0 ..< numBooks {
    let score = Int(scoreStrings[i])!
    allBooks.append(Book(bookID: i, score: score, sent: false))
}

var lineNum = 2

for i in 0 ..< numLibs {
    
    let firstLine = lines[lineNum]
    var comps = firstLine.components(separatedBy: " ")
    let numBooks = Int(comps[0])!
    let daysForSign = Int(comps[1])!
    let booksPerDay = Int(comps[2])!
    
    var books:[Int] = []
    
    lineNum += 1
    let secondLine = lines[lineNum]
    comps = secondLine.components(separatedBy: " ")
    
    var bookObjs: [Book] = []
    
    for j in 0 ..< numBooks {
        let bookID = Int( comps[j] )!
        bookObjs.append(allBooks[bookID])
//        books.append( bookID)
    }
    
    bookObjs.sort { (book1, book2) -> Bool in
        book1.score > book2.score
    }
    
    for bookObj in bookObjs {
        books.append(bookObj.bookID)
    }
    
    let lib = Library(libID: i,
                      numBooks: numBooks,
                      daysForSign: daysForSign,
                      books: books,
                      booksPerDay: booksPerDay,
                      selectedBooks: [])
    
    numLibsByDaysToSign[daysForSign] = (numLibsByDaysToSign[daysForSign] ?? 0) + 1
    
    libraries.append(lib)
    
    lineNum += 1
}

// MARK: - Solve !
//********************

var restDays = numDays
var sortedLibs: [Library] = []

var finalScore = 0

var stopFlag = false

// fist attemp: sort all the libraries using a smart criterion
// this is the most important point....

libraries.sort { (lib1, lib2) -> Bool in
    lib1.timeRatio(restDays) > lib2.timeRatio(restDays)
}

var stack: [(libID: Int, startDay: Int)] = []
stack.append((0,0))

while stack.count > 0 {
        
    let stackItem = stack.last!
    var theLib = libraries[stackItem.libID]
    
    // add the library to current solution
    
    let booksToSend = theLib.booksToSend(restDays)
    
    
}

debugPrint("FINAL SCORE: \( finalScore)\n")

// MARK: - BUILD OUTPUT FILE
// =========================

var output: String = ""

// 1. num of libs

output = "\( sortedLibs.count)\n"

for i in 0 ..< sortedLibs.count {
    
    // first line
    let lib = sortedLibs[i]
    
    let booksToSend = lib.selectedBooks
    
    output += "\(lib.libID ) \( booksToSend.count )\n"
    
    // second line
    var firstNumber = true
    
    for i in 0 ..< booksToSend.count {
        
        let theBook = booksToSend[i]
        
        output += firstNumber ? "\( theBook.bookID )" : " \( theBook.bookID )"
        firstNumber = false
    }
    
    output += "\n"
    
}

try? output.write(to: URL(fileURLWithPath: outputPath), atomically: true, encoding: .ascii)

debugPrint("THE END!")

exit(0)
