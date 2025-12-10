//
//  TasksBoardViewModel.swift
//  team15
//
//  Created by Amna  on 18/06/1447 AH.
//

//
//
//  TasksBoardViewModel.swift
//  team15
//

//
//  TasksBoardViewModel.swift
//  team15
//
//  ScheduleBoardViewModel.swift
//  team15

//  ScheduleBoardViewModel.swift
//  team15

import SwiftUI
import Combine

final class ScheduleBoardViewModel: ObservableObject {

    @AppStorage("isArabic") var isArabic: Bool = true

    // اليوم الحالي المختار في الجدول
    @Published var selectedDay: ScheduleDay = .saturday

    // قائمة المهام المتاحة للسحب
    @Published private(set) var templates: [ScheduleTaskTemplate]

    // المهام الموجودة في الجدول (لكل يوم ووقت)
    @Published private(set) var assignments: [ScheduleAssignment] = []

    // لمتابعة العنصر الذي يتم سحبه
    @Published var draggingTemplate: ScheduleTaskTemplate? = nil

    init() {
        templates = [
            ScheduleTaskTemplate(nameArabic: "تفريش الأسنان",   nameEnglish: "Brush teeth",      emoji: "🪥"),
            ScheduleTaskTemplate(nameArabic: "غسل اليدين",      nameEnglish: "Wash hands",       emoji: "🧼"),
            ScheduleTaskTemplate(nameArabic: "غسل الوجه",       nameEnglish: "Wash face",        emoji: "🚿"),
            ScheduleTaskTemplate(nameArabic: "الإفطار",         nameEnglish: "Breakfast",        emoji: "🍳"),
            ScheduleTaskTemplate(nameArabic: "تسريح الشعر",     nameEnglish: "Brush hair",       emoji: "💇‍♂️"),
            ScheduleTaskTemplate(nameArabic: "الذهاب للمدرسة",  nameEnglish: "Go to school",     emoji: "🏫"),
            ScheduleTaskTemplate(nameArabic: "حل الواجبات",     nameEnglish: "Homework",         emoji: "📚"),
            ScheduleTaskTemplate(nameArabic: "المذاكرة",        nameEnglish: "Study",            emoji: "📖"),
            ScheduleTaskTemplate(nameArabic: "اللعب",           nameEnglish: "Play",             emoji: "🧸"),
            ScheduleTaskTemplate(nameArabic: "الاستحمام",       nameEnglish: "Shower",           emoji: "🛁"),
            ScheduleTaskTemplate(nameArabic: "ترتيب الغرفة",    nameEnglish: "Tidy room",        emoji: "🧹"),
            ScheduleTaskTemplate(nameArabic: "النوم",           nameEnglish: "Sleep",            emoji: "😴"),
            ScheduleTaskTemplate(nameArabic: "الخروج للنزهة",   nameEnglish: "Outing",           emoji: "🚗"),
            ScheduleTaskTemplate(nameArabic: "زيارة الأقارب",   nameEnglish: "Visit relatives",  emoji: "👨‍👩‍👧‍👦"),
            ScheduleTaskTemplate(nameArabic: "زيارة الجيران",   nameEnglish: "Visit neighbours", emoji: "🏘️"),
            ScheduleTaskTemplate(nameArabic: "الذهاب للطبيب",   nameEnglish: "Doctor visit",     emoji: "🩺"),
            ScheduleTaskTemplate(nameArabic: "التسوق",          nameEnglish: "Shopping",         emoji: "🛍️"),
            ScheduleTaskTemplate(nameArabic: "قراءة قصة",       nameEnglish: "Story time",       emoji: "📚"),
            ScheduleTaskTemplate(nameArabic: "اللعب في الحديقة", nameEnglish: "Park play",       emoji: "🌳"),
            ScheduleTaskTemplate(nameArabic: "اللعب في الملاهي", nameEnglish: "Funfair",         emoji: "🎢")
        ]
    }

    func text(_ ar: String, _ en: String) -> String {
        isArabic ? ar : en
    }

    // MARK: - مهام يوم/وقت معيّن

