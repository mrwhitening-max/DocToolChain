// Ausgabepfad für die gebauten Dokumente
outputPath = 'build'

// Eingabepfad relativ zum Projektverzeichnis
inputPath = 'src/docs'

// Dokumente und gewünschte Formate
inputFiles = [
    [file: 'arc42.adoc', formats: ['html', 'pdf']],
]

// Verzeichnisse für Bilder
imageDirs = [
    'images/.',
]

// Verzeichnisse und Dateien, die Gradle auf Änderungen überwacht
taskInputsDirs = [
    "${inputPath}",
    "${inputPath}/images",
]
taskInputsFiles = []