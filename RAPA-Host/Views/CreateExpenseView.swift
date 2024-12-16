


import SwiftUI


enum ExpenseCategory: String, CaseIterable {
    case food
    case transportation
    case entertainment
    case housing
    case personalCare
    case savings
    case other
}



struct CreateExpenseView: View {
    @StateObject var expenseForm: CreateExpenseForm = CreateExpenseForm()
    @StateObject var expenseVM: ExpenseViewModel = ExpenseViewModel()
    
    
    
    
    var body: some View {
        TextField(NAME_STRING, text: $expenseForm.name)
        TextField("Amount", value: $expenseForm.amount, formatter: expenseForm.currencyFormatter)
              .keyboardType(.decimalPad)
              .frame(width: 100)
        DatePicker(EXPENSE_DATE_STRING, selection: $expenseForm.expenseDate)
        Picker(CURRENCY_STRING,  selection: $expenseForm.amountCurrency) {
            ForEach(CurrencyOptions.allCases, id: \.self) { curr in
                Text(curr.rawValue).tag(curr as CurrencyOptions?)
            }
        }
        Toggle(REIMBURSABLE_STRING, isOn: $expenseForm.isReimbursable)
        Toggle(REIMBURSED_STRING, isOn: $expenseForm.isReimbursed)
        
        Picker(CATEGORY_STRING, selection: $expenseForm.category) {
            Text(PICK_A_CATEGORY).tag(nil as ExpenseCategory?)
            ForEach(ExpenseCategory.allCases, id: \.self) { category in
                Text(category.rawValue).tag(category as ExpenseCategory?)
            }
        }
        Picker(ORGANIZATION_STRING, selection: $expenseForm.organization) {
            Text(PICK_AN_ORG).tag(nil as UUID?)
           
            ForEach(expenseVM.orgs, id: \.self) { organization in
                Text(organization.name).tag(organization.id as UUID?)
            }
        }.onAppear {
            expenseVM.listOrgs()
        }
        Picker(PERSON_STRING, selection: $expenseForm.reimburseTo) {
            Text(PICK_A_PERSON).tag(nil as UUID?)
            ForEach(expenseVM.users, id: \.self) { person in
                Text(person.email).tag(person.id as UUID?)
            }
        }.onAppear {
            expenseVM.listUsers()
        }
        Picker(REPORT_STRING, selection: $expenseForm.reimburseTo) {
            Text(PICK_A_REPORT).tag(nil as UUID?)
            ForEach(expenseVM.reports, id: \.self) { report in
                Text(report.name ?? "").tag(report.id as UUID?)
            }
        }.onAppear {
            expenseVM.listReports()
        }
        
        Picker(EXPENSE_CATEGORY_STRING, selection: $expenseForm.category) {
          
            Text(EXPENSE_PICK_A_CATEGORY).tag(nil as String?)
                ForEach(expenseVM.expenseCats, id: \.self) { item in
                    if item.count == 2 {
                        Text(item[0]).tag(item[1] as String?)
                    }
                }
        }.onAppear() {
            expenseVM.listExpenseCategories()
        }
        Picker(EXPENSE_CASH_FLOW_STRING, selection: $expenseForm.cashFlowType){
            Text(EXPENSE_PICK_A_CASH_FLOW_TYPE).tag(nil as String?)
            ForEach(expenseVM.expenseCashFlowTypes, id: \.self) { item in
                    if item.count == 2 {
                        Text(item[0]).tag(item[1] as String?)
                    }
                }
        }.onAppear() {
            expenseVM.listCashFlowTypes()
        }

                    Button("Pick Files") {
                        expenseVM.showFilePicker = true
                    }.fileImporter(isPresented: $expenseVM.showFilePicker, allowedContentTypes: [.text, .image]) { result in
                        print("Selected Files: \(result)")
                        
                    }
//            if expenseVM.showFilePicker {
//                FilePicker(allowedTypes: ["public.item"], allowsMultipleSelection: true) { urls in
//                    expenseVM.selectedFiles = urls
//                }
//            }
        
//        ReceiptsDisplayView(currentIndex: .constant(0), receipts: .constant(expenseVM.selectedFiles.map{ReceiptShape(id: UUID(), asset: $0.absoluteString, expense: nil, expenseRef: nil)}))
        List(expenseVM.selectedFiles, id: \.self) { file in
            if let image = UIImage(contentsOfFile: file.absoluteString) {
                 Image(uiImage: image)
            }else {
                Text("Error")
            }
            }
    }
}

#Preview {
    CreateExpenseView()
}
