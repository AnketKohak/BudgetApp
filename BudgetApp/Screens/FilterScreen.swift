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
    @State private var selectedFilterOption:FilterOption? = nil
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
    private enum SortOptions: String,CaseIterable,Identifiable{
        case title = "title"
        case date = "dateCreated"
        
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
            rawValue
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
    
    private enum FilterOption:Identifiable , Equatable{
        case none
        case byTags(Set<Tag>)
        case byPriceRange(minPrice: Double, maxPrice: Double)
        case byTitle(String)
        case byDate(startDate: Date, endDate: Date)
        
        var id:String{
            switch self{
            case .byTags:
                return "tags"
            case .byPriceRange:
                return "priceRange"
            case .byTitle:
                return "title"
            case .byDate:
                return "date"
            case .none:
                return "none"
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
    
    private func performFilter(){
        guard let selectedFilterOption = selectedFilterOption else{ return }
        
        let request  = Expense.fetchRequest()
        
        switch selectedFilterOption {
        case .none:
            request.predicate = NSPredicate(value: true)
        case .byTags(let tags):
            let tagName = tags.map{ $0.name }
            request.predicate = NSPredicate(format: "ANY tags.name IN %@", tagName)

        case .byPriceRange(let minPrice, let maxPrice):
            request.predicate = NSPredicate(format: "amount >= %@ AND amount <= %@", NSNumber(value: minPrice),NSNumber(value: maxPrice))
        case .byTitle(let title ):
            request.predicate = NSPredicate(format: "title BEGINSWITH %@", NSString(string: title))
        case .byDate(let startDate, let endDate):
            request.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
        }
        
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
                    .onChange(of: selectedTags,{
                        selectedFilterOption = .byTags(selectedTags)
                    })
            }
            Section("Filter By Price"){
                HStack{
                    TextField("Start Price", value: $startPrice, format: .number)
                        .textFieldStyle(.roundedBorder)
                    TextField("End Price", value: $endPrice, format: .number)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Search"){
                        guard let startPrice = startPrice,let endPrice = endPrice else {return}
                        selectedFilterOption = .byPriceRange(minPrice: startPrice, maxPrice: endPrice)
                    }
                }
            }
            Section("Filter By title"){
                HStack{
                    TextField("Enter title",text: $title)
                        .textFieldStyle(.roundedBorder)
                    Button("Search"){
                        selectedFilterOption = .byTitle(title)
                    }
                }
                
            }
            Section("Filter by Date"){
                DatePicker("Start Date" ,selection: $startDate,displayedComponents: .date)
                DatePicker("End Date" ,selection: $endDate,displayedComponents: .date)
                Button("Search"){
                    selectedFilterOption = .byDate(startDate: startDate, endDate: endDate)
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
                    selectedFilterOption = FilterOption.none
                }
                Spacer()
            }
        }.onChange(of: selectedFilterOption, performFilter)
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
