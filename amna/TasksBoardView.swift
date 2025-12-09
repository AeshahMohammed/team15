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

//
//  TasksBoardView.swift
//  team15
//

import SwiftUI
import UniformTypeIdentifiers

struct TasksBoardView: View {
    
    @StateObject private var vm = TasksBoardViewModel()
    @Environment(\.dismiss) private var dismiss
    
    // لتعديل وقت مهمة
    @State private var editingAssignment: TaskAssignment? = nil
    @State private var tempStartTime: String = ""
    @State private var tempEndTime: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.98, green: 0.95, blue: 0.90)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    
                    // MARK: - الهيدر (رجوع + بروفايل)
                    header
                    
                    // MARK: - العنوان
                    VStack(spacing: 4) {
                        Text(vm.text("My daily schedule", "جدول مهامي اليومية"))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                        Text(vm.text("Good luck,", "حظاً سعيداً،") + " " + vm.childName)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black.opacity(0.8))
                    }
                    
                    // MARK: - Progress
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(vm.text("Today's progress", "تقدّم اليوم"))
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Text("\(Int(vm.dailyProgress * 100))%")
                                .font(.system(size: 14))
                        }
                        ProgressView(value: vm.dailyProgress)
                            .tint(.green)
                    }
                    .padding(.horizontal, 20)
                    
                    if vm.showWellDoneSticker {
                        Text(vm.text("Great job! ⭐️", "أحسنت! ⭐️"))
                            .font(.system(size: 18, weight: .bold))
                            .padding(8)
                            .background(Color.yellow.opacity(0.7))
                            .cornerRadius(16)
                    }
                    
                    // MARK: - المهام المتاحة (للسحب)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(vm.availableTasks) { task in
                                TaskTemplateChip(template: task, isArabic: vm.isArabic)
                                    .onDrag {
                                        vm.draggingTemplate = task
                                        return NSItemProvider(object: task.id.uuidString as NSString)
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 80)
                    
                    // MARK: - الأعمدة (فجر - عشاء)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 12) {
                            ForEach(TaskTimeSlot.allCases) { slot in
                                TimeSlotColumn(
                                    slot: slot,
                                    assignments: vm.tasks(for: slot),
                                    isArabic: vm.isArabic,
                                    onDropTemplate: { template in
                                        vm.assign(template, to: slot)
                                    },
                                    onToggleDone: { assignment in
                                        vm.toggleDone(assignment)
                                    },
                                    onRemove: { assignment in
                                        vm.remove(assignment)
                                    },
                                    onEditTime: { assignment in
                                        openEditor(for: assignment)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.bottom, 8)
                    }
                    
                    Spacer()
                }
            }
            .sheet(item: $editingAssignment) { assignment in
                timeEditorSheet(for: assignment)
            }
            .environment(\.layoutDirection, vm.isArabic ? .rightToLeft : .leftToRight)
        }
    }
    
    // MARK: - Subviews
    
    private var header: some View {
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
    }
    
    private var profileCircle: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 52, height: 52)
                .shadow(radius: 3)
            
            Image("taifpic")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
        }
    }
    
    private var backButton: some View {
        Button(action: { dismiss() }) {
            HStack(spacing: 4) {
                Image(systemName: vm.isArabic ? "chevron.forward" : "chevron.backward")
                Text(vm.text("Back", "رجوع"))
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.black)
        }
    }
    
    // فتح شاشة تعديل الوقت
    private func openEditor(for assignment: TaskAssignment) {
        editingAssignment = assignment
        tempStartTime = assignment.startTime
        tempEndTime = assignment.endTime
    }
    
    // شاشة تعديل الوقت
    @ViewBuilder
    private func timeEditorSheet(for assignment: TaskAssignment) -> some View {
        VStack(spacing: 16) {
            Text(vm.text("Edit task time", "تعديل وقت المهمة"))
                .font(.headline)
            
            Text(vm.isArabic ? assignment.template.nameArabic
                             : assignment.template.nameEnglish)
                .font(.system(size: 18, weight: .semibold))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(vm.text("Start time", "وقت البدء"))
                TextField(vm.text("e.g. 5:00", "مثال: ٥:٠٠"), text: $tempStartTime)
                    .textFieldStyle(.roundedBorder)
                
                Text(vm.text("End time", "وقت الانتهاء"))
                    .padding(.top, 4)
                TextField(vm.text("e.g. 5:30", "مثال: ٥:٣٠"), text: $tempEndTime)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal, 20)
            
            HStack(spacing: 16) {
                Button {
                    editingAssignment = nil
                } label: {
                    Text(vm.text("Cancel", "إلغاء"))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(20)
                }
                
                Button {
                    vm.updateTimes(
                        for: assignment.id,
                        start: tempStartTime,
                        end: tempEndTime
                    )
                    editingAssignment = nil
                } label: {
                    Text(vm.text("Save", "حفظ"))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.85))
                        .cornerRadius(20)
                }
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .padding(.top, 24)
    }
}

// MARK: - عنصر من قائمة المهام العلوية
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
        .background(Color.white.opacity(0.95))
        .cornerRadius(20)
        .shadow(radius: 1)
    }
}

// MARK: - عمود وقت واحد (الفجر مثلاً)
struct TimeSlotColumn: View {
    
    let slot: TaskTimeSlot
    let assignments: [TaskAssignment]
    let isArabic: Bool
    
    let onDropTemplate: (TaskTemplate) -> Void
    let onToggleDone: (TaskAssignment) -> Void
    let onRemove: (TaskAssignment) -> Void
    let onEditTime: (TaskAssignment) -> Void
    
    @EnvironmentObject private var vmForDrag: TasksBoardViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack(spacing: 6) {
                Text(slot.icon)
                Text(slot.title(isArabic: isArabic))
                    .font(.system(size: 16, weight: .semibold))
            }
            
            // منطقة الإسقاط + المهام
            VStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(height: 36)
                    .overlay(
                        Text(isArabic ? "اسحب المهمة هنا" : "Drop task here")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    )
                    .onDrop(of: [UTType.text], isTargeted: nil) { _ in
                        if let template = vmForDrag.draggingTemplate {
                            onDropTemplate(template)
                            vmForDrag.draggingTemplate = nil
                        }
                        return true
                    }
                
                ForEach(assignments) { assignment in
                    HStack(spacing: 6) {
                        Button {
                            onToggleDone(assignment)
                        } label: {
                            Image(systemName: assignment.isDone ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 18))
                        }
                        
                        Text(assignment.template.emoji)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(isArabic ? assignment.template.nameArabic
                                          : assignment.template.nameEnglish)
                                .font(.system(size: 14))
                                .strikethrough(assignment.isDone, color: .black)
                            
                            Button {
                                onEditTime(assignment)
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                    if assignment.startTime.isEmpty && assignment.endTime.isEmpty {
                                        Text(isArabic ? "وقت المهمة" : "Task time")
                                    } else {
                                        Text("\(assignment.startTime) - \(assignment.endTime)")
                                    }
                                }
                                .font(.system(size: 11))
                                .foregroundColor(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(10)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            onRemove(assignment)
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 14))
                        }
                    }
                    .padding(8)
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(12)
                }
            }
            .padding(8)
            .background(Color.white.opacity(0.6))
            .cornerRadius(20)
        }
        .frame(width: 220)
    }
}

#Preview {
    TasksBoardView()
}
