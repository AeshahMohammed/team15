//
//  TaskModels.swift
//  team15
//
//  Created by Amna  on 18/06/1447 AH.
//
// TaskModels.swift
// team15

//
//  TaskModels.swift
//  team15
//

import SwiftUI

// MARK: - فترات اليوم (أعمدة الجدول)
enum TaskTimeSlot: String, CaseIterable, Identifiable {
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
    
    /// أيقونة صغيرة بجانب اسم الوقت (الكعبة للفجر كما طلبتِ)
    var icon: String {
        switch self {
        case .fajr:     return "morning_sun.fill"
        case .dhuhr:    return "☀️"
        case .asr:      return "🌤"
        case .maghrib:  return "🌇"
        case .isha:     return "🌙"
        }
    }
}

// MARK: - قالب مهمة (من القائمة العلوية)
struct TaskTemplate: Identifiable, Hashable {
    let id = UUID()
    let key: String
    let nameArabic: String
    let nameEnglish: String
    let emoji: String
}

// MARK: - مهمة موضوعة في الجدول
struct TaskAssignment: Identifiable, Hashable {
    let id = UUID()
    var slot: TaskTimeSlot
    var template: TaskTemplate
    var startTime: String   // وقت البدء
    var endTime: String     // وقت الانتهاء
    var isDone: Bool
}
