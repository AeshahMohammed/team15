//
//  TaskModels.swift
//  team15
//
//  Created by Amna  on 18/06/1447 AH.
//
//
//  TaskModels.swift
//  team15
//

//
//
//  ScheduleModels.swift
//  team15
//  ScheduleModels.swift
//  team15

import Foundation
import SwiftUI

// MARK: - أيام الأسبوع

enum ScheduleDay: String, CaseIterable, Identifiable {
    case saturday
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday

    var id: String { rawValue }

    func title(isArabic: Bool) -> String {
        if isArabic {
            switch self {
            case .saturday:   return "السبت"
            case .sunday:     return "الأحد"
            case .monday:     return "الإثنين"
            case .tuesday:    return "الثلاثاء"
            case .wednesday:  return "الأربعاء"
            case .thursday:   return "الخميس"
            case .friday:     return "الجمعة"
            }
        } else {
            switch self {
            case .saturday:   return "Saturday"
            case .sunday:     return "Sunday"
            case .monday:     return "Monday"
            case .tuesday:    return "Tuesday"
            case .wednesday:  return "Wednesday"
            case .thursday:   return "Thursday"
            case .friday:     return "Friday"
            }
        }
    }

    func shortLabel(isArabic: Bool) -> String {
        if isArabic {
            switch self {
            case .saturday:   return "س"
            case .sunday:     return "ح"
            case .monday:     return "ن"
            case .tuesday:    return "ث"
            case .wednesday:  return "ر"
            case .thursday:   return "خ"
            case .friday:     return "ج"
            }
        } else {
            switch self {
            case .saturday:   return "Sa"
            case .sunday:     return "Su"
            case .monday:     return "Mo"
            case .tuesday:    return "Tu"
            case .wednesday:  return "We"
            case .thursday:   return "Th"
            case .friday:     return "Fr"
            }
        }
    }
}

// MARK: - أوقات اليوم (على حسب الصلوات)

enum ScheduleTimeSlot: String, CaseIterable, Identifiable {
    case fajr
    case dhuhr
    case asr
    case maghrib
    case isha

    var id: String { rawValue }

    func title(isArabic: Bool) -> String {
        if isArabic {
            switch self {
            case .fajr:     return "الفجر"
            case .dhuhr:    return "الظهر"
            case .asr:      return "العصر"
            case .maghrib:  return "المغرب"
            case .isha:     return "العشاء"
            }
        } else {
            switch self {
            case .fajr:     return "Fajr"
            case .dhuhr:    return "Dhuhr"
            case .asr:      return "Asr"
            case .maghrib:  return "Maghrib"
            case .isha:     return "Isha"
            }
        }
    }

    /// الإيموجي الخاص بالوقت – فجر قمر دائري، ظهر/عصر شمس، مغرب غيوم، عشاء قمر
    var icon: String {
        switch self {
        case .fajr:     return "🌕"    // فجر – قمر دائري
        case .dhuhr:    return "☀️"    // ظهر
        case .asr:      return "🌤️"   // عصر
        case .maghrib:  return "🌥️"   // مغرب
        case .isha:     return "🌙"    // عشاء
        }
    }

    /// لون الخلفية الأساسي لكل خانة وقت (نستغله عشان يكون فيه فرق بين الأوقات)
    var baseColor: Color {
        switch self {
        case .fajr:
            return Color(red: 0.86, green: 0.90, blue: 1.0)   // أزرق فاتح فيه هدوء
        case .dhuhr:
            return Color(red: 0.99, green: 0.96, blue: 0.82)   // أصفر فاتح دافي
        case .asr:
            return Color(red: 0.99, green: 0.91, blue: 0.82)   // برتقالي فاتح
        case .maghrib:
            return Color(red: 0.97, green: 0.88, blue: 0.90)   // وردي هادئ
        case .isha:
            return Color(red: 0.88, green: 0.90, blue: 0.98)   // بنفسجي/أزرق ليل هادي
        }
    }
}

// MARK: - قالب مهمة (في قائمة المهام)

struct ScheduleTaskTemplate: Identifiable, Equatable {
    let id: UUID
    var nameArabic: String
    var nameEnglish: String
    var emoji: String

    init(id: UUID = UUID(),
         nameArabic: String,
         nameEnglish: String,
         emoji: String) {
        self.id = id
        self.nameArabic = nameArabic
        self.nameEnglish = nameEnglish
        self.emoji = emoji
    }
}

// MARK: - مهمة معيّنة داخل الجدول

struct ScheduleAssignment: Identifiable, Equatable {
    let id: UUID
    var day: ScheduleDay
    var slot: ScheduleTimeSlot
    var template: ScheduleTaskTemplate
    var startTime: String
    var endTime: String
    var isDone: Bool

    init(id: UUID = UUID(),
         day: ScheduleDay,
         slot: ScheduleTimeSlot,
         template: ScheduleTaskTemplate,
         startTime: String = "",
         endTime: String = "",
         isDone: Bool = false) {
        self.id = id
        self.day = day
        self.slot = slot
        self.template = template
        self.startTime = startTime
        self.endTime = endTime
        self.isDone = isDone
    }
}
