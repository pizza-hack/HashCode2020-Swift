//
//  main.swift
//  Hashcode2020
//
//  Created by Gabriel Marro on 20/02/2020.
//  Copyright © 2020 Apptones. All rights reserved.
//

import Foundation

print("Hello, World!")

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

// MARK: - READ FILE
// ==============================

let lines = input.components(separatedBy: "\n")

var allNums:[Int] = []

// first line

let firstLine = lines[0]

let nums = firstLine.components(separatedBy: " ")
let numBooks = Int(nums[0])!
let numLibs = Int(nums[1])!
let numDays = Int(nums[2])!


struct Book {
    let bookID: Int
    let score: Int
    var sent: Bool
}

var allBooks: [Book] = []

let secondLine = lines[1]
let scoreStrings = secondLine.components(separatedBy: " ")



for i in 0 ..< numBooks {
    let score = Int(scoreStrings[i])!
    allBooks.append(Book(bookID: i, score: score, sent: false))
}

struct Library {
    let libID: Int
    let numBooks: Int
    let daysForSign: Int
    let booksPerDay: Int
    let books: [Int]
}

var libraries = [Library]()

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
    
    for j in 0 ..< numBooks {
        books.append(Int( comps[j] )!)

    }
    
    let lib = Library(libID: i,
                      numBooks: numBooks,
                      daysForSign: daysForSign,
                      booksPerDay: booksPerDay,
                      books: books)
    libraries.append(lib)
    
    lineNum += 1
}

//********************


debugPrint("end")


exit(0)
