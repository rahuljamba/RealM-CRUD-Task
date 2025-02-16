//
//  EducationModel.swift
//  JarvisTask
//
//  Created by Apple on 16/02/25.
//
import RealmSwift

class EducationModel: Object {
    @Persisted var level: String
    @Persisted var stream: String
    @Persisted var startYear: String
    @Persisted var endYear: String
    @Persisted var collageName: String
}
