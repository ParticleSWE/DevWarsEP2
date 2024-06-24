//
//  AllCoursesView.swift
//  DevWarsEP2
//
//  Created by Patrik Ell on 2024-06-23.
//

import SwiftUI
import Foundation

struct Instructor: Codable, Hashable {
    let name: String
    let email: String
}

struct Course: Codable, Hashable {
    let courseTitle: String
    let description: String
    let instructors: [Instructor]
}

struct Subject: Codable, Hashable {
    let subjectName: String
    let courses: [Course]
}

struct CoursesData: Codable {
    let subjects: [Subject]
}

struct AllCoursesView: View {
    
    @EnvironmentObject private var viewModel: CourseViewModel
    
    @State private var showTheAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    if let courseData = parseJSON(filename: "Courses") {
                        ForEach(courseData.subjects, id: \.self) { subject in
                            Section(header: Text(subject.subjectName)) {
                                ForEach(subject.courses, id: \.self) { course in
                                    VStack(alignment: .leading) {
                                        Text(course.courseTitle)
                                            .font(.headline)
                                        Text(course.description)
                                            .font(.subheadline)
                                        ForEach(course.instructors, id: \.self) { instructor in
                                            Text("Instructor: \(instructor.name) (\(instructor.email))")
                                                .font(.caption)
                                        }
                                    }.background {
                                        NavigationLink("", destination: {
                                            ScrollView {
                                                VStack {
                                                    Text("\(course.courseTitle)").font(.title).bold()
                                                    Text("\(subject.subjectName)")
                                                    Divider()
                                                    HStack {
                                                        Text("\(course.description)").font(.title3)
                                                        Spacer()
                                                    }
                                                    Divider()
                                                    HStack {
                                                        Text("Instructors:").font(.title2)
                                                        Spacer()
                                                    }
                                                    ForEach(course.instructors, id: \.self) { instructor in
                                                        Image(instructor.name).resizable().scaledToFit().frame(height: 200).clipShape(Circle()).padding(.top)
                                                        Text("\(instructor.name)")
                                                            .font(.title2)
                                                        Text("\(instructor.email)").padding(.bottom)
                                                    }
                                                    Button("Sign up for course", action: {
                                                        viewModel.addCourseForCurrentUser(courseName: course.courseTitle, isFinished: false)
                                                        showTheAlert.toggle()
                                                    }).buttonStyle(.borderedProminent).font(.title).bold()
                                                }.padding().alert("The course was added to your list of active courses!", isPresented: $showTheAlert) {
                                                    
                                                }
                                            }.background(Color("BackgroundColor").gradient)
                                        }).opacity(0.0)
                                    }
                                }
                            }
                        }
                    }
                }.scrollContentBackground(.hidden)
            }.background(Color("BackgroundColor").gradient)
        }
    }

    func parseJSON(filename: String) -> CoursesData? {
        if let url = Bundle.main.url(forResource: filename, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let coursesData = try decoder.decode(CoursesData.self, from: data)
                return coursesData
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        return nil
    }
}

#Preview {
    AllCoursesView()
}
