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
//
//
//
//  TasksBoardView.swift
//  team15
//

//
//  TasksBoardView.swift
//  team15

import SwiftUI

struct TasksBoardView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = ScheduleBoardViewModel()

    @State private var showAddTaskSheet = false
    @State private var showManageTasks = false
    @State private var showAchievements = false

    @State private var editingAssignment: ScheduleAssignment? = nil
    @State private var tempStartTime: String = ""
    @State private var tempEndTime: String = ""

    @State private var lastProgress: Double = 0
    @State private var showCongratsOverlay = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.98, green: 0.95, blue: 0.90).ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {

                        header
                        progressCard
                        achievementsButton
                        daySelector
                        taskPalette
                        timeSlotsSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }

                if showCongratsOverlay {
                    congratsOverlay
                }
            }
            .environment(\.layoutDirection, vm.isArabic ? .rightToLeft : .leftToRight)
            .navigationBarBackButtonHidden(true)
        }
        .sheet(isPresented: $showAddTaskSheet) {
            AddTaskSheet(isArabic: vm.isArabic) { ar, en, emoji in
                vm.addCustomTemplate(nameArabic: ar, nameEnglish: en, emoji: emoji)
            }
        }
        .sheet(isPresented: $showManageTasks) {
            TaskManagementView(vm: vm)
        }
        .sheet(item: $editingAssignment) { assignment in
            TimeEditSheet(
                isArabic: vm.isArabic,
                assignment: assignment,
                start: assignment.startTime,
                end: assignment.endTime
            ) { start, end in
                vm.updateTime(for: assignment, start: start, end: end)
            }
        }
        .sheet(isPresented: $showAchievements) {
            AchievementsView()
        }
        .onAppear {
            lastProgress = vm.todayProgress
        }
        .onChange(of: vm.todayProgress) { newValue in
            if lastProgress < 1.0 && newValue == 1.0 {
                withAnimation(.spring()) {
                    showCongratsOverlay = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeOut) {
                        showCongratsOverlay = false
                    }
                }
            }
            lastProgress = newValue
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 12) {
            Button {
                dismiss()
            } label: {
                Image(systemName: vm.isArabic ? "chevron.backward" : "chevron.forward")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())
                    .shadow(radius: 1)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(vm.text("جدول مهامي", "My task schedule"))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)

                Text(vm.text("يساعدك على تنظيم يومك خطوة خطوة", "Helps you organise your day step-by-step"))
                    .font(.system(size: 13))
                    .foregroundColor(.black.opacity(0.6))
            }

            Spacer()
        }
    }

    // MARK: - Progress card

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Text(progressEmoji)
                    .font(.system(size: 30))

                VStack(alignment: .leading, spacing: 4) {
                    Text(vm.text("تقدم اليوم", "Today’s progress"))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)

                    Text(vm.todayMessage)
                        .font(.system(size: 13))
                        .foregroundColor(.black.opacity(0.7))
                        .lineLimit(2)
                }

                Spacer()

                Text("\(Int(vm.todayProgress * 100))%")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
            }

            ProgressView(value: vm.todayProgress)
                .tint(Color.green)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.6))
                        .frame(height: 4)
                )
                .clipShape(Capsule())

            HStack {
                Text(vm.text("إنجاز الأسبوع", "Weekly progress"))
                    .font(.system(size: 13))
                    .foregroundColor(.black.opacity(0.7))

                Spacer()

                Text("\(Int(vm.weeklyProgress * 100))%")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black.opacity(0.8))
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.9))
        )
    }

    private var progressEmoji: String {
        let p = vm.todayProgress
        if p == 1 { return "🤩" }
        if p >= 0.5 { return "🙂" }
        return "😴"
    }

    // MARK: - زر شاشة الإنجازات

    private var achievementsButton: some View {
        HStack {
            Spacer()
            Button {
                showAchievements = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 18))
                    Text(vm.text("إنجازاتي", "My achievements"))
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.95))
                )
                .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Day selector

    private var daySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ScheduleDay.allCases) { day in
                    let isSelected = (day == vm.selectedDay)
                    Text(day.shortLabel(isArabic: vm.isArabic))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .black.opacity(0.7))
                        .frame(width: 36, height: 36)
                        .background(
                            Circle().fill(
                                isSelected
                                ? Color(red: 0.24, green: 0.52, blue: 0.90) // اليوم المختار أزرق
                                : Color.white.opacity(0.9)
                            )
                        )
                        .shadow(color: isSelected ? Color.black.opacity(0.15) : .clear,
                                radius: 3, x: 0, y: 2)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                vm.selectedDay = day
                            }
                        }
                        .accessibilityLabel(day.title(isArabic: vm.isArabic))
                }
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - Task palette

    private var taskPalette: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(vm.text("المهام", "Tasks"))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()

                Button {
                    showManageTasks = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.9))
                        )
                }
                .buttonStyle(.plain)

                Button {
                    showAddTaskSheet = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16))
                        Text(vm.text("إضافة مهمة", "Add task"))
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.white.opacity(0.9)))
                }
                .buttonStyle(.plain)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(vm.templates) { template in
                        let label = vm.isArabic ? template.nameArabic : template.nameEnglish
                        HStack(spacing: 6) {
                            Text(template.emoji)
                            Text(label)
                                .font(.system(size: 14, weight: .medium))
                                .lineLimit(1)
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.9))
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
                        .onDrag {
                            vm.draggingTemplate = template
                            return NSItemProvider(object: template.id.uuidString as NSString)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    // MARK: - Time slots section

    private var timeSlotsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(ScheduleTimeSlot.allCases) { slot in
                TimeSlotRow(
                    vm: vm,
                    day: vm.selectedDay,
                    slot: slot,
                    editingAssignment: $editingAssignment,
                    tempStartTime: $tempStartTime,
                    tempEndTime: $tempEndTime
                )
            }
        }
        .padding(.top, 4)
    }

    // MARK: - تهنئة عند إكمال اليوم

    private var congratsOverlay: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image("taifpic")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)

                Text(vm.text("أحسنت! أنجزت مهام اليوم 🎉", "Great job! You finished today’s tasks 🎉"))
                    .font(.system(size: 18, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)

                Text(vm.text("يمكنك الآن أخذ استراحة أو اللعب قليلاً 🌟", "You can now take a break or play a bit 🌟"))
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black.opacity(0.8))
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(red: 0.99, green: 0.97, blue: 0.90))
            )
            .shadow(radius: 8)
            .padding(.horizontal, 40)
        }
    }
}

