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

import SwiftUI
import Combine

class TasksBoardViewModel: ObservableObject {
    
    // إعدادات عامة
    @AppStorage("isArabic") var isArabic: Bool = false
    @AppStorage("childName") var childName: String = "نجد"
    
    // قائمة المهام المتاحة (فوق – للسحب)
    @Published var availableTasks: [TaskTemplate] = [
        TaskTemplate(key: "prayer",         nameArabic: "الصلاة",         nameEnglish: "Prayer",          emoji: "🕌"),
        TaskTemplate(key: "brushTeeth",     nameArabic: "تفريش الأسنان",  nameEnglish: "Brush teeth",     emoji: "🪥"),
        TaskTemplate(key: "washHands",      nameArabic: "غسل اليدين",     nameEnglish: "Wash hands",      emoji: "🧼"),
        TaskTemplate(key: "breakfast",      nameArabic: "الإفطار",        nameEnglish: "Breakfast",       emoji: "🍳"),
        TaskTemplate(key: "school",         nameArabic: "الذهاب للمدرسة", nameEnglish: "Go to school",    emoji: "🎒"),
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
    
    /// المهام المعيَّنة لكل وقت في اليوم
    @Published var schedule: [TaskTimeSlot: [AssignedTask]] = [:]
    
    /// أوقات البدء والانتهاء لكل فترة
    @Published var startTimes: [TaskTimeSlot: String] = [:]
    @Published var endTimes:   [TaskTimeSlot: String] = [:]
    
    /// للمساعدة في السحب والإفلات
    @Published var draggingTemplate: TaskTemplate? = nil
    
    init() {
        // تهيئة القواميس بقيم فارغة
        TaskTimeSlot.allCases.forEach { slot in
            schedule[slot] = []
            startTimes[slot] = ""
            endTimes[slot] = ""
        }
    }
    
    // MARK: - ترجمة نصوص بسيطة
    func title(for english: String, arabic: String) -> String {
        isArabic ? arabic : english
    }
    
    // MARK: - المنطق
    
    func assign(_ template: TaskTemplate, to slot: TaskTimeSlot) {
        var list = schedule[slot] ?? []
        list.append(AssignedTask(template: template))
        schedule[slot] = list
    }
    
    func remove(task: AssignedTask, from slot: TaskTimeSlot) {
        guard var list = schedule[slot] else { return }
        list.removeAll { $0.id == task.id }
        schedule[slot] = list
    }
    
    func toggleDone(slot: TaskTimeSlot, task: AssignedTask) {
        guard var list = schedule[slot] else { return }
        if let index = list.firstIndex(where: { $0.id == task.id }) {
            list[index].isDone.toggle()
            schedule[slot] = list
        }
    }
    
    /// نسبة الإنجاز اليومية (0 - 1)
    var dailyProgress: Double {
        let allTasks = schedule.values.flatMap { $0 }
        guard !allTasks.isEmpty else { return 0 }
        let done = allTasks.filter { $0.isDone }.count
        return Double(done) / Double(allTasks.count)
    }
    
    /// ملصق "أحسنت" لو أنجز كل المهام
    var showWellDoneSticker: Bool {
        let allTasks = schedule.values.flatMap { $0 }
        guard !allTasks.isEmpty else { return false }
        return allTasks.allSatisfy { $0.isDone }
    }
}
