


import SwiftUI
import PhotosUI


struct CreateExpenseView: View {
    // @StateObject var expenseForm: CreateExpenseForm = CreateExpenseForm()
    @EnvironmentObject var expenseVM: ExpenseViewModel
    @EnvironmentObject var session: SessionManager
    
    
    var body: some View {
        ScrollView {
            VStack {
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
                
                GeometryReader { geometry in
                    if geometry.size.width > geometry.size.height {
                        // Horizontal layout for landscape mode or larger devices
                        HStack {
                            reimbursablePicker
                            reimbursedPicker
                        }
                    } else {
                        // Vertical layout for portrait mode on mobile devices
                        VStack {
                            reimbursablePicker
                            reimbursedPicker
                        }
                    }
                }
                .padding()
                Picker(PERSON_STRING, selection: $expenseVM.expenseForm.reimburseTo) {
                    Text(PICK_A_PERSON).tag(nil as String?)
                    ForEach(expenseVM.users, id: \.self) { person in
                        Text(person.email).tag(person.id as String?)
                    }
                }.onAppear {
                    expenseVM.listUsers()
                }.disabled($expenseVM.expenseForm.isReimbursable.wrappedValue == false)
                Picker(ORGANIZATION_STRING, selection: $expenseVM.expenseForm.organization) {
                    Text(PICK_AN_ORG).tag(nil as String?)
                    
                    ForEach(expenseVM.orgs, id: \.self) { organization in
                        Text(organization.name).tag(organization.id as String?)
                    }
                }.onAppear {
                    expenseVM.listOrgs()
                    
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
                    ForEach(expenseVM.expenseCashFlowTypes, id: \.self) { item in
                        if item.count == 2 {
                            Text(item[1]).tag(item[0] as String?)
                        }
                    }
                }.onAppear() {
                    expenseVM.listCashFlowTypes()
                }.pickerStyle(.segmented)
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
                }.photosPicker(isPresented: $expenseVM.showImagePicker, selection: $expenseVM.selectedImages, matching: .any(of: [.images]), photoLibrary: .shared())
                    .fileImporter(isPresented: $expenseVM.showFilePicker, allowedContentTypes: [.image, .pdf], allowsMultipleSelection: true) { result in
                        switch result {
                        case .success(let urls):
                            for directory in urls {
                                let gotAccess = directory.startAccessingSecurityScopedResource()
                                if !gotAccess { return }
                                guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: directory.path)) else {
                                    print("Failed to read file data")
                                    return
                                }
                                
                                $expenseVM.expenseForm.newReceipts.wrappedValue.append(
                                    CreateReceiptShape(asset: FileShape(name: directory.lastPathComponent, fileType: directory.pathExtension, data: fileData))
                                )
                                // release access
                                directory.stopAccessingSecurityScopedResource()
                                
                            }
                            
                            // Handle the selected file URL
                        case .failure(let error):
                            print("Failed to pick file: \(error.localizedDescription)")
                        }
                    }
            }
        }
        
        VStack {
            Text("Selected Files")
                .font(.headline)
            List($expenseVM.expenseForm.newReceipts, id: \.self, editActions: .delete){
                Text("\($0.wrappedValue.asset.name)")
            }
            .frame(height: 200)
        }
        .padding()
        
        
        CustomButton(text: "Create Expense", isLoading: $expenseVM.loadingCreateExpense) {
            if expenseVM.expenseForm.isValid {
                expenseVM.createExpense()
            }
            
            
            else{
                print("Expense Form is invalid")
            }
            
        }.sheet(isPresented: $expenseVM.showErrorModal){
            Text(expenseVM.error)
                .font(.headline)
        }
    }
    private var reimbursablePicker: some View {
        Picker(REIMBURSABLE_STRING, selection: $expenseVM.expenseForm.isReimbursable) {
            ForEach([("Reimbursable", true), ("Not Reimbursable", false)], id: \.1) { curr in
                Text(curr.0).tag(curr.1)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    private var reimbursedPicker: some View {
        Picker(REIMBURSED_STRING, selection: $expenseVM.expenseForm.isReimbursed) {
            ForEach([("Reimbursed", true), ("Not Reimbursed", false)], id: \.1) { curr in
                Text(curr.0).tag(curr.1)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .disabled($expenseVM.expenseForm.isReimbursable.wrappedValue == false)
    }
}

#Preview {
    CreateExpenseView()
}