// MARK: - TimeSlotRow

private struct TimeSlotRow: View {

    @ObservedObject var vm: ScheduleBoardViewModel
    let day: ScheduleDay
    let slot: ScheduleTimeSlot

    @Binding var editingAssignment: ScheduleAssignment?
    @Binding var tempStartTime: String
    @Binding var tempEndTime: String

    var body: some View {
        let tasks = vm.tasks(for: day, slot: slot)
        let hasTasks = !tasks.isEmpty

        return VStack(alignment: .leading, spacing: 8) {

            HStack(spacing: 8) {
                Text(slot.icon)
                    .font(.system(size: 22))

                Text(slot.title(isArabic: vm.isArabic))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()
            }

            VStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                    .foregroundColor(.gray.opacity(0.4))
                    .frame(height: 46)
                    .overlay(
                        Text(vm.text("اسحب المهمة هنا", "Drop task here"))
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    )
                    .onDrop(of: ["public.utf8-plain-text"], isTargeted: nil) { _ in
                        guard let template = vm.draggingTemplate else { return false }
                        vm.assign(template, to: day, slot: slot)
                        vm.draggingTemplate = nil
                        return true
                    }

                ForEach(tasks) { assignment in
                    taskRow(for: assignment)
                }
            }
            .padding(.horizontal, 4)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    hasTasks
                    ? slot.baseColor.opacity(0.9)
                    : slot.baseColor.opacity(0.5)
                )
        )
    }

    private func taskRow(for assignment: ScheduleAssignment) -> some View {
        let label = vm.isArabic ? assignment.template.nameArabic : assignment.template.nameEnglish

        return HStack(alignment: .center, spacing: 8) {
            Button {
                vm.toggleDone(assignment)
            } label: {
                Image(systemName: assignment.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(assignment.isDone ? .green : .gray)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(assignment.template.emoji)
                    Text(label)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .strikethrough(assignment.isDone, color: .black.opacity(0.7))
                }

                if !assignment.startTime.isEmpty || !assignment.endTime.isEmpty {
                    Text("\(assignment.startTime)  -  \(assignment.endTime)")
                        .font(.system(size: 12))
                        .foregroundColor(.black.opacity(0.7))
                }
            }

            Spacer()

            Button {
                tempStartTime = assignment.startTime
                tempEndTime = assignment.endTime
                editingAssignment = assignment
            } label: {
                Image(systemName: "clock.badge.checkmark")
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.8))
                    .padding(6)
                    .background(Circle().fill(Color.white.opacity(0.9)))
            }

            Button {
                vm.remove(assignment)
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 15))
                    .foregroundColor(.red)
                    .padding(6)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.92))
        )
    }
}

