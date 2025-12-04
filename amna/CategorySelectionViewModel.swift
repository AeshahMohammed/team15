//
//  CategorySelectionViewModel.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//



// هذا الملف الهدف منه التأكد من عمل زر الدخول
// يمكن حذفه بعد ربط زر الدخول بالشاشة الاساسية

import Foundation
import Combine

class CategorySelectionViewModel: ObservableObject {
    
    let user: UserProfile
    
    // أقسام افتراضية (تقدرين تغيرينها)
    let sections: [String] = [
        "الحاجات",
        "الفعاليات",
        "الطعام",
        "الناس",
        "المشاعر",
        "قسم آخر"
    ]
    
    init(user: UserProfile) {
        self.user = user
    }
    
    func didSelectSection(_ section: String) {
        // هنا منطق القسم (مستقبلاً)
        print("Selected section: \(section) for user: \(user.firstName)")
    }
}
