//
//  TaskModels.swift
//  team15
//
//  Created by Amna  on 18/06/1447 AH.
//
// TaskModels.swift
// team15

import SwiftUI

/// فترات اليوم (أعمدة الجدول)
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
    
    /// أيقونة صغيرة أعلى العمود – استخدمنا الكعبة للفجر مثل ما طلبتِ
    var icon: String {
        switch self {
        case .fajr:     return "🕋"
        case .dhuhr:    return "☀️"
        case .asr:      return "🌤"
        case .maghrib:  return "🌇"
        case .isha:     return "🌙"
        }
    }
}

/// قالب مهمة (المهام الجاهزة اللي فوق على اليسار)
struct TaskTemplate: Identifiable, Hashable {
    let id = UUID()
    let key: String
    let nameArabic: String
    let nameEnglish: String
    let emoji: String
}

/// مهمة موضوعة في الجدول (بعد السحب والإفلات)
struct AssignedTask: Identifiable, Hashable {
    let id = UUID()
    let template: TaskTemplate
    var isDone: Bool = false
}
