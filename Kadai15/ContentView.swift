//
//  ContentView.swift
//  Kadai15
//
//  Created by mana on 2022/01/12.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let name: String
    var isChecked: Bool
}

struct ContentView: View {
    @State private var isShowAddItemView = false
    @State private var items: [Item] = [.init(name: "りんご", isChecked: false),
                                        .init(name: "みかん", isChecked: true),
                                        .init(name: "バナナ", isChecked: false),
                                        .init(name: "パイナップル", isChecked: true)]

    var body: some View {
        NavigationView {
            List($items) { $item in
                ItemView(item: $item)
                    .onTapGesture {
                        item.isChecked.toggle()
                    }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowAddItemView = true },
                           label: { Image(systemName: "plus") })
                }
            }
        }
        .fullScreenCover(isPresented: $isShowAddItemView) {
            AddItemView(isShowView: $isShowAddItemView) {
                items.append($0)
            }
        }
    }
}

struct AddItemView: View {
    @Binding var isShowView: Bool
    @State private var name = ""
    let didSave: (Item) -> Void

    var body: some View {
        NavigationView {
            HStack(spacing: 30) {
                Text("名前")
                    .padding(.leading)

                TextField("", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.trailing)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isShowView = false
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        didSave(.init(name: name, isChecked: false))
                        isShowView = false
                    }
                }
            }
        }
    }
}

struct ItemView: View {
    @Binding var item: Item
    private let checkMark = Image(systemName: "checkmark")

    var body: some View {
        HStack {
            if item.isChecked {
                checkMark.foregroundColor(.orange)
            } else {
                checkMark.hidden()
            }

            Text(item.name)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(isShowView: .constant(true), didSave: { _ in  })
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: .constant(.init(name: "みかん", isChecked: true)))
    }
}
