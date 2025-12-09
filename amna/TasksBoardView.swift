//
//  TasksBoardView.swift
//  team15
//
//  Created by Amna  on 17/06/1447 AH.
//
//
//  TasksBoardView.swift
//  team15
//

// TasksBoardView.swift
// team15

import SwiftUI
internal import UniformTypeIdentifiers

struct TasksBoardView: View {
    
    @StateObject private var vm = TasksBoardViewModel()
    @Environment(\.dismiss) private var dismiss   // زر الرجوع
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.98, green: 0.95, blue: 0.90)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    
                    // MARK: - الهيدر (بروفايل + زر رجوع)
                    HStack {
                        if vm.isArabic {
                            profileCircle
                            Spacer()
                            backButton
                        } else {
                            backButton
                            Spacer()
                            profileCircle
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // MARK: - العنوان + اسم الطفل
                    VStack(spacing: 4) {
                        Text(vm.title(for: "My daily schedule", arabic: "جدول مهامي اليومية"))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text(vm.title(for: "Good luck,", arabic: "حظاً سعيداً،") + " " + vm.childName)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black.opacity(0.8))
                    }
                    .padding(.top, 4)
                    
                    // MARK: - Progress
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(vm.title(for: "Today's progress", arabic: "تقدّم اليوم"))
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Text("\(Int(vm.dailyProgress * 100))%")
                                .font(.system(size: 14))
                        }
                        ProgressView(value: vm.dailyProgress)
                            .tint(.green)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                    
                    // ملصق أحسنت
                    if vm.showWellDoneSticker {
                        Text(vm.title(for: "Great job! ⭐️", arabic: "أحسنت! ⭐️"))
                            .font(.system(size: 18, weight: .bold))
                            .padding(8)
                            .background(Color.yellow.opacity(0.6))
                            .cornerRadius(16)
                    }
                    
                    // MARK: - قائمة المهام المتاحة (على سطرين)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 12) {
                            ForEach(vm.availableTasks) { template in
                                TaskTemplateChip(template: template, isArabic: vm.isArabic)
                                    .onDrag {
                                        vm.draggingTemplate = template
                                        return NSItemProvider(object: template.id.uuidString as NSString)
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 90)
                    .padding(.top, 4)
                    
                    // زر إضافة مهمة مستقبلًا (الآن بدون منطق، فقط تصميم)
                    Button(action: {
                        // لاحقًا: فتح شاشة إضافة مهمة جديدة
                    }) {
                        Text(vm.title(for: "Add task", arabic: "إضافة مهمة"))
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(20)
                    }
                    
                    // MARK: - جدول الأوقات (الأعمدة)
                    ScrollView(.horizontal) {
                        HStack(alignment: .top, spacing: 12) {
                            ForEach(TaskTimeSlot.allCases) { slot in
                                TimeSlotColumn(slot: slot)
                                    .environmentObject(vm)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.bottom, 8)
                    }
                    
                    Spacer()
                }
            }
            .environment(\.layoutDirection, vm.isArabic ? .rightToLeft : .leftToRight)
        }
    }
    
    // MARK: - Subviews
    
    /// دائرة صورة الطفل
    private var profileCircle: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 52, height: 52)
                .shadow(radius: 3)
            
            Image("taifpic") // نفس شخصية التطبيق
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
        }
    }
    
    /// زر رجوع
    private var backButton: some View {
        Button(action: { dismiss() }) {
            HStack(spacing: 4) {
                Image(systemName: vm.isArabic ? "chevron.forward" : "chevron.backward")
                Text(vm.title(for: "Back", arabic: "رجوع"))
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.black)
        }
    }
}

// MARK: - شريحة مهمة من القائمة العلوية
struct TaskTemplateChip: View {
    
    let template: TaskTemplate
    let isArabic: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Text(template.emoji)
            Text(isArabic ? template.nameArabic : template.nameEnglish)
                .font(.system(size: 14, weight: .medium))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 1)
    }
}

// MARK: - عمود وقت معيّن
struct TimeSlotColumn: View {
    
    let slot: TaskTimeSlot
    @EnvironmentObject var vm: TasksBoardViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            // العنوان + الأيقونة
            HStack(spacing: 6) {
                Text(slot.icon)
                Text(slot.title(isArabic: vm.isArabic))
                    .font(.system(size: 16, weight: .semibold))
            }
            
            // أوقات البداية والنهاية (Editable TextFields)
            VStack(alignment: .leading, spacing: 4) {
                Text(vm.title(for: "Start time", arabic: "وقت البدء"))
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.7))
                TextField(vm.title(for: "e.g. 5:00", arabic: "مثال: ٥:٠٠"),
                          text: Binding(
                            get: { vm.startTimes[slot] ?? "" },
                            set: { vm.startTimes[slot] = $0 }
                          ))
                .font(.system(size: 13))
                .textFieldStyle(.roundedBorder)
                
                Text(vm.title(for: "End time", arabic: "وقت الانتهاء"))
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.7))
                TextField(vm.title(for: "e.g. 6:00", arabic: "مثال: ٦:٠٠"),
                          text: Binding(
                            get: { vm.endTimes[slot] ?? "" },
                            set: { vm.endTimes[slot] = $0 }
                          ))
                .font(.system(size: 13))
                .textFieldStyle(.roundedBorder)
            }
            
            // منطقة الإسقاط + المهام
            VStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                    .foregroundColor(.gray.opacity(0.4))
                    .frame(height: 36)
                    .overlay(
                        Text(vm.title(for: "Drop tasks here", arabic: "اسحب المهمة هنا"))
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    )
                    .onDrop(of: [.text], isTargeted: nil) { _ in
                        if let template = vm.draggingTemplate {
                            vm.assign(template, to: slot)
                            vm.draggingTemplate = nil
                        }
                        return true
                    }
                
                let tasks = vm.schedule[slot] ?? []
                ForEach(tasks) { assigned in
                    HStack(spacing: 6) {
                        Button(action: {
                            vm.toggleDone(slot: slot, task: assigned)
                        }) {
                            Image(systemName: assigned.isDone ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 20))
                        }
                        
                        Text(assigned.template.emoji)
                        
                        Text(vm.isArabic ? assigned.template.nameArabic : assigned.template.nameEnglish)
                            .font(.system(size: 14))
                            .strikethrough(assigned.isDone, color: .black)
                        
                        Spacer()
                        
                        // زر حذف المهمة من هذا الوقت
                        Button(action: {
                            vm.remove(task: assigned, from: slot)
                        }) {
                            Image(systemName: "trash")
                                .font(.system(size: 14))
                        }
                    }
                    .padding(8)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                }
            }
            .padding(8)
            .background(Color.white.opacity(0.6))
            .cornerRadius(20)
        }
        .frame(width: 210)
    }
}

#Preview {
    TasksBoardView()
}
