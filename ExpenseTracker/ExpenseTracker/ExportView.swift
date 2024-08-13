//
//  ExportView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 12.08.2024.
//

import SwiftData
import SwiftUI

struct ExportView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var showingImport = false
    
    var count: Int {
        let descriptor = FetchDescriptor<Expense>()
        let result = (try? modelContext.fetchCount(descriptor)) ?? 0
        return result
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Number of objects in database:")
                        Text(String(count))
                            .bold()
                    }
                }
                
                Section("Export CSV") {
                    ShareLink(item: generateCSV(), preview: SharePreview("Expenses.csv", image: Image(.exportIcon)))
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                }
                .listRowBackground(Color.blue)
                
                Section("Export JSON") {
                    if let url = generateJSON() {
                        ShareLink(item: url, preview: SharePreview("Expenses.json", image: Image(.exportIcon)))
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                    }
                }
                .listRowBackground(Color.blue)
                
                Section {
                    Button("Import Data") {
                        showingImport = true
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                }
                .listRowBackground(Color.blue)
            }
            .navigationTitle("Export and import data")
            .fileImporter(isPresented: $showingImport, allowedContentTypes: [.json, .plainText]) { result in
                switch result {
                case .success(let fileURL):
                    importData(from: fileURL)
                    dismiss()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    dismiss()
                }
            }
        }
    }
    
    func generateCSV() -> URL {
        print("Generating csv")
        let fetchDescriptor = FetchDescriptor<Expense>()
        let expenses = try! modelContext.fetch(fetchDescriptor)
        
        var fileURL: URL!
        
        let heading = "Item,Type,Amount,Date\n"
        let rows = expenses.map { "\($0.item),\($0.type),\($0.amount),\($0.date.ISO8601Format())" }
        let stringData = heading + rows.joined(separator: "\n")
        
        do {
            let path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            
            fileURL = path.appendingPathComponent("Expenses.csv")
            
            try stringData.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to generate csv file.")
        }
        
        return fileURL
    }
    
    func generateJSON() -> URL? {
        print("Generating JSON")
        let fetchDescriptor = FetchDescriptor<Expense>()
        guard let expenses = try? modelContext.fetch(fetchDescriptor) else { return nil }
        
        var fileURL: URL
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            
            fileURL = path.appendingPathComponent("Expenses.json")
            
            let encoded = try encoder.encode(expenses)
            try encoded.write(to: fileURL, options: [.atomic, .completeFileProtection])
            
            return fileURL
        } catch {
            return nil
        }
    }
    
    func importData(from file: URL) {
        if file.startAccessingSecurityScopedResource() {
            defer { file.stopAccessingSecurityScopedResource() }
            
            let urlExtension: String = file.pathExtension
            
            if urlExtension == "json" {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                do {
                    let data = try Data(contentsOf: file)
                    let decoded = try decoder.decode([Expense].self, from: data)
                    
                    for expense in decoded {
                        modelContext.insert(expense)
                    }
                    
                } catch {
                    print("Failed to load data from file: \(error.localizedDescription)")
                }
            } else if urlExtension == "csv" {
                guard let csvString = try? String(contentsOf: file) else { return }
                var  csvArray = csvString.components(separatedBy: "\n")
                guard csvArray[0] == "Item,Type,Amount,Date" else { return }
                
                csvArray.remove(at: 0)
                
                for item in csvArray {
                    let itemArray = item.components(separatedBy: ",")
                    guard let amount = Int(itemArray[2]) else { return }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    guard let date = dateFormatter.date(from: itemArray[3]) else { return }
                    
                    let newExpense = Expense(item: itemArray[0], type: itemArray[1], amount: amount, date: date)
                    modelContext.insert(newExpense)
                }
            }
        }
    }
}
