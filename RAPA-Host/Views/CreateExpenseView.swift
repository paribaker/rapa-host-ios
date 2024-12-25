


import SwiftUI
import PhotosUI


struct CreateExpenseView: View {
    @StateObject var expenseForm: CreateExpenseForm = CreateExpenseForm()
    @StateObject var expenseVM: ExpenseViewModel = ExpenseViewModel()
    @EnvironmentObject var session: SessionManager
    
    
    
    
    
    var body: some View {
        Text(SessionManager.shared.userAccount?.email ?? "")
        TextField(NAME_STRING, text: $expenseVM.expenseForm.name)
        Picker(CURRENCY_STRING,  selection: $expenseVM.expenseForm.amountCurrency) {
            ForEach(CurrencyOptions.allCases, id: \.self) { curr in
                Text(curr.rawValue).tag(curr as CurrencyOptions?)
            }
        }.pickerStyle(.segmented)
        TextField("Amount", value: $expenseVM.expenseForm.amount, formatter: expenseVM.getCurrencyFormatter(for: $expenseVM.expenseForm.amountCurrency.wrappedValue.rawValue))
              .keyboardType(.decimalPad)
              .frame(width: 100)
        DatePicker(EXPENSE_DATE_STRING, selection: $expenseVM.expenseForm.expenseDate, displayedComponents: [.date])

        Toggle(REIMBURSABLE_STRING, isOn: $expenseVM.expenseForm.isReimbursable)
        Toggle(REIMBURSED_STRING, isOn: $expenseVM.expenseForm.isReimbursed)
        
//        Picker(CATEGORY_STRING, selection: $expenseVM.expenseForm.category) {
//            Text(PICK_A_CATEGORY).tag(nil as ExpenseCategory?)
//            ForEach(ExpenseCategory.allCases, id: \.self) { category in
//                Text(category.rawValue).tag(category as ExpenseCategory?)
//            }
//        }
        Picker(ORGANIZATION_STRING, selection: $expenseVM.expenseForm.organization) {
            Text(PICK_AN_ORG).tag(nil as String?)
           
            ForEach(expenseVM.orgs, id: \.self) { organization in
                Text(organization.name).tag(organization.id as String?)
            }
        }.onAppear {
            expenseVM.listOrgs()
        }
        Picker(PERSON_STRING, selection: $expenseVM.expenseForm.reimburseTo) {
            Text(PICK_A_PERSON).tag(nil as String?)
            ForEach(expenseVM.users, id: \.self) { person in
                Text(person.email).tag(person.id as String?)
            }
        }.onAppear {
            expenseVM.listUsers()
        }
        
        Picker(EXPENSE_CATEGORY_STRING, selection: $expenseVM.expenseForm.category) {
          
            Text(EXPENSE_PICK_A_CATEGORY).tag(nil as String?)
                ForEach(expenseVM.expenseCats, id: \.self) { item in
                    if item.count == 2 {
                        Text(item[1]).tag(item[0] as String?)
                    }
                }
        }.onAppear() {
            expenseVM.listExpenseCategories()
        }
        Picker(EXPENSE_CASH_FLOW_STRING, selection: $expenseVM.expenseForm.cashFlowType){
            Text(EXPENSE_PICK_A_CASH_FLOW_TYPE).tag(nil as String?)
            ForEach(expenseVM.expenseCashFlowTypes, id: \.self) { item in
                    if item.count == 2 {
                        Text(item[1]).tag(item[0] as String?)
                    }
                }
        }.onAppear() {
            expenseVM.listCashFlowTypes()
        }
        Picker(REPORT_STRING, selection: $expenseVM.expenseForm.report) {
            Text(PICK_A_REPORT).tag(nil as String?)
            ForEach(expenseVM.reports, id: \.self) { report in
                Text(report.name ?? "").tag(report.id as String?)
            }
        }.onAppear {
            expenseVM.listReports()
        }
        
        
        Button("Attach Receipt") {
            expenseVM.showDocumentTypeOptions = true
        }
        .actionSheet(isPresented: $expenseVM.showDocumentTypeOptions) {
            ActionSheet(
                title: Text("Select Source"),
                buttons: [
                    .default(Text("Photos")) {
                        expenseVM.showImagePicker = true
                    },
                    .default(Text("Pick Files")) {
                        expenseVM.showFilePicker = true
                    },
                    .cancel()
                ]
            )
        }.photosPicker(isPresented: $expenseVM.showImagePicker, selection: $expenseVM.selectedImage, matching: .any(of: [.images, .not(.screenshots)]))
        .fileImporter(isPresented: $expenseVM.showFilePicker, allowedContentTypes: [.image, .pdf]) { result in
            switch result {
            case .success(let url):
                print("Selected file: \(url)")
                // Handle the selected file URL
            case .failure(let error):
                print("Failed to pick file: \(error.localizedDescription)")
            }
        }
        
        Button("Create Expense") {
            if expenseVM.expenseForm.isValid {
                expenseVM.createExpense(expense: expenseVM.expenseForm.value)
            }
            
            
            else{
                print("Expense Form is invalid")
            }
            
        }.sheet(isPresented: $expenseVM.showErrorModal){
            Text(expenseVM.error)
                .font(.headline)
        }
    }
}

#Preview {
    CreateExpenseView()
}
