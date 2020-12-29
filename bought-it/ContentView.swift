//
//  ContentView.swift
//  bought-it
//
//  Created by yuhori on 2020/12/29.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // 金額
    @State private var price = "0"
    @State private var sum = 0

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        VStack {
            // タイトル
            Text("Bought It !!!")
            // 金額入力フォーム
            HStack {
                TextField("0", text: $price)
                Text("円")
            }
            // ボタン
            HStack {
                // 追加
                Button(action: {
                    // 記録する
                    addItem()
                }, label: {
                    Text("追加")
                })
                // 削除
                Button(action: {
                    // 削除する
                    deleteItems(offsets: IndexSet(integersIn: 0..<self.items.count))
                }, label: {
                    Text("削除")
                })
            }
            // リスト表示
            List {
                ForEach(items) { item in
                    Text("Item at \(item.timestamp!, formatter: itemFormatter) \(item.price!)円")
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                #if os(iOS)
                EditButton()
                #endif

                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
            // 合計を表示
            Button(action: {
                var sum = 0
                for item in items {
                    if let p = Int(item.price!) {
                        sum += p
                    } else {
                        sum = 0
                        break
                    }
                }
                self.sum = sum
            }, label: {
                Text("sum : \(self.sum)")
            })
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            // 時間
            newItem.timestamp = Date()
            // 金額
            newItem.price = self.price
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
