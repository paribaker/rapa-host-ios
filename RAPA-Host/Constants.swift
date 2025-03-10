//
//  Constants.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/7/24.
//

import Foundation
//let BASE_URL="https://app.rapallc.com/api/"
let BASE_URL=ProcessInfo.processInfo.environment["BASE_URL"]! + "/api/"

// Strings

let searchExpense = "Search Expense"


let OUTFLOW_STRING = "outflow"
let INFLOW_STRING = "inflow"
let REIMBURSABLE_STRING = "reimbursable"
let REIMBURSED_STRING = "reimbursed"
let EXPENSE_STRING = "expense"
let NAME_STRING = "name"
let AMOUNT_STRING = "amount"
let EXPENSE_DATE_STRING = "expense date"
let CATEGORY_STRING = "expense category"
let NOTE_STRING = "notes"
let CURRENCY_STRING = "currency"
let PICK_A_CATEGORY = "pick an expense category"
let PICK_A_CURRENCY = "pick a currency"
let PICK_AN_ORG = "pick an organization"
let ORGANIZATION_STRING = "organization"
let PICK_A_PERSON = "Pick a person to reimburse"
let PERSON_STRING = "person"
let REPORT_STRING = "report"
let PICK_A_REPORT = "Pick a report"
let EXPENSE_CATEGORY_STRING = "Expense Category"
let EXPENSE_CASH_FLOW_STRING = "Expense Cash Flow"
let EXPENSE_PICK_A_CATEGORY = "Pick a category"
let EXPENSE_PICK_A_CASH_FLOW_TYPE = "Pick a cash flow type"


