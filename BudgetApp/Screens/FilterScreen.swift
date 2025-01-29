//
//  FilterScreen.swift
//  BudgetApp
//
//  Created by Anket Kohak on 28/01/25.
//

import SwiftUI

struct FilterScreen: View {
    // MARK: - Varibles
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    @State private var selectedTags: Set<Tag> = []
    
    @State private var selectedSortOption:SortOptions? = nil
    @State private var selectedSortDirection:SortDirection = .asc
    
    @State private var filterdExpenses: [Expense] = []
    @State private var showAll: Bool = false
    
    @State private var startPrice: Double?
    @State private var endPrice: Double?
    
    @State private var title: String = ""
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    
    // MARK: - Enum
    private enum SortOptions: CaseIterable,Identifiable{
        case title
        case date
        
        var id :SortOptions{
            return self
        }
        
        var title:String{
            switch self{
            case .title:
                return "Title"
            case .date:
                return "Date"
            }
        }
        
        var key:String{
            switch self{
            case .title:
                return "title"
            case .date:
                return "dateCreated"
            }
        }
        
    }
    private enum SortDirection: CaseIterable,Identifiable{
        case asc
        case desc
        
        var id :SortDirection{
            return self
        }
        
        var title:String{
            switch self{
            case .asc:
                return "Asending"
            case .desc:
                return "Descending"
            }
        }
        
    }
    // MARK: - functions
    private func  performSort(){
        guard let sortOption = selectedSortOption else { return }
        let request = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key : sortOption.key, ascending: selectedSortDirection == .asc ? true: false)]
        
        do{
            filterdExpenses = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    
    private func filterTags(){
        if selectedTags.isEmpty{
            return
        }
        let selectedTagName = selectedTags.map{$0.name}
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "ANY tags.name IN %@", selectedTagName)
        do{
            filterdExpenses = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    
    private func filterByPrice(){
        guard let startPrice = startPrice, let endPrice = endPrice else {
            return
        }
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "amount >= %@ AND amount <= %@", NSNumber(value: startPrice),
                                        NSNumber(value: endPrice))
        
        do{
            filterdExpenses = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    private  func filterByTitle(){
        if !title.isEmpty{
            let request = Expense.fetchRequest()
            request.predicate = NSPredicate(format: "title BEGINSWITH %@", NSString(string: title))
            
            do{
                filterdExpenses = try context.fetch(request)
            }catch{
                print(error)
            }
            
        }
    }
    private func filterByDate(){
        let request = Expense.fetchRequest()
        
        request.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
        
        do{
            filterdExpenses = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    // MARK: - Body
    
    var body: some View {
        List{ //parent stack
            // MARK: - Sorting
            // MARK:  SortOption
            Section("Sort"){
                Picker("Sort Option", selection: $selectedSortOption){
                    Text("Select").tag(Optional<SortOptions>(nil))
                    ForEach(SortOptions.allCases){option in
                        Text(option.title)
                            .tag(Optional(option))
                    }
                }
                // MARK: SortDirection
                Picker("Sort Direction",selection: $selectedSortDirection){
                    ForEach(SortDirection.allCases){ option in
                        Text(option.title)
                            .tag(option)
                    }
                }
                HStack{
                    Spacer()
                    Button("Sort"){
                        performSort()
                    }.buttonStyle(.borderless)
                    Spacer()
                }
            }
            // MARK: Tags
            Section("Filter by Tags"){
                TagsView(selectedTags: $selectedTags)
                    .onChange(of: selectedTags,filterTags)
            }
            Section("Filter By Price"){
                HStack{
                    TextField("Start Price", value: $startPrice, format: .number)
                        .textFieldStyle(.roundedBorder)
                    TextField("End Price", value: $endPrice, format: .number)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Search"){
                        filterByPrice()
                    }
                }
            }
            Section("Filter By title"){
                HStack{
                    TextField("Enter title",text: $title)
                        .textFieldStyle(.roundedBorder)
                    Button("Search"){
                        filterByTitle()
                    }
                }
                
            }
            Section("Filter by Date"){
                DatePicker("Start Date" ,selection: $startDate,displayedComponents: .date)
                DatePicker("End Date" ,selection: $endDate,displayedComponents: .date)
                Button("Search"){
                    filterByDate()
                }
            }
            
            // MARK: Display
            Section("Expenses"){
                ForEach(filterdExpenses){ expense in
                    ExpenseCellView(expense: expense)
                }
            }
            
            HStack{
                // MARK: ShowAll
                Spacer()
                Button("Show All"){
                    selectedTags = []
                    filterdExpenses = expenses.map{$0}
                }
                Spacer()
            }
        }.onChange(of: showAll, initial: false,{
            print("onChange")
            showAll = false
        })
        .padding()
        .navigationTitle("Filter")
    }
}

#Preview {
    NavigationStack{
        FilterScreen()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}
