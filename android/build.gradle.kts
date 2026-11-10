allprojects {
    repositories {
        google()
        mavenCentral()
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
// Algunos plugins antiguos (p. ej. isar_flutter_libs 3.1.0) no declaran el
// `namespace` que exige el Android Gradle Plugin 8+. Lo inyectamos a partir
// del group del proyecto para que compilen sin modificar el pub-cache.
// Debe registrarse ANTES del evaluationDependsOn de abajo.
subprojects {
    afterEvaluate {
        val androidExt = extensions.findByName("android")
        if (androidExt is com.android.build.gradle.BaseExtension) {
            // Inyecta el namespace que exige AGP 8+ si el plugin no lo declara.
            if (androidExt.namespace == null) {
                androidExt.namespace = project.group.toString()
            }
            // Sube compileSdk de plugins antiguos (isar_flutter_libs usa 30)
            // a 36, requerido por dependencias androidx recientes.
            val compiled = androidExt.compileSdkVersion?.removePrefix("android-")
                ?.toIntOrNull() ?: 0
            if (compiled < 36) {
                androidExt.compileSdkVersion(36)
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
