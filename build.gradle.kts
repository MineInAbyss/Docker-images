repositories {
    mavenCentral()
    maven("https://repo.mineinabyss.com/releases")
    maven("https://repo.mineinabyss.com/snapshots")
}

configurations {
    create("docs")
}

afterEvaluate {
    val version = file("docs/version").readText()
    dependencies {
        "docs"("me.dvyy:shocky-docs:$version")
    }
}

tasks {
    register<JavaExec>("docsGenerate") {
        classpath = configurations.getByName("docs")
        mainClass.set("me.dvyy.shocky.docs.MainKt")
        args("generate")
    }
    register<JavaExec>("docsServe") {
        classpath = configurations.getByName("docs")
        mainClass.set("me.dvyy.shocky.docs.MainKt")
        args("serve")
    }
}
