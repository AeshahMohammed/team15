//
//  TaskDay.swift
//  team15
//
//  Created by Amna  on 19/06/1447 AH.
//


//
//  TaskModels.swift
//  team15
//
//  نماذج الأيام / الأوقات / المهام
//

import SwiftUI

// MARK: - الأيام
enum TaskDay: String, CaseIterable, Identifiable {
    case saturday  = "السبت"
    case sunday    = "الأحد"
    case monday    = "الاثنين"
    case tuesday   = "الثلاثاء"
    case wednesday = "الأربعاء"
    case thursday  = "الخميس"
    case friday    = "الجمعة"
    
    var id: String { rawValue }
    
    var shortLabel: String {
        switch self {
        case .saturday:  return "س"
        case .sunday:    return "ح"
        case .monday:    return "ن"
        case .tuesday:   return "ث"
        case .wednesday: return "ر"
        case .thursday:  return "خ"
        case .friday:    return "ج"
        }
    }
}

// MARK: - أوقات اليوم (فجر إلى عشاء)
enum TaskTimeSlot: String, CaseIterable, Identifiable {
    case fajr
    case dhuhr
    case asr
    case maghrib
    case isha
    
    var id: String { rawValue }
    
    var titleArabic: String {
        switch self {
        case .fajr:    return "الفجر"
        case .dhuhr:   return "الظهر"
        case .asr:     return "العصر"
        case .maghrib: return "المغرب"
        case .isha:    return "العشاء"
        }
    }
    
    /// إيموجي الوقت – قمر دائري للفجر، وشمس/سحب للباقي
    var icon: String {
        switch self {
        case .fajr:    return "🌕"   // قمر دائري
        case .dhuhr:   return "☀️"
        case .asr:     return "🌤️"
        case .maghrib: return "🌥️"
        case .isha:    return "🌙"
        }
    }
}

// MARK: - نموذج المهمة الأساسية
struct TaskTemplate: Identifiable, Equatable {
    let id: UUID
    var nameArabic: String
    var nameEnglish: String
    var emoji: String
    
    init(id: UUID = UUID(), nameArabic: String, nameEnglish: String, emoji: String) {
        self.id = id
        self.nameArabic = nameArabic
        self.nameEnglish = nameEnglish
        self.emoji = emoji
    }
}

// MARK: - تعيين مهمة في يوم + وقت
struct TaskAssignment: Identifiable, Equatable {
    let id: UUID
    var day: TaskDay
    var slot: TaskTimeSlot
    var template: TaskTemplate
    var isDone: Bool
    var startTime: String
    var endTime: String
    
    init(
        id: UUID = UUID(),
        day: TaskDay,
        slot: TaskTimeSlot,
        template: TaskTemplate,
        isDone: Bool = false,
        startTime: String = "",
        endTime: String = ""
    ) {
        self.id = id
        self.day = day
        self.slot = slot
        self.template = template
        self.isDone = isDone
        self.startTime = startTime
        self.endTime = endTime
    }
}