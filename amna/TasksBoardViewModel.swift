//
//  TasksBoardViewModel.swift
//  team15
//
//  Created by Amna  on 18/06/1447 AH.
//

//
//  TasksBoardViewModel.swift
//  team15
//
// TasksBoardViewModel.swift
// team15

//
//  TasksBoardViewModel.swift
//  team15
//

import SwiftUI
import Combine

class TasksBoardViewModel: ObservableObject {
    
    @AppStorage("isArabic") var isArabic: Bool = false
    @AppStorage("childName") var childName: String = "نجد"
    
    // المهام المتاحة للسحب من الأعلى
    @Published var availableTasks: [TaskTemplate] = [
        TaskTemplate(key: "prayer",         nameArabic: "الصلاة",         nameEnglish: "Prayer",          emoji: "🕌"),
        TaskTemplate(key: "brushTeeth",     nameArabic: "تفريش الأسنان",  nameEnglish: "Brush teeth",     emoji: "🪥"),
        TaskTemplate(key: "washHands",      nameArabic: "غسل اليدين",     nameEnglish: "Wash hands",      emoji: "🧼"),
        TaskTemplate(key: "breakfast",      nameArabic: "الفطور",         nameEnglish: "Breakfast",       emoji: "🍳"),
        TaskTemplate(key: "school",         nameArabic: "المدرسة",        nameEnglish: "School",          emoji: "🎒"),
        TaskTemplate(key: "homework",       nameArabic: "حل الواجب",      nameEnglish: "Homework",        emoji: "📚"),
        TaskTemplate(key: "study",          nameArabic: "المذاكرة",       nameEnglish: "Study",           emoji: "📖"),
        TaskTemplate(key: "play",           nameArabic: "اللعب",          nameEnglish: "Play",            emoji: "🧸"),
        TaskTemplate(key: "tidyRoom",       nameArabic: "ترتيب الغرفة",   nameEnglish: "Tidy room",       emoji: "🛏"),
        TaskTemplate(key: "outing",         nameArabic: "الخروج للنزهة",  nameEnglish: "Outing",          emoji: "🚗"),
        TaskTemplate(key: "visitFamily",    nameArabic: "زيارة الأقارب",  nameEnglish: "Visit family",    emoji: "👨‍👩‍👧‍👦"),
        TaskTemplate(key: "doctor",         nameArabic: "زيارة الطبيب",   nameEnglish: "Doctor visit",    emoji: "⚕️"),
        TaskTemplate(key: "shopping",       nameArabic: "التسوق",         nameEnglish: "Shopping",        emoji: "🛒"),
        TaskTemplate(key: "shower",         nameArabic: "الاستحمام",      nameEnglish: "Shower",          emoji: "🧴"),
        TaskTemplate(key: "combHair",       nameArabic: "تمشيط الشعر",    nameEnglish: "Comb hair",       emoji: "💇‍♀️"),
        TaskTemplate(key: "changeClothes",  nameArabic: "تبديل الملابس",  nameEnglish: "Change clothes",  emoji: "👕"),
        TaskTemplate(key: "sleep",          nameArabic: "النوم",          nameEnglish: "Sleep",           emoji: "😴")
    ]
    
    // المهام الموزعة على الجدول: لكل وقت قائمة مهام
    @Published private(set) var schedule: [TaskTimeSlot: [TaskAssignment]] = [:]
    
    // للمساعدة في السحب والإفلات
    @Published var draggingTemplate: TaskTemplate? = nil
    
    init() {
        TaskTimeSlot.allCases.forEach { slot in
            schedule[slot] = []
        }
    }
    
    // نص حسب اللغة
    func text(_ en: String, _ ar: String) -> String {
        isArabic ? ar : en
    }
    
    // إرجاع قائمة المهام لوقت معيّن
    func tasks(for slot: TaskTimeSlot) -> [TaskAssignment] {
        schedule[slot] ?? []
    }
    
    // تعيين مهمة جديدة لوقت معيّن
    func assign(_ template: TaskTemplate, to slot: TaskTimeSlot) {
        var list = schedule[slot] ?? []
        let assignment = TaskAssignment(
            slot: slot,
            template: template,
            startTime: "",
            endTime: "",
            isDone: false
        )
        list.append(assignment)
        schedule[slot] = list
    }
    
    // تبديل إنجاز مهمة
    func toggleDone(_ assignment: TaskAssignment) {
        guard var list = schedule[assignment.slot] else { return }
        if let index = list.firstIndex(where: { $0.id == assignment.id }) {
            list[index].isDone.toggle()
            schedule[assignment.slot] = list
        }
    }
    
    // حذف مهمة
    func remove(_ assignment: TaskAssignment) {
        guard var list = schedule[assignment.slot] else { return }
        list.removeAll { $0.id == assignment.id }
        schedule[assignment.slot] = list
    }
    
    // تحديث وقت البداية والنهاية لمهمة
    func updateTimes(for assignmentID: UUID, start: String, end: String) {
        for slot in TaskTimeSlot.allCases {
            guard var list = schedule[slot] else { continue }
            if let index = list.firstIndex(where: { $0.id == assignmentID }) {
                list[index].startTime = start
                list[index].endTime = end
                schedule[slot] = list
                return
            }
        }
    }
    
    // نسبة الإنجاز
    var dailyProgress: Double {
        let all = schedule.values.flatMap { $0 }
        guard !all.isEmpty else { return 0 }
        let doneCount = all.filter { $0.isDone }.count
        return Double(doneCount) / Double(all.count)
    }
    
    var showWellDoneSticker: Bool {
        let all = schedule.values.flatMap { $0 }
        guard !all.isEmpty else { return false }
        return all.allSatisfy { $0.isDone }
    }
}