// MARK: - Sheet: إضافة مهمة جديدة

private struct AddTaskSheet: View {

    let isArabic: Bool
    var onSave: (String, String, String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var nameAr: String = ""
    @State private var nameEn: String = ""
    @State private var emoji: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(isArabic ? "اسم المهمة بالعربية" : "Task name (Arabic)", text: $nameAr)
                    TextField(isArabic ? "اسم المهمة بالإنجليزي" : "Task name (English)", text: $nameEn)
                    TextField(isArabic ? "إيموجي (اختياري)" : "Emoji (optional)", text: $emoji)
                }
            }
            .navigationTitle(isArabic ? "إضافة مهمة" : "Add task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(isArabic ? "إلغاء" : "Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isArabic ? "حفظ" : "Save") {
                        onSave(nameAr, nameEn, emoji)
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Sheet: تعديل وقت المهمة

private struct TimeEditSheet: View {

    let isArabic: Bool
    let assignment: ScheduleAssignment
    @State var start: String
    @State var end: String

    var onSave: (String, String) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(isArabic ? "وقت البدء (مثال: 7:00)" : "Start time (e.g. 7:00)", text: $start)
                        .keyboardType(.numbersAndPunctuation)
                    TextField(isArabic ? "وقت الانتهاء (مثال: 7:30)" : "End time (e.g. 7:30)", text: $end)
                        .keyboardType(.numbersAndPunctuation)
                }
            }
            .navigationTitle(isArabic ? "تعديل الوقت" : "Edit time")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(isArabic ? "إلغاء" : "Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isArabic ? "حفظ" : "Save") {
                        onSave(start, end)
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - شاشة إدارة المهام (للأهل)

private struct TaskManagementView: View {

    @ObservedObject var vm: ScheduleBoardViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var editingTemplate: ScheduleTaskTemplate? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.98, green: 0.95, blue: 0.90).ignoresSafeArea()

                List {
                    Section(header: Text(vm.text("قائمة المهام", "Task list"))) {
                        ForEach(vm.templates) { template in
                            HStack(spacing: 10) {
                                Text(template.emoji)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(vm.isArabic ? template.nameArabic : template.nameEnglish)
                                        .font(.system(size: 15, weight: .semibold))
                                    Text(vm.isArabic ? template.nameEnglish : template.nameArabic)
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button {
                                    editingTemplate = template
                                } label: {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 14))
                                }
                                .buttonStyle(.plain)
                                .padding(.trailing, 4)

                                Button {
                                    vm.deleteTemplate(template)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .font(.system(size: 14))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .environment(\.layoutDirection, vm.isArabic ? .rightToLeft : .leftToRight)
            .navigationTitle(vm.text("إدارة المهام", "Manage tasks"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: vm.isArabic ? "chevron.backward" : "chevron.forward")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(item: $editingTemplate) { template in
                TemplateEditSheet(
                    isArabic: vm.isArabic,
                    template: template
                ) { ar, en, emoji in
                    vm.updateTemplate(template, nameArabic: ar, nameEnglish: en, emoji: emoji)
                }
            }
        }
    }
}

// MARK: - Sheet: تعديل بيانات مهمة (اسم/إيموجي)

private struct TemplateEditSheet: View {

    let isArabic: Bool
    let template: ScheduleTaskTemplate
    var onSave: (String, String, String) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var nameAr: String = ""
    @State private var nameEn: String = ""
    @State private var emoji: String = ""

    init(isArabic: Bool,
         template: ScheduleTaskTemplate,
         onSave: @escaping (String, String, String) -> Void) {
        self.isArabic = isArabic
        self.template = template
        self.onSave = onSave
        _nameAr = State(initialValue: template.nameArabic)
        _nameEn = State(initialValue: template.nameEnglish)
        _emoji  = State(initialValue: template.emoji)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(isArabic ? "اسم المهمة بالعربية" : "Task name (Arabic)", text: $nameAr)
                    TextField(isArabic ? "اسم المهمة بالإنجليزي" : "Task name (English)", text: $nameEn)
                    TextField(isArabic ? "الإيموجي" : "Emoji", text: $emoji)
                }
            }
            .navigationTitle(isArabic ? "تعديل مهمة" : "Edit task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(isArabic ? "إلغاء" : "Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isArabic ? "حفظ" : "Save") {
                        onSave(nameAr, nameEn, emoji)
                        dismiss()
                    }
                }
            }
        }
    }
}
