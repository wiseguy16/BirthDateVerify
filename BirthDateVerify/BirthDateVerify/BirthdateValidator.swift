import SwiftUI

// MARK: - BirthDateAlertModifier
struct BirthDateAlertModifier: ViewModifier {
  var date: Date
  @Binding var showAlert: Bool
  @Binding var proceedToNext: Bool
  func body(content: Content) -> some View {
    ZStack {
      content
      BirthDateAlertView(dateOnRecord: date, showAlert: $showAlert, proceedToNext: $proceedToNext)
    }
  }
}

struct BirthDateAlertView: View {
  let dateOnRecord: Date
  @Binding var showAlert: Bool
  @Binding var proceedToNext: Bool
  @State private var hasMadeSelection = false
  @State private var datesMatched = false
  @State private var selectedDate = Date()
  
  struct Constants {
    static let frameWidth = UIScreen.main.bounds.width * 0.92
    static let buttonHeight = UIScreen.main.bounds.height * 0.054
  }
  
  // MARK: - main body
  public var body: some View {
      ZStack {
        Color(white: 0, opacity: 0.66).ignoresSafeArea()
        VStack {
          HStack {
            Text("Verify your date of Birth").font(.title3).bold()
              .foregroundColor(Color.black)
            Spacer()
            Button(action: {
              showAlert.toggle()
            }, label: {
              Image(systemName: "xmark").foregroundColor(Color.gray)
            })
          }
          .padding([.top, .leading, .trailing], 16)
          Divider()
          DatePicker("Enter your birthday", selection: $selectedDate, displayedComponents: [.date])
            .datePickerStyle(.graphical)
          HStack {
            Spacer()
            if hasMadeSelection {
              Text(datesMatched ? "Verified" : "Incorrect")
                .foregroundColor(datesMatched ? .green : .red).bold()
            }
            Button(action: {
              challenge()
            },
                   label: {
              Text("Submit")
                .padding([.leading, .trailing], 16)
                .frame(height: Constants.buttonHeight)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(4)
            })
          }
          .padding(16)
        }
        .frame(width: Constants.frameWidth)
        .background(Color.white)
        .cornerRadius(4)
        .padding([.leading, .trailing], 16)
      }
      .navigationBarHidden(showAlert)
      .opacity(showAlert ? 1 : 0)
      .animation(.default, value: showAlert)
      .onChange(of: showAlert, perform: { showing in
        if showing {
          selectedDate = Date()
        } else {
          hasMadeSelection = false
          datesMatched = false
        }
      })
    }
  
  func challenge() {
    let isCorrect = Calendar.current.isDate(selectedDate, inSameDayAs: dateOnRecord)
   
    if isCorrect {
      datesMatched = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
        showAlert.toggle()
        proceedToNext.toggle()
      }
    } else {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        showAlert.toggle()
      }
    }
    hasMadeSelection = true
  }
  
}

extension View {
  public func validatingBirthDate(dateOnRecord: Date, isShowing: Binding<Bool>, proceedToNext: Binding<Bool>) -> some View {
    return modifier(BirthDateAlertModifier(date: dateOnRecord, showAlert: isShowing, proceedToNext: proceedToNext))
  }
}
