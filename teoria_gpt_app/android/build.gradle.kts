// Set up repositories for all projects
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Set a new root build directory
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

// Apply the new build directory structure to all subprojects
subprojects {
    // Each subproject's build directory will be inside the new root build dir
    layout.buildDirectory.set(newBuildDir.dir(name))
    
    // Ensure app module is evaluated first
    evaluationDependsOn(":app")
}

// Register a clean task that deletes the root build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Add the required classpath dependency for Google services
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.3.15")
    }
}
