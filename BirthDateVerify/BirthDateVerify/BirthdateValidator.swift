import SwiftUI

struct BirthDater: ReducerProtocol {
  struct State: Equatable {
    var dateOnRecord: Date
    @BindableState var showAlert: Bool
    @BindableState var proceedToNext: Bool
    var hasMadeSelection = false
    var datesMatched = false
  }
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case dismissAlert
    case shouldProceed
    case checkDateSelected(Date)
  }
  var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(_):
        return .none
      case .dismissAlert:
        state.showAlert.toggle()
        return .none
      case .shouldProceed:
        state.proceedToNext.toggle()
        state.showAlert = false
        return .none
      case let .checkDateSelected(selectedDate):
        state.hasMadeSelection.toggle()
        if Calendar.current.isDate(selectedDate, inSameDayAs: state.dateOnRecord) {
          state.datesMatched = true
          state.showAlert.toggle()
          state.proceedToNext.toggle()
        } else {
          state.datesMatched = false
        }
        return .none
      }
    }
  }
  
}

struct BirthDateAlertView: View {
  let store: StoreOf<BirthDater>
  
  @State private var selectedDate = Date()
  
  struct Constants {
    static let frameWidth = UIScreen.main.bounds.width * 0.92
    static let buttonHeight = UIScreen.main.bounds.height * 0.054
  }
  
  // MARK: - main body
  public var body: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        Color(white: 0, opacity: 0.66).ignoresSafeArea()
        VStack {
          HStack {
            Text("Verify your date of Birth").font(.title3).bold()
              .foregroundColor(Color.black)
            Spacer()
            Button(action: {
              viewStore.send(.dismissAlert)
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
            if viewStore.hasMadeSelection {
              Text(viewStore.datesMatched ? "Verified" : "Incorrect")
                .foregroundColor(viewStore.datesMatched ? .green : .red)
                .bold()
            }
            Button(action: {
              viewStore.send(.checkDateSelected(selectedDate))
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
      .navigationBarHidden(viewStore.showAlert)
      .opacity(viewStore.showAlert ? 1 : 0)
      .animation(.default, value: viewStore.showAlert)
    }
  }
  
}



// MARK: - AlertModallyModifier
struct BirthDateAlertModifier: ViewModifier {
  var date: Date
  @Binding var showAlert: Bool
  @Binding var proceedToNext: Bool
  func body(content: Content) -> some View {
    ZStack {
      content
      BirthDateAlertView(store: .init(
        initialState: BirthDater.State(
          dateOnRecord: date, showAlert: showAlert, proceedToNext: proceedToNext),
        reducer: BirthDater()
      )
      )}
  }
}
extension View {
  public func validatingBirthDate(dateOnRecord: Date, isShowing: Binding<Bool>, proceedToNext: Binding<Bool>) -> some View {
    return modifier(BirthDateAlertModifier(date: dateOnRecord, showAlert: isShowing, proceedToNext: proceedToNext))
  }
}

struct RefillMedsView: View {
  let dateOnRecord: Date = mockAPIDateValue()
  @State var showBirthDateAlert = false
  @State var proceed = false
  
  var body: some View {
    NavigationView {
      VStack {
        Text("Your Medications").font(.title)
        Divider()
        HStack {
          Text("Magic Pills")
          Image(systemName: "pills.fill")
          Spacer()
          Button(action: {
            showBirthDateAlert.toggle()
          }, label: {
            Text("Refil Now")
          }).buttonStyle(.borderedProminent)
        }
        Spacer()
        NavigationLink(
          destination: PaymentMedsView(),
          isActive: $proceed) { EmptyView() }
        Divider()
        VStack(alignment: .leading, spacing: 12) {
          Text("(Cheat Section)").bold()
          Text("For date of birth, pick October 31, 2022")
          Button(action: {
            proceed.toggle()
          }, label: {
            Text("Destination Preview >")
          })
        }
      }
      .padding()
      .validatingBirthDate(dateOnRecord: dateOnRecord, isShowing: $showBirthDateAlert, proceedToNext: $proceed)
    }
  }
  
  static func mockAPIDateValue() -> Date {
    let dateOnRecordString = "2022-10-31"
    let f = DateFormatter()
    f.locale = Locale(identifier: "en_US_POSIX")
    f.dateFormat = "yyyy-MM-dd"
    return f.date(from: dateOnRecordString) ?? Date()
  }
}

struct PaymentMedsView: View {
  
  var body: some View {
    VStack {
      Text("Payment for Meds").font(.title)
      Divider()
      HStack {
        Text("Magic Pills")
        Image(systemName: "pills.fill")
        Spacer()
        Text("Quantity: 30")
      }
      Button(action: {}, label: {
        Text("Pay Now")
      }).buttonStyle(.borderedProminent)
      Spacer()
    }
    .padding()
  }
  
}

