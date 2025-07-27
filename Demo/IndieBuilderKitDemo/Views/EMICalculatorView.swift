import SwiftUI
import IndieBuilderKit

struct EMICalculatorView: View {
    @State private var loanAmount: String = ""
    @State private var interestRate: String = ""
    @State private var tenure: String = ""
    @State private var emiResult: Double?
    @State private var totalInterest: Double?
    @State private var totalAmount: Double?
    @State private var showError: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Card
                    VStack(spacing: 16) {
                        Image(systemName: "indianrupeesign.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.blue)
                        
                        Text("EMI Calculator")
                            .font(.bold(24))
                            .foregroundColor(.primary)
                        
                        if let emi = emiResult {
                            VStack(spacing: 8) {
                                Text("Monthly EMI")
                                    .font(.medium(14))
                                    .foregroundColor(.secondary)
                                
                                Text(formatCurrency(emi))
                                    .font(.bold(36))
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(16)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    // Input Form
                    VStack(spacing: 20) {
                        InputField(
                            title: "Loan Amount",
                            placeholder: "Ex: 100,000",
                            icon: "banknote",
                            text: $loanAmount,
                            keyboardType: .decimalPad
                        )
                        
                        InputField(
                            title: "Interest Rate (%)",
                            placeholder: "Ex: 10.5",
                            icon: "percent",
                            text: $interestRate,
                            keyboardType: .decimalPad
                        )
                        
                        InputField(
                            title: "Tenure (Months)",
                            placeholder: "Ex: 12",
                            icon: "calendar",
                            text: $tenure,
                            keyboardType: .numberPad
                        )
                        
                        PrimaryButton("Calculate EMI") {
                            calculateEMI()
                        }
                        .padding(.top, 8)
                        
                        SecondaryButton("Reset") {
                            resetFields()
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    // Detailed Breakdown
                    if let totalInterest = totalInterest, let totalAmount = totalAmount {
                        VStack(spacing: 16) {
                            Text("Payment Breakdown")
                                .font(.bold(18))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                BreakdownRow(title: "Total Interest", value: formatCurrency(totalInterest), color: .orange)
                                Divider()
                                BreakdownRow(title: "Total Amount", value: formatCurrency(totalAmount), color: .green)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    }
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationBarHidden(true)
            .alert("Invalid Input", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter valid numeric values for all fields.")
            }
        }
    }
    
    private func calculateEMI() {
        guard let p = Double(loanAmount),
              let r = Double(interestRate),
              let n = Double(tenure),
              p > 0, r > 0, n > 0 else {
            showError = true
            return
        }
        
        let monthlyRate = r / 12 / 100
        let emi = (p * monthlyRate * pow(1 + monthlyRate, n)) / (pow(1 + monthlyRate, n) - 1)
        
        emiResult = emi
        totalAmount = emi * n
        totalInterest = (emi * n) - p
    }
    
    private func resetFields() {
        loanAmount = ""
        interestRate = ""
        tenure = ""
        emiResult = nil
        totalInterest = nil
        totalAmount = nil
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₹" // Using Rupee symbol as per "EMI" context usually implies Indian context, or generic. Can be changed.
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "₹0"
    }
}

struct InputField: View {
    let title: String
    let placeholder: String
    let icon: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.medium(14))
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                    .frame(width: 24)
                
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct BreakdownRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.medium(12))
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.bold(16))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    EMICalculatorView()
}