    func tasks(for day: ScheduleDay, slot: ScheduleTimeSlot) -> [ScheduleAssignment] {
        assignments.filter { $0.day == day && $0.slot == slot }
    }

    func assign(_ template: ScheduleTaskTemplate, to day: ScheduleDay, slot: ScheduleTimeSlot) {
        let new = ScheduleAssignment(day: day, slot: slot, template: template)
        assignments.append(new)
    }

    func updateTime(for assignment: ScheduleAssignment, start: String, end: String) {
        guard let index = assignments.firstIndex(where: { $0.id == assignment.id }) else { return }
        assignments[index].startTime = start
        assignments[index].endTime = end
    }

    func remove(_ assignment: ScheduleAssignment) {
        assignments.removeAll { $0.id == assignment.id }
    }

    func toggleDone(_ assignment: ScheduleAssignment) {
        guard let index = assignments.firstIndex(where: { $0.id == assignment.id }) else { return }
        assignments[index].isDone.toggle()
    }

    // MARK: - إدارة قائمة المهام (Templates)

    func addCustomTemplate(nameArabic: String, nameEnglish: String, emoji: String) {
        let trimmedAr = nameArabic.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEn = nameEnglish.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedAr.isEmpty || !trimmedEn.isEmpty else { return }

        let template = ScheduleTaskTemplate(
            nameArabic: trimmedAr.isEmpty ? trimmedEn : trimmedAr,
            nameEnglish: trimmedEn.isEmpty ? trimmedAr : trimmedEn,
            emoji: emoji.isEmpty ? "⭐️" : emoji
        )
        templates.append(template)
    }

    /// حذف مهمة من القائمة (ومن الجدول لو كانت مستخدمة)
    func deleteTemplate(_ template: ScheduleTaskTemplate) {
        templates.removeAll { $0.id == template.id }
        assignments.removeAll { $0.template.id == template.id }
    }

    /// تعديل مهمة موجودة في القائمة (وتحديث كل النسخ في الجدول)
    func updateTemplate(_ template: ScheduleTaskTemplate,
                        nameArabic: String,
                        nameEnglish: String,
                        emoji: String) {

        guard let index = templates.firstIndex(where: { $0.id == template.id }) else { return }

        let trimmedAr = nameArabic.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEn = nameEnglish.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalEmoji = emoji.isEmpty ? template.emoji : emoji

        let newAr = trimmedAr.isEmpty ? (trimmedEn.isEmpty ? template.nameArabic : trimmedEn) : trimmedAr
        let newEn = trimmedEn.isEmpty ? (trimmedAr.isEmpty ? template.nameEnglish : trimmedAr) : trimmedEn

        templates[index].nameArabic  = newAr
        templates[index].nameEnglish = newEn
        templates[index].emoji       = finalEmoji

        for i in assignments.indices {
            if assignments[i].template.id == template.id {
                assignments[i].template.nameArabic  = newAr
                assignments[i].template.nameEnglish = newEn
                assignments[i].template.emoji       = finalEmoji
            }
        }
    }

    // MARK: - التقدم

    func dailyProgress(for day: ScheduleDay) -> Double {
        let dayAssignments = assignments.filter { $0.day == day }
        guard !dayAssignments.isEmpty else { return 0 }
        let done = dayAssignments.filter { $0.isDone }.count
        return Double(done) / Double(dayAssignments.count)
    }

    var todayProgress: Double {
        dailyProgress(for: selectedDay)
    }

    var weeklyProgress: Double {
        let values = ScheduleDay.allCases.map { dailyProgress(for: $0) }
        let sum = values.reduce(0, +)
        return values.isEmpty ? 0 : sum / Double(values.count)
    }

    var todayMessage: String {
        let p = todayProgress
        if p == 1 {
            return isArabic
            ? "أحسنت! أنجزت كل مهام اليوم 🎉"
            : "Great job! You finished all tasks today 🎉"
        } else if p >= 0.5 {
            return isArabic
            ? "باقي قليل وتكمل اليوم 👏"
            : "Almost there, keep going 👏"
        } else {
            return isArabic
            ? "لنبدأ مهام اليوم خطوة خطوة 🤝"
            : "Let’s start today’s tasks step by step 🤝"
        }
    }
}
