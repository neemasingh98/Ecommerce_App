import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

// =====================
// Global SDK & Kotlin Versions
// =====================
val compileSdkVersion = 36
val minSdkVersion = 23
val targetSdkVersion = 36
val kotlinVersion = "1.9.22"



allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
